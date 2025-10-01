<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>Dohee's Profile</title>
	<link href = "../../css/styles.css" rel = "stylesheet" />
	<!-- Bootstrap CSS -->
	<link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />
    <style>
        /* ===============================
           공통: 색상/간격 변수
        ================================*/
        :root {
            color-scheme: light only; /* 확장/OS 다크 강제화 방지 */
            --primary: #0d6efd;
            --primary-hover: #0b5ed7;
            --primary-dark: #0a58ca;

            --border: #ddd;
            --card: #fff;
            --muted: #f5f5f5;

            --progress-bg: #e9eefc;
            --progress-bar: var(--primary);

            --accent: #6ea8fe; /* 선택 포커스/강조용 */
            --radius: 12px;
            --radius-sm: 10px;
            --shadow-card: 0 6px 20px rgba(0, 0, 0, 0.06);
        }

        html, body { background:#fff; color:#111; }
        [hidden] { display: none !important; }
        section { margin: 28px 0; }

        /* ===============================
           갤러리
        ================================*/
        .gallery-frame {
            width: min(90vw, 600px);
            aspect-ratio: 3 / 2;
            border-radius: var(--radius);
            overflow: hidden;
            background: #eee;
            margin: 10px 0;
        }
        .gallery-frame > img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .gallery-controls {
            margin-top: 10px;
            display: flex;
            gap: 8px;
            align-items: center;
        }

        /* ===============================
           소개 카드(프로필)
        ================================*/
        .jin-profile {
            display: grid;
            grid-template-columns: 160px 1fr;
            gap: 16px;
            max-width: 680px;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: var(--radius);
            padding: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.04);
        }
        .jin-avatar {
            width: 160px;
            aspect-ratio: 1/1;
            border-radius: var(--radius);
            object-fit: cover;
            background: #ddd;
        }
        .chips { display: flex; flex-wrap: wrap; gap: 8px; margin: 8px 0; }
        .chip  { padding: 4px 8px; border-radius: 9999px; border: 1px solid #e5e5e5; font-size: 12px; background: #fff; }
        .meta-grid { display: grid; grid-template-columns: 100px 1fr; gap: 6px 12px; margin-top: 10px; }
        .meta-grid span { opacity: .7; }
        .btn-tiny { padding: 4px 8px; border: 1px solid var(--border); border-radius: 8px; background: #fff; cursor: pointer; font-size: 12px; }
        .fact-card { margin-top: 10px; background: #fff; border: 1px solid #eee; border-radius: 10px; padding: 10px; }

        /* ===============================
           비디오
        ================================*/
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 16px;
            align-items: start;
        }
        .video-card {
            position: relative;
            aspect-ratio: 16 / 9;
            border-radius: var(--radius);
            overflow: hidden;
            background: #000;
            box-shadow: 0 6px 20px rgba(0,0,0,.08);
        }
        .video-card > video { width: 100%; height: 100%; object-fit: cover; display: block; }
        .video-card figcaption {
            position: absolute; left: 12px; bottom: 10px;
            color: #fff; font-size: 14px;
            background: rgba(0,0,0,.45); padding: 4px 8px; border-radius: 8px; backdrop-filter: blur(2px);
        }

        /* ===============================
           퀴즈
        ================================*/
        .quiz-section { max-width: 720px; }
        .quiz-card {
            background: var(--card);
            border: 1px solid #eee;
            border-radius: var(--radius);
            padding: 16px;
            box-shadow: var(--shadow-card);
        }
        .quiz-q { font-weight: 600; margin-bottom: 12px; }
        .quiz-choices { display: grid; gap: 8px; margin: 12px 0; }
        .quiz-choice {
            padding: 10px 12px; border-radius: var(--radius-sm);
            border: 1px solid var(--border); background: #fff; cursor: pointer; text-align: left;
        }
        /* 선택/포커스 색: 파랑 */
        .quiz-choice[aria-checked="true"] {
            border-color: var(--accent);
            box-shadow: inset 0 0 0 2px var(--accent);
        }
        .quiz-choice:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow:
                    0 0 0 3px rgba(110,168,254,.35),
                    inset 0 0 0 2px var(--accent);
        }

        .quiz-actions { display: flex; gap: 8px; justify-content: flex-end; }

        /* 진행바(검정 → 파랑) */
        .quiz-progress {
            height: 8px; border-radius: 9999px; overflow: hidden; margin: 12px 0;
            background: var(--progress-bg);
            box-shadow: inset 0 0 0 1px #dbe3ff;
        }
        .quiz-bar { height: 100%; width: 0%; background: var(--progress-bar); transition: width .3s ease; }

        /* ===============================
           결과 모달(부트스트랩과 클래스 충돌 방지)
        ================================*/
        .jin-modal-backdrop {
            position: fixed; inset: 0;
            background: rgba(0,0,0,.4);
            display: none; align-items: center; justify-content: center;
            z-index: 1055; /* Bootstrap 모달보다 위 */
        }
        .jin-modal {
            background: #fff; border-radius: var(--radius); padding: 20px; width: min(90vw, 420px);
            box-shadow: 0 12px 40px rgba(0,0,0,.25);
        }
        .jin-modal .btn-row { display: flex; justify-content: flex-end; gap: 10px; }

        /* 제출 버튼을 갤러리의 '일시정지(파랑)'와 동일하게 */
        #quizSubmit.btn {
            background: var(--primary) !important;
            border-color: var(--primary) !important;
            color: #fff !important;
        }
        #quizSubmit.btn:hover {
            background: var(--primary-hover) !important;
            border-color: var(--primary-dark) !important;
        }
    </style>
