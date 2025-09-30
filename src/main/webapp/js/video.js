
document.addEventListener('DOMContentLoaded', () => {

    const player = document.getElementById('player');

    //비디오 기본 컨트롤 바 제거
    player.controls = false;
    player.removeAttribute('controls');

    const btnPlay = document.getElementById('btnPlay');
    const btnStop = document.getElementById('btnStop');
    const btnBack = document.getElementById('btnBack');
    const btnFwd  = document.getElementById('btnFwd');
    const btnMute = document.getElementById('btnMute');
    const btnFs   = document.getElementById('btnFs');
    const timeEl  = document.getElementById('time');


    //화면 표시용 함수
    const fmt = t => {
        if (!Number.isFinite(t)) return '00:00';
        const s = String(Math.floor(t%60)).padStart(2,'0');
        const m = String(Math.floor(t/60)%60).padStart(2,'0');
        const h = Math.floor(t/3600);
        return (h ? h + ':' : '') + m + ':' + s;
    };
    //현재시간/전체시간 글자 표시
    const updateTime = () => {
        timeEl.textContent = fmt(player.currentTime) + ' / ' + fmt(player.duration || 0);
    };
    //재생 버튼 글자 표시
    /*
    const updatePlayBtn = () => {
        if (btnPlay) btnPlay.textContent = player.paused ? '▶️' : '⏯️';
    };
    */
    const updatePlayBtn = () => {
        if (!btnPlay) return;
        if (player.paused) {
            btnPlay.textContent = '▶️';
            btnPlay.title = '재생';

        } else {
            btnPlay.textContent = '⏯️';
            btnPlay.title = '일시정지';
        }
    };

    //음소거 버튼 글자 표시
    /*
    const syncMuteBtn = () => {
        if (btnMute) btnMute.textContent = player.muted ? '🔊' : '🔇';
    };
    */
    const syncMuteBtn = () => {

        if (player.muted) {
            btnMute.textContent = '🔇';
            btnMute.title = '음소거 해제';

        } else {
            btnMute.textContent = '🔊';
            btnMute.title = '음소거';
        }
    };

    //초기 상태 세팅
    updatePlayBtn();
    syncMuteBtn();
    updateTime();

    //비디오 이벤트 등록
    player.addEventListener('loadedmetadata', updateTime);
    player.addEventListener('timeupdate', updateTime);
    player.addEventListener('play', updatePlayBtn);
    player.addEventListener('pause', updatePlayBtn);
    player.addEventListener('ended', updatePlayBtn);
    player.addEventListener('volumechange', syncMuteBtn);

    //버튼 이벤트
    const STEP = 5;

    btnPlay && btnPlay.addEventListener('click', () => {
        player.paused ? player.play() : player.pause();
    });
    btnStop && btnStop.addEventListener('click', () => {
        player.pause();
        player.currentTime = 0;
        updatePlayBtn();
    });
    btnBack && btnBack.addEventListener('click', () => {
        player.currentTime = Math.max(0, (player.currentTime || 0)-STEP);
    });
    btnFwd && btnFwd.addEventListener('click', () => {
        const dur = Number.isFinite(player.duration) ? player.duration : Infinity;
        player.currentTime = Math.min(dur, (player.currentTime || 0)+STEP);
    });
    btnMute && btnMute.addEventListener('click', () => {
        player.muted = !player.muted;
    });
    btnFs && btnFs.addEventListener('click', () => {
        try {
            if (document.fullscreenElement) document.exitFullscreen();
            else player.requestFullscreen();
        } catch (e) { console.warn('Fullscreen 실패:', e); }
    });

    //키보드 단축키
    document.addEventListener('keydown', (e) => {
        const t = e.target || document.body;
        const tag = (t && t.tagName) ? t.tagName.toUpperCase() : '';

        // 입력창/편집영역에서는 단축키 비활성
        if (tag === 'INPUT' || tag === 'TEXTAREA' || (t && t.isContentEditable)) return;

        const k = (e.key ? String(e.key) : '').toLowerCase();

        if (e.code === 'Space' || k === 'k') {
            e.preventDefault();
            player.paused ? player.play() : player.pause();
        } else if (k === 'j') {
            player.currentTime = Math.max(0, player.currentTime-STEP);
        } else if (k === 'l') {
            const dur = Number.isFinite(player.duration) ? player.duration : Infinity;
            player.currentTime = Math.min(dur, player.currentTime+STEP);
        } else if (k === 'm') {
            player.muted = !player.muted;
        }
    });

});
