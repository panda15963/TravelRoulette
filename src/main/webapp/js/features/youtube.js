/* youtube.js
 * - YouTube IFrame API + 랜덤/사이클-중복방지 + 비동기 next/prev + 설명 동기화
 * - HTML 요구사항:
 *    1) 플레이어: <div id="ytPlayer" style="aspect-ratio:16/9"></div>
 *    2) 컨트롤:   #btnPrev, #btnNext, #btnShuffle, #btnPlay, #btnStop, #btnBack, #btnFwd, #btnMute, #btnFs
 *    3) 타이틀:   #ytTitle
 *    4) 설명:     #descTitle, #descText, #descLink
 * - 이 페이지에서는 기존 HTML5 <video>용 video.js를 로드하지 마세요 (충돌 방지).
 */

/* -------------------- [0] 중복 로드 가드 -------------------- */
if (window.__YOUTUBE_RANDOMIZER_LOADED__) {
    // 이미 로드된 경우 실행하지 않음(중복 삽입 방지)
} else {
    window.__YOUTUBE_RANDOMIZER_LOADED__ = true;

    /* -------------------- [1] IFrame API 비동기 로드 -------------------- */
    (function loadYT() {
        if (window.YT && window.YT.Player) return; // 이미 로드됨
        var tag = document.createElement("script");
        tag.src = "https://www.youtube.com/iframe_api";
        var first = document.getElementsByTagName("script")[0];
        first.parentNode.insertBefore(tag, first);
    })();

    /* -------------------- [2] 설정: 플레이리스트 & 설명 메타 -------------------- */
    // TODO: 실제 여행지 소개 영상 "ID"로 바꿔 넣으세요.
    // 원하는 만큼 영상 추가 가능
    const PLAYLIST = ["aaGJ_fDcceg", "EtBJZlUMEac", "hHMiBYXsYs4","mJlIWKqVOD0","9ksNt_Q3eRI"];

    // TODO: 영상별 설명(없으면 유튜브 제목/기본 문구 사용)
    const VIDEO_META = {
        "aaGJ_fDcceg": { title: "SINGAPORE", desc: "싱가포르 설명" },
        "EtBJZlUMEac": { title: "HONG KONG", desc: "홍콩 설명" },
        "hHMiBYXsYs4": { title: "NEW YORK", desc: "뉴욕 설명" },
        "mJlIWKqVOD0": { title: "PARIS", desc: "파리 설명" },
        "9ksNt_Q3eRI": { title: "TOKYO", desc: "도쿄 설명" }
    };

    /* -------------------- [3] 내부 상태 -------------------- */
    let player = null;
    let currentOrder = [];    // 이번 사이클 재생 큐(셔플 결과)
    let playedThisCycle = []; // 이번 사이클에서 이미 재생한 ID들
    let lastPlayed = null;    // 직전 재생 ID (사이클 넘길 때 시작 중복 방지)
    let pendingResolve = null;// 비동기 전환(resolve 저장)
    let firstGesture = false; // 첫 사용자 제스처 여부
    let wantMuted = true;     // ★ 사용자가 의도한 음소거 상태(초기 true: 처음 재생도 무조건 음소거)

    // [3.5] UI 헬퍼 (video.js 포팅)
    const STEP = 5;  // ±5초 이동 폭

    function updatePlayBtn() {
        const btnPlay = document.getElementById("btnPlay");
        if (!btnPlay || !player || !player.getPlayerState) return;
        const s = player.getPlayerState();
        if (s === YT.PlayerState.PLAYING) {
            btnPlay.textContent = "⏯️"; btnPlay.title = "일시정지";
        } else { btnPlay.textContent = "▶️"; btnPlay.title = "재생"; }
    }

    function syncMuteBtn() {
        const btnMute = document.getElementById("btnMute");
        if (!btnMute || !player || !player.isMuted) return;
        if (player.isMuted()) {
            btnMute.textContent = "🔈";
            btnMute.title = "소리";
        }else {

            btnMute.textContent = "🔇";
            btnMute.title = "음소거";
        }
    }

    function updateTimeText() {
        const el = document.getElementById("time");
        if (!el || !player || !player.getCurrentTime) return;
        const cur = Math.max(0, Math.floor(player.getCurrentTime() || 0));
        const dur = Math.max(0, Math.floor(player.getDuration ? player.getDuration() : 0));
        const fmt = (sec)=>{ const h=Math.floor(sec/3600),m=Math.floor((sec%3600)/60),s=sec%60;
            return (h?h+":":"")+String(m).padStart(2,"0")+":"+String(s).padStart(2,"0"); };
        el.textContent = `${fmt(cur)} / ${fmt(dur)}`;
    }

    // ★ 공통: 현재 wantMuted 의도를 실제 플레이어에 강제 적용
    function applyIntendedMute() {
        try {
            if (!player) return;
            if (wantMuted) player.mute();
            else player.unMute();
        } catch (_) {}
        syncMuteBtn();
    }

    /* -------------------- [4] 유틸: 셔플 & 다음 ID -------------------- */
    function shuffle(arr) {
        const a = arr.slice();
        for (let i = a.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [a[i], a[j]] = [a[j], a[i]];
        }
        return a;
    }

    function getNextVideoId() {
        // 큐 소진 시 새 사이클 시작
        if (currentOrder.length === 0) {
            currentOrder = shuffle(PLAYLIST);
            // 새 사이클 시작 영상이 직전 영상과 같으면 뒤로 미룸(시작 중복 방지)
            if (lastPlayed && currentOrder.length > 1 && currentOrder[0] === lastPlayed) {
                const first = currentOrder.shift();
                currentOrder.push(first);
            }
            playedThisCycle = [];
        }

        const next = currentOrder.shift();

        // 방금 전과 같은 ID면 한 칸 더 밀기(안전장치)
        if (next === lastPlayed && currentOrder.length > 0) {
            currentOrder.push(next);
            return currentOrder.shift();
        }

        playedThisCycle.push(next);
        lastPlayed = next;
        return next;
    }

    /* -------------------- [5] IFrame API Ready (전역 네임 필요) -------------------- */
    function onYouTubeIframeAPIReady() {
        // 플레이어 컨테이너가 없으면 실행하지 않음(다른 페이지 보호)
        const container = document.getElementById("ytPlayer");
        if (!container) return;

        player = new YT.Player("ytPlayer", {
            width: "100%",
            height: "100%",
            videoId: getNextVideoId(),
            playerVars: {
                rel: 0,
                modestbranding: 1,
                playsinline: 1,
                controls: 0,    // 유튜브 기본 컨트롤 숨김
                disablekb: 1    // YT 기본 키 입력 비활성화(우리가 직접 단축키 제공)
            },
            events: { onReady: handleReady, onStateChange: handleState, onError: handleError }
        });
    }
    // 전역에 단 한 번만 바인딩
    window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;

    function handleReady(e) {

        try { e.target.mute(); } catch(_) {}
        try { e.target.playVideo(); } catch(_) {}

        // 초기 UI 동기화
        updatePlayBtn();
        syncMuteBtn();   // ★ 여기서 호출 → 시작 시 바로 🔇 표시됨
        updateTimeText();
        updateMetaUI();
        wireControls();   // 버튼 이벤트 연결(한 번만)

        // 시간표시 주기 업데이트
        setInterval(updateTimeText, 500);
    }

    /* -------------------- [6] 상태 변화 -------------------- */
    function handleState(e) {
        if (e.data === YT.PlayerState.PLAYING) {
            // ★ PLAYING에서도 의도 상태를 한 번 더 강제(특정 브라우저/정책 대비)
            applyIntendedMute();

            if (typeof pendingResolve === "function") { pendingResolve(); pendingResolve = null; }
            updatePlayBtn();
            updateMetaUISoon();
        } else if (e.data === YT.PlayerState.PAUSED) {
            updatePlayBtn();
        } else if (e.data === YT.PlayerState.ENDED) {
            updatePlayBtn();
            nextAsync();
        } else if (e.data === YT.PlayerState.UNSTARTED) {
            // 3초 내 시작 못하면 다음으로 스킵
            setTimeout(() => {
                if (player.getPlayerState() === YT.PlayerState.UNSTARTED) nextAsync();
            }, 3000);
        }
    }

    function handleError(e){
        console.warn("YT onError:", e?.data, "video:", lastPlayed);
        // 재생 불가(임베드 제한/연령 제한 등) 시 다음 영상으로 스킵
        nextAsync();
    }

    /* -------------------- [7] 비동기 전환 -------------------- */
    function playByIdAsync(id) {
        return new Promise((resolve) => {
            pendingResolve = resolve;
            player.loadVideoById(id);

            // ★ 로드 직후에도 의도 상태를 즉시 적용
            applyIntendedMute();

            // 혹시 PLAYING 이벤트 지연 대비 백업 타임아웃(선택)
            setTimeout(() => {
                if (pendingResolve) { pendingResolve(); pendingResolve = null; }
            }, 4000);
        });
    }

    async function nextAsync() {
        const id = getNextVideoId();
        await playByIdAsync(id); // 재생 시작(PLAYING)까지 대기
        updateMetaUI();          // 설명 갱신
    }

    async function prevAsync() {
        // 간단 이전: 현재 것 pop → 직전 것 재생
        if (playedThisCycle.length >= 2) {
            const current = playedThisCycle.pop();
            const prev = playedThisCycle[playedThisCycle.length - 1];
            // 현재 것을 다시 앞으로 돌려놓아 다음에 재등장 가능하게 함
            currentOrder.unshift(current);
            await playByIdAsync(prev);
            lastPlayed = prev;
            updateMetaUI();
        }
    }

    /* -------------------- [8] 설명/제목 UI 갱신 -------------------- */
    function updateMetaUI() {
        if (!player) return;
        const data = player.getVideoData ? player.getVideoData() : null;
        const id = data && data.video_id ? data.video_id : lastPlayed;
        const titleFromYT = data && data.title ? data.title : "재생 중…";
        const meta = VIDEO_META[id] || {};

        const $ytTitle   = document.getElementById("ytTitle");
        const $descTitle = document.getElementById("descTitle");
        const $descText  = document.getElementById("descText");
        const $descLink  = document.getElementById("descLink");

        if ($ytTitle)   $ytTitle.textContent   = titleFromYT;
        if ($descTitle) $descTitle.textContent = meta.title || titleFromYT;
        if ($descText)  $descText.textContent  = meta.desc  || "이 영상에 대한 설명이 준비되어 있습니다.";
        if ($descLink)  $descLink.href         = "https://www.youtube.com/watch?v=" + (id || "");
    }
    function updateMetaUISoon(){ setTimeout(updateMetaUI, 150); }

    /* -------------------- [9] 버튼 바인딩 (단일 함수로 통합) -------------------- */
    function wireControls() {
        // (A) 재생 목록 컨트롤
        const btnNext    = document.getElementById("btnNext");
        const btnPrev    = document.getElementById("btnPrev");
        const btnShuffle = document.getElementById("btnShuffle");

        // (B) 플레이어 기본 컨트롤
        const btnPlay = document.getElementById("btnPlay");
        const btnStop = document.getElementById("btnStop");
        const btnBack = document.getElementById("btnBack");
        const btnFwd  = document.getElementById("btnFwd");
        const btnMute = document.getElementById("btnMute");
        const btnFs   = document.getElementById("btnFs");

        // ★ 첫 사용자 제스처 기록(언뮤트는 여기서 절대 하지 않음)
        function markGesture() {
            if (!firstGesture && player) { firstGesture = true; }
        }

        // --- (A) 재생 목록 컨트롤 이벤트 ---
        btnNext    && btnNext.addEventListener("click", async ()=>{ markGesture(); await nextAsync(); });
        btnPrev    && btnPrev.addEventListener("click", async ()=>{ markGesture(); await prevAsync(); });
        btnShuffle && btnShuffle.addEventListener("click", async ()=>{
            markGesture();
            currentOrder = [];
            await nextAsync();
        });

        // --- (B) 플레이어 기본 컨트롤 이벤트 ---
        function togglePlay() {
            const s = player.getPlayerState();
            if (s === YT.PlayerState.PLAYING) {
                player.pauseVideo();
            } else {
                // ★ 재생 직전에도 의도 상태 강제
                applyIntendedMute();
                player.playVideo();
            }
        }
        function stop() {
            try { player.pauseVideo(); } catch(_) {}
            try { player.seekTo(0, true); } catch(_) {}
        }
        function skip(delta) {
            const t = player.getCurrentTime ? player.getCurrentTime() : 0;
            player.seekTo(Math.max(0, t + delta), true);
        }
        function goFullscreen() {
            const el = document.getElementById("ytPlayer");
            if (!el) return;
            if (document.fullscreenElement) document.exitFullscreen?.();
            else el.requestFullscreen?.();
        }

        // ★ 음소거 토글: 오직 여기서만 wantMuted를 변경
        function toggleMuteIntended() {
            wantMuted = !(player.isMuted && player.isMuted());
            applyIntendedMute();  // 버튼/키 입력 시 즉시 적용 + UI 동기화
        }

        btnPlay?.addEventListener("click", ()=>{ markGesture(); togglePlay(); updatePlayBtn(); });
        btnStop?.addEventListener("click", ()=>{ markGesture(); stop(); updatePlayBtn(); updateTimeText(); });
        btnBack?.addEventListener("click", ()=>{ markGesture(); skip(-5); });
        btnFwd ?.addEventListener("click", ()=>{ markGesture(); skip( 5); });
        btnMute?.addEventListener("click", ()=>{ markGesture(); toggleMuteIntended(); });
        btnFs  ?.addEventListener("click", ()=>{ markGesture(); goFullscreen(); });

        // 키보드 단축키
        window.addEventListener("keydown", (e) => {
            const tag = (e.target && e.target.tagName) || "";
            if (["INPUT","TEXTAREA"].includes(tag)) return;
            const k = (e.key || "").toLowerCase();
            if (e.code === "Space" || k === "k") { e.preventDefault(); togglePlay(); updatePlayBtn(); }
            else if (k === "j") skip(-5);
            else if (k === "l") skip( 5);
            else if (k === "m") { toggleMuteIntended(); }
            else if (k === "f") goFullscreen();
        });
    }

}
