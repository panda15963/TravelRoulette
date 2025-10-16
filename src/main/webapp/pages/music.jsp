<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Deezer 음악 검색</title>

    <!-- ✅ 공통 CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">

    <!-- ✅ 페이지 전용 CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/features/music/music.css">


</head>

<body id="music-page">
<%@ include file="../Common/navbar.jsp" %>

<!-- 🎵 미니 플레이어 -->
<section id="player-section"
style ="margin-top: 150px; margin-bottom: 100px;"
>
    <div class="album-art">
        <img id="album-cover" src="../../images/default.png" alt="Album Cover">
        <div class="light-reflection"></div>
    </div>





    <h2 id="track-title" style="
    margin-top: 30px;
    margin-bottom: 30px;">재생 중인 곡 없음</h2>

    <p id="track-artist"></p>

    <input type="range" id="seek-bar" value="0" max="100">


    <div class="buttons">

        <button id="play-btn">▶</button>

    </div>

    <audio id="main-player"></audio>
</section>

<!-- 🎶 Deezer 검색 -->
<main>

    <h3 style="margin-bottom: 30px;">🎵 어떤 음악을 찾으시나요?</h3>

    <div class="search-box">
        <input type="text" id="query" placeholder="가수나 곡 이름 입력">
        <button id="search-btn" onclick="searchDeezer()" style="margin-left: 10px;">🔍</button>

    </div>


    <div id="result"></div>
</main>

<!-- 🎵 나의 플레이리스트 카드 -->
<section id="my-playlist" style="margin: 40px 0; border-top-width: 40px; padding-top: 100px; padding-bottom: 100px;">
    <h3 style="text-align: left; margin-left: 20%;">나의 여행 플레이리스트</h3>

    <div id="playlist-card" onclick="openPlaylist()" style="margin-top: 80px;">
        <span style="font-size: 2em;">🎵</span>
        <p style="margin: 8px 0 0; font-weight: 500;">나의 플레이리스트</p>
    </div>

</section>

<script>
    // ✅ playlist.jsp로 이동
    function openPlaylist() {
        location.href = "playlist.jsp";
    }
</script>

<script src="../../js/features/deezer.js"></script>

<%@ include file="../Common/footer.jsp" %>
</body>
</html>
