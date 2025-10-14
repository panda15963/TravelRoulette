<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Deezer 음악 검색</title>

    <!-- ✅ 새 구조 기준 CSS 경로 수정 -->
    <link rel="stylesheet" href="../../css/features/music/music.css">

    <style>
        #playlist-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body>

<!-- 🎵 미니 플레이어 -->
<section id="player-section">
    <div class="album-art">
        <!-- ✅ 이미지 경로 수정: 절대경로 → 상대경로 (프로젝트 구조 일관성) -->
        <img id="album-cover" src="../../images/default.png" alt="Album Cover">
        <div class="light-reflection"></div>
    </div>

    <h2 id="track-title">재생 중인 곡 없음</h2>
    <p id="track-artist"></p>

    <input type="range" id="seek-bar" value="0" max="100">

    <div class="buttons">
        <button id="prev-btn">⏮</button>
        <button id="play-btn">▶</button>
        <button id="next-btn">⏭</button>
    </div>

    <audio id="main-player"></audio>
</section>

<!-- 🎶 Deezer 검색 섹션 -->
<main>
    <h1>🎵 <b>Deezer</b> 음악 검색</h1>
    <input type="text" id="query" placeholder="가수나 곡 이름 입력">
    <button onclick="searchDeezer()">검색</button>
    <div id="result"></div>
</main>

<!-- 🎵 나의 플레이리스트 카드 -->
<section id="my-playlist" style="margin: 40px 0;">
    <h3 style="text-align: left; margin-left: 20%;">나의 여행 플레이리스트</h3>

    <div id="playlist-card"
         onclick="openPlaylist()"
         style="
          width: 200px;
          height: 120px;
          background-color: #e8f2ff;
          border-radius: 16px;
          margin: 20px auto;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          box-shadow: 0 2px 6px rgba(0,0,0,0.1);
          transition: all 0.2s ease;
        ">
        <span style="font-size: 2em;">🎵</span>
        <p style="margin: 8px 0 0; font-weight: 500;">나의 플레이리스트</p>
    </div>
</section>

<!-- ✅ playlist.jsp로 이동 -->
<script>
    function openPlaylist() {
        location.href = "playlist.jsp"; // pages/ 안에서의 상대경로
    }
</script>

<!-- ✅ JS 경로 수정 -->
<script src="../../js/features/deezer.js"></script>

</body>
</html>