</head>
<body id = "pageBody" class = "d-flex flex-column h-100"
      style = "background-color:#fff; color:#000;" data-mode = "light">

<%@ include file = "/common/navbar.jsp" %>
<%@ include file = "/common/sidebar.jsp" %>

<!-- 프로필 상세 섹션 -->
<div class="container my-4">
    <!-- =========================
         소개(프로필)
    ========================== -->
    <section id="intro">
        <h2>Intro</h2>
        <div class="jin-profile">
            <img class="jin-avatar" src="../../images/dohee/1.jpg" alt="진이 프로필 사진" />
            <div class="jin-meta">
                <h3>양 진</h3>
                <div class="chips">
                    <span class="chip">산책 좋아</span>
                    <span class="chip">사람 좋아</span>
                    <span class="chip">간식 좋아</span>
                </div>

                <div class="meta-grid">
                    <span>나이</span><div><span id="jin-age">-</span></div>
                    <span>품종</span><div>오스트레일리안 실키테리어</div>
                    <span>체중</span><div><span id="jin-weight" data-kg="4.0">4.0kg</span></div>
                </div>

                <details class="mt-2">
                    <summary>Info</summary>
                    <ul class="mt-2 ms-3">
                        <li>2016-05-22: 진이 생일</li>
                        <li>2016-09-17: 가족 된 날</li>
                        <li>개인기 잘해요</li>
                        <li>물을 좋아해요</li>
                        <li>언니들을 좋아해요</li>
                        <li>요크셔테리어아니고 실키테리어</li>
                    </ul>
                </details>

                <div class="fact-card">
                    <div id="fact-line">오늘의 진이 한 줄 소개를 불러오는 중…</div>
                    <button id="factBtn" class="btn-tiny mt-2" type="button">다른 문장 보기</button>
                </div>
            </div>
        </div>
    </section>

    <hr />

    <!-- =========================
         갤러리(슬라이드)
    ========================== -->
    <section id="gallery">
        <h2>JIN'S GALLERY</h2>
        <div class="gallery-frame">
            <img id="imgs" src="../../images/dohee/1.jpg" alt="인형 물고 있는 진이" />
        </div>
        <div class="gallery-controls">
            <button id="prv"  type="button" class="btn btn-outline-secondary btn-sm">이전</button>
            <button id="next" type="button" class="btn btn-outline-secondary btn-sm">다음</button>
            <button id="playtoggle" type="button" class="btn btn-primary btn-sm" aria-pressed="true">일시정지</button>
        </div>
    </section>

    <hr />

    <!-- =========================
         퀴즈
    ========================== -->
    <section id="quiz" class="quiz-section">
        <h2>Quiz</h2>
        <div class="quiz-progress" aria-hidden="true">
            <div id="quizBar" class="quiz-bar"></div>
        </div>

        <div class="quiz-deck">
            <div id="quizCard" class="quiz-card" role="group" aria-labelledby="quizQ">
                <div id="quizQ" class="quiz-q">문제를 불러오는 중…</div>
                <div id="quizChoices" class="quiz-choices"></div>
                <div id="quizExplain" style="display:none; font-size:14px; opacity:.8;"></div>

                <div class="quiz-actions">
                    <button id="quizPrev"   class="btn btn-outline-secondary btn-sm" type="button">이전</button>
                    <button id="quizNext"   class="btn btn-outline-secondary btn-sm" type="button">다음</button>
                    <button id="quizSubmit" class="btn btn-primary btn-sm" type="button" hidden>제출</button>
                </div>
            </div>
        </div>
    </section>

    <!-- 결과 모달(부트스트랩 모달 아님) -->
    <div id="quizModal" class="jin-modal-backdrop" aria-hidden="true">
        <div class="jin-modal" role="dialog" aria-modal="true" aria-labelledby="quizResultTitle">
            <h3 id="quizResultTitle">퀴즈 결과</h3>
            <p id="quizResultText">점수: -</p>
            <div class="btn-row">
                <button id="quizRestart" class="btn btn-outline-secondary btn-sm" type="button">재도전</button>
                <button id="quizClose"   class="btn btn-primary btn-sm" type="button">끝</button>
            </div>
        </div>
    </div>

    <hr />

    <!-- =========================
         비디오
    ========================== -->
    <section id="video" class="video-section">
        <h2>JIN'S VIDEO</h2>
        <div class="video-grid">
            <figure class="video-card">
                <video src="../../videos/1.mp4" autoplay muted loop playsinline poster="images/1-thumb.jpg"></video>
                <figcaption>식탁 위에서</figcaption>
            </figure>
            <figure class="video-card">
                <video src="../../videos/2.mp4" autoplay muted loop playsinline poster="images/2-thumb.jpg"></video>
                <figcaption>기절잠 자는 중</figcaption>
            </figure>
            <figure class="video-card">
                <video src="../../videos/3.mp4" autoplay muted loop playsinline poster="images/3-thumb.jpg"></video>
                <figcaption>자는 진이 건드리기</figcaption>
            </figure>
        </div>
    </section>
