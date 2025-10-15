<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Deezer 음악 검색</title>

    <!-- ✅ 공통 CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">

    <!-- ✅ 페이지 전용 CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/features/music/music.css">

    <style>
        /* 🎵 페이지 스코프: 다른 CSS와 충돌 방지 */
        #music-page {
            font-family: "Noto Sans KR", sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        /* ✅ navbar 때문에 상단 여백 추가 */
        #music-page main,
        #music-page section {
            margin-top: 100px; /* navbar 높이만큼 내려줌 */
        }

        /* ✅ 재생바 스타일 */
        #music-page #seek-bar {
            width: 40%;
            margin: 10px auto;
            display: block;
            accent-color: #4e7cfb;
            height: 6px;
            border-radius: 5px;
            cursor: pointer;
        }

        @media (min-width: 1200px) {
            #music-page #seek-bar { width: 30%; }
        }

        @media (max-width: 768px) {
            #music-page #seek-bar { width: 80%; }
        }

        /* ✅ 플레이리스트 카드 hover 효과 */
        #music-page #playlist-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        /* ✅ footer 공백 제거 (footer.jsp 수정 없이) */
        footer {
            width: 100vw !important;
            margin: 0 !important;
            padding: 0 !important;
            position: relative;
            left: 0;
            right: 0;
            bottom: 0;
        }
    </style>
</head>

<body id="music-page">
<%@ include file="../Common/navbar.jsp" %>

<!-- 🎵 미니 플레이어 -->
<section id="player-section">
    <div class="album-art">
        <img id="album-cover" src="../images/default.png" alt="Album Cover">
        <div class="light-reflection"></div>
    </div>



    <h2 id="track-title" style="
    margin-top: 30px;
    margin-bottom: 30px;">재생 중인 곡 없음</h2>

    <p id="track-artist"></p>

    <input type="range" id="seek-bar" value="0" max="100" style="
    margin-bottom: 20px;">

    <div class="buttons">
        <button id="prev-btn">⏮</button>
        <button id="play-btn">▶</button>
        <button id="next-btn">⏭</button>
    </div>

    <audio id="main-player"></audio>
</section>

<!-- 🎶 Deezer 검색 -->
<main>

    <h3 style="margin-bottom: 35px;">
        🎵 어떤 음악을 찾으시나요?</h3>

    <input type="text" id="query" placeholder="가수나 곡 이름 입력">

    <button onclick="searchDeezer()" style="
    margin-left: 10px;
">검색</button>

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
          margin: 40px auto;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          box-shadow: 0 2px 6px rgba(0,0,0,0.1);
          transition: all 0.2s ease;">
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

<script src="../js/features/deezer.js"></script>

<%@ include file="../Common/footer.jsp" %>
</body>
</html>