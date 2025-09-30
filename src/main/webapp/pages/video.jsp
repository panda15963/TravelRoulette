<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Video</title>
    <link href="../css/styles.css" rel="stylesheet" />
    <!-- 버튼은 커스텀 스타일 사용 -->

    <style>
        /* ===============================
           Video Controls — Modern Minimal
           =============================== */
        :root{
            --vp-radius: 14px;
            --vp-gap: 12px;
            --vp-surface: #ffffff;
            --vp-text: #1f2937;
            --vp-muted: #6b7280;
            --vp-border: rgba(0,0,0,.12);
            --vp-shadow-1: 0 8px 20px rgba(0,0,0,.08);
            --vp-shadow-press: inset 0 2px 6px rgba(0,0,0,.14);
            --vp-btn-bg: linear-gradient(180deg,#ffffff,#f5f6f8);
            --vp-btn-bg-hover: linear-gradient(180deg,#ffffff,#eef1f5);
        }
        @media (prefers-color-scheme: dark){
            :root{
                --vp-surface:#0b0f14; --vp-text:#e5e7eb; --vp-muted:#9ca3af;
                --vp-border:rgba(255,255,255,.14); --vp-shadow-1:0 12px 30px rgba(0,0,0,.45);
                --vp-shadow-press: inset 0 2px 6px rgba(255,255,255,.06);
                --vp-btn-bg:linear-gradient(180deg,#1a1f27,#151a21);
                --vp-btn-bg-hover:linear-gradient(180deg,#222833,#1a1f27);
            }
        }

        #player{ display:block; max-width:100%; height:auto; border-radius:var(--vp-radius); box-shadow:var(--vp-shadow-1); }

        /* 통일 버튼 */
        .vp-btn{
            position:static!important; display:inline-flex; align-items:center; justify-content:center;
            width:46px; height:46px; margin:0; padding:0!important;
            border-radius:12px; border:1px solid var(--vp-border)!important;
            background:var(--vp-btn-bg)!important; color:var(--vp-text)!important;
            font-size:20px; line-height:1; text-decoration:none;
            transition:transform .12s, box-shadow .12s, background .12s, border-color .12s;
        }
        .vp-btn:hover{ transform:translateY(-1px); background:var(--vp-btn-bg-hover)!important; box-shadow:var(--vp-shadow-1); }
        .vp-btn:active{ transform:translateY(0); box-shadow:var(--vp-shadow-press); }
        .vp-btn:focus-visible{ outline:2px solid color-mix(in srgb, #0d6efd 70%, transparent); outline-offset:2px; }

        /* 툴바 레이아웃 */
        .vp-toolbar{ max-width:960px; margin:0 auto; display:flex; flex-direction:column; gap:14px; }
        .vp-row{ display:flex; align-items:center; justify-content:space-between; gap:12px; }
        .vp-group{ display:flex; align-items:center; gap:12px; flex-wrap:wrap; }
        .vp-aside{ display:flex; align-items:center; gap:10px; color:var(--vp-muted); font-size:14px; }

        #time{ font-variant-numeric:tabular-nums; }

        @media (max-width:576px){
            .vp-row{ flex-direction:column; align-items:flex-start; }
            .vp-aside{ align-self:flex-end; }
            .vp-btn{ width:40px; height:40px; font-size:18px; }
        }
    </style>
</head>
<body id="pageBody" class="d-flex flex-column min-vh-100" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<header class="bg-dark text-white py-5 mb-4 mt-5">
    <div class="container">
        <h1 class="display-6 mb-1">여행지 소개 Video</h1>
        <p class="lead opacity-75 mb-0">아래 플레이어에서 영상을 감상하세요</p>
    </div>
</header>

<main class="flex-shrink-0">
    <div class="container pb-5">

        <h2 id="video-title" class="h4 fw-semibold mb-3">Let's GO!</h2>

        <div class="card shadow-lg border-0 rounded-4 mb-4">
            <div class="card-body p-3 p-md-4">

                <!-- 플레이어 -->
                <div id="playerWrap" class="ratio ratio-16x9 rounded-4 overflow-hidden mb-3">
                    <div id="ytPlayer" class="w-100"></div>
                </div>

                <!-- 정돈된 2줄 툴바 -->
                <div class="vp-toolbar">

                    <!-- 1줄: 재생목록 컨트롤 + 시간/제목(옵션) -->
                    <div class="vp-row">
                        <div class="vp-group">
                            <button id="btnPrev"    type="button" title="이전 영상"  aria-label="이전 영상"  class="vp-btn">⬅️</button>
                            <button id="btnNext"    type="button" title="다음 영상"  aria-label="다음 영상"  class="vp-btn">➡️</button>
                            <button id="btnShuffle" type="button" title="셔플 재생"  aria-label="셔플 재생"  class="vp-btn">🔀</button>
                        </div>
                        <div class="vp-aside">
                            <!-- 필요하면 제목도 노출: <span id="ytTitle">제목 불러오는 중…</span> -->
                            <span id="time">00:00 / 00:00</span>
                        </div>
                    </div>

                    <!-- 2줄: 플레이어 컨트롤 + 보조 버튼 -->
                    <div class="vp-row">
                        <div class="vp-group">
                            <button type="button" id="btnBack"  title="5초 전"     aria-label="5초 전으로 돌아가기" class="vp-btn">⏪</button>
                            <button type="button" id="btnPlay"                      aria-label="재생/일시정지"      class="vp-btn">▶️</button>
                            <button type="button" id="btnStop"  title="처음부터"    aria-label="처음부터 재생하기"  class="vp-btn">⏹️️</button>
                            <button type="button" id="btnFwd"   title="5초 후"     aria-label="5초 후로 건너뛰기" class="vp-btn">⏩</button>
                        </div>
                        <div class="vp-group">
                            <button type="button" id="btnMute"                     aria-label="음소거"             class="vp-btn">🔇</button>
                            <button type="button" id="btnFs"    title="전체화면"   aria-label="전체화면"           class="vp-btn">⛶</button>
                        </div>
                    </div>

                </div>
                <!-- /툴바 -->

            </div>
        </div>

        <!-- 설명 카드 -->
        <div class="card border-0 rounded-4 shadow-sm">
            <div class="card-body">
                <h3 id="descTitle" class="h5 fw-semibold mb-2">영상 설명</h3>
                <p id="descText" class="mb-0 small text-muted">영상을 설명하는 텍스트를 보여주는 부분입니다.</p>

            </div>
        </div>

    </div>
</main>

<script src="../js/youtube.js"></script>
</body>
</html>