</div>

<!-- (선택) Bootstrap JS: 현재는 자체 모달을 써서 필수는 아님 -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"
></script>

<script>
    /* 전통문법 전용 유틸: 나이 계산 */
    function computeAge(iso) {
        var b   = new Date(iso + "T00:00:00");
        var now = new Date();
        var years  = now.getFullYear() - b.getFullYear();
        var months = now.getMonth()    - b.getMonth();
        var days   = now.getDate()     - b.getDate();
        if (days < 0) months--;
        if (months < 0) { years--; months += 12; }
        return (years <= 0) ? (months + "개월") : ("만 " + years + "세 (" + years + "년 " + months + "개월)");
    }

    /* DOM 준비 후 실행 */
    document.addEventListener("DOMContentLoaded", function() {

        /* =========================
           1) 갤러리(슬라이드)
        ========================== */
        (function initGallery(){
            var myPhotos = ["../../images/dohee/1.jpg","../../images/dohee/2.jpg","../../images/dohee/3.jpg","../../images/dohee/4.jpg","../../images/dohee/5.jpg"];
            var SLIDE_MS = 3000;
            var index = 0, timerId = null, isPlaying = true;

            var img   = document.querySelector("#imgs");
            var prv   = document.querySelector("#prv");
            var next  = document.querySelector("#next");
            var playT = document.querySelector("#playtoggle");
            var wrap  = document.querySelector("#gallery");

            function show(i) {
                index = (i + myPhotos.length) % myPhotos.length;
                img.src = myPhotos[index];
            }
            function goN(){ show(index + 1); }
            function goP(){ show(index - 1); }
            function sync(){
                playT.textContent = isPlaying ? "일시정지" : "재생";
                playT.setAttribute("aria-pressed", isPlaying ? "true" : "false");
            }
            function play(){ if (timerId) return; timerId = setInterval(goN, SLIDE_MS); isPlaying = true;  sync(); }
            function pause(){ if (!timerId) return; clearInterval(timerId); timerId = null; isPlaying = false; sync(); }
            function toggle(){ if (isPlaying) pause(); else play(); }

            /* 초기화 */
            img.src = myPhotos[0];
            for (var i=0;i<myPhotos.length;i++){ var pre = new Image(); pre.src = myPhotos[i]; }

            prv.addEventListener("click", goP);
            next.addEventListener("click", goN);
            playT.addEventListener("click", toggle);
            wrap.addEventListener("mouseenter", pause);
            wrap.addEventListener("mouseleave", play);

            document.addEventListener("keydown", function(e){
                var modal = document.querySelector("#quizModal");
                var quiz  = document.querySelector("#quiz");
                var modalOpen = modal && (modal.style.display === "flex");
                var inQuiz    = quiz  && (quiz.contains(e.target) || quiz.contains(document.activeElement));
                if (modalOpen || inQuiz) return;
                if (e.key === "ArrowRight") goN();
                if (e.key === "ArrowLeft")  goP();
                if (e.key === " ") { e.preventDefault(); toggle(); }
            });

            play(); /* 자동 재생 시작 */
        })();

        /* =========================
           2) 소개(프로필)
        ========================== */
        (function initIntro(){
            var BIRTHDAY = "2016-05-22";
            var ageSpan  = document.querySelector("#jin-age");
            if (ageSpan) ageSpan.textContent = computeAge(BIRTHDAY);

            var facts = [
                "산책 가는 걸 엄청 좋아해요",
                "계란 까는 소리만 들어도 달려와요",
                "하루의 마무리로 항상 개껌을 먹어요",
                "언니들을 좋아해요",
                "사진 찍는 걸 안 좋아해요",
                "강아지를 안 좋아해요"
            ];
            var factLine = document.querySelector("#fact-line");
            var factBtn  = document.querySelector("#factBtn");

            function draw(){
                if (!factLine) return;
                var idx = Math.floor(Math.random() * facts.length);
                factLine.textContent = facts[idx];
            }
            draw();
            if (factBtn) factBtn.addEventListener("click", draw);
        })();

        /* =========================
           3) 퀴즈
        ========================== */
        (function initQuiz(){
            var qs = [
                { q:"진이가 가장 좋아하는 간식은?", choices:["노른자","고구마","사과","개껌"], ans:1, exp:"고구마!" },
                { q:"산책 시간대는 언제가 제일 신나나요?", choices:["아침","점심","저녁","새벽"], ans:0, exp:"사실 다 좋아하긴 해요" },
                { q:"진이가 태어난 달은?", choices:["5월","7월","9월","11월"], ans:0, exp:"5월에 태어났어요" },
                { q:"첫 산책에서 먹은 것은?", choices:["개미","지렁이","매미","똥"], ans:1, exp:"지렁이...먹었어요" },
                { q:"진이가 싫어하는 것은?", choices:["비오는 날","목욕","양치","드라이기 소리"], ans:3, exp:"드라이기 싫어해요" }
            ];

            var idx = 0;
            var choiceSel   = new Array(qs.length);
            for (var c=0;c<choiceSel.length;c++) choiceSel[c] = null;

            var quizQ       = document.querySelector("#quizQ");
            var quizChoices = document.querySelector("#quizChoices");
            var bar         = document.querySelector("#quizBar");
            var btnPrev     = document.querySelector("#quizPrev");
            var btnNext     = document.querySelector("#quizNext");
            var btnSubmit   = document.querySelector("#quizSubmit");

            var modal       = document.querySelector("#quizModal");
            var resultText  = document.querySelector("#quizResultText");
            var btnRestart  = document.querySelector("#quizRestart");
            var btnClose    = document.querySelector("#quizClose");

            function render(){
                var item = qs[idx];
                quizQ.textContent = "Q" + (idx+1) + ". " + item.q;

                /* 보기 생성 */
                quizChoices.innerHTML = "";
                for (var i=0;i<item.choices.length;i++){
                    (function(iCopy){
                        var b = document.createElement("button");
                        b.type = "button";
                        b.className = "quiz-choice";
                        b.textContent = item.choices[iCopy];
                        b.setAttribute("role","radio");
                        b.setAttribute("aria-checked", (choiceSel[idx] === iCopy) ? "true" : "false");
                        b.addEventListener("click", function(){
                            choiceSel[idx] = iCopy;
                            render();
                        });
                        quizChoices.appendChild(b);
                    })(i);
                }

                /* 진행바(마지막에 100%) */
                var prog = Math.round(((idx + 1) / qs.length) * 100);
                bar.style.width = prog + "%";

                /* 네비 버튼 토글 */
                btnPrev.disabled = (idx === 0);
                var last = (idx === qs.length - 1);

                btnNext.hidden = last;
                btnNext.style.display = last ? "none" : "inline-block";

                btnSubmit.hidden = !last;
                btnSubmit.style.display = last ? "inline-block" : "none";
            }

            btnPrev.addEventListener("click", function(){ idx = Math.max(0, idx - 1); render(); });
            btnNext.addEventListener("click", function(){ idx = Math.min(qs.length - 1, idx + 1); render(); });

            btnSubmit.addEventListener("click", function(){
                var score = 0;
                var review = [];
                for (var i=0;i<qs.length;i++){
                    var ok = (choiceSel[i] === qs[i].ans);
                    if (ok) score++;
                    review.push("Q" + (i+1) + ": " + (ok ? "정답!" : "땡!") + " — " + qs[i].exp);
                }
                resultText.innerHTML = "점수: <b>" + score + " / " + qs.length + "</b><br><br>" + review.join("<br>");
                modal.style.display = "flex";
                modal.setAttribute("aria-hidden","false");
            });

            btnClose.addEventListener("click", function(){
                modal.style.display = "none";
                modal.setAttribute("aria-hidden","true");
            });

            btnRestart.addEventListener("click", function(){
                idx = 0;
                for (var i=0;i<choiceSel.length;i++) choiceSel[i] = null;
                modal.style.display = "none";
                modal.setAttribute("aria-hidden","true");
                render();
            });

            /* 퀴즈 내 키보드 조작 */
            document.addEventListener("keydown", function(e){
                var quiz = document.querySelector("#quiz");
                if (!quiz || !quiz.contains(e.target)) return;
                if (e.key === "ArrowRight") { e.preventDefault(); btnNext.click(); }
                if (e.key === "ArrowLeft")  { e.preventDefault(); btnPrev.click(); }
                if (e.key === "Enter" && !btnSubmit.hidden) { e.preventDefault(); btnSubmit.click(); }
            });

            render();
        })();

    });
</script>

<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src = "../../js/features/darkmode.js"></script>
</body>
</html>