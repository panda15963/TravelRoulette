<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../assets/favicon.ico?v=2" />
    <link href="../css/styles.css" rel="stylesheet" />
    <link href="../css/features/video/video.css" rel="stylesheet" />
</head>
<body id="pageBody" class="d-flex flex-column min-vh-100" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

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

<script src="../js/features/youtube.js"></script>
<script src="../js/features/darkmode.js"></script>
</body>
</html>
