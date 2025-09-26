<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Video</title>
	<link href="../css/styles.css" rel="stylesheet" />
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<!-- Video 내용 -->

<h1>여행지 소개 Video</h1>

<hr>

<h2 id="video-title">영상 제목</h2>

<div id="playerWrap" style="width: 640px;">
    <video id="player" width="640" height="360" playsinline webkit-playsinline>
        <source
                src="https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4"
                type="video/mp4">
    </video>
</div>

<div id="controls" aria-label="비디오 커스텀 컨트롤">
    <button id="btnPlay" type="button" aria-label="재생 또는 일시정지">▶️ 재생</button>
    <button id="btnStop" type="button" aria-label="정지하고 처음으로">⏹️ 정지</button>
    <button id="btnBack" type="button" aria-label="5초 뒤로 이동">⏪ -5s</button>
    <button id="btnFwd" type="button" aria-label="5초 앞으로 이동">⏩ +5s</button>
    <button id="btnMute" type="button" aria-label="음소거 토글">🔇 음소거</button>
    <button id="btnFs" type="button" aria-label="전체화면">⛶ 전체화면</button>
</div>

<!-- 시간 표시 -->
<p style="margin-top: 8px">
    ⏱ <span id="time">00:00 / 00:00</span>
</p>


<script defer src="../js/video.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/features/darkmode.js"></script>
</body>
</html>