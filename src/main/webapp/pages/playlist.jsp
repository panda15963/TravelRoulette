<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>나의 여행 플레이리스트</title>

    <!-- ✅ 공통 CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">

    <!-- ✅ 페이지 전용 CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/features/music/music.css" />

    <style>
        /* 🎵 페이지 전용 스코프 */
        #playlist-page {
            font-family: "Noto Sans KR", sans-serif;
            background-color: #f7f7f7;
            text-align: center;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 상단 영역 */
        #playlist-header {
            margin-top: 100px; /* navbar 여백 */
        }

        /* 커버 이미지 */
        #playlist-cover {
            width: 180px;
            height: 180px;
            background-color: #ddd;
            border-radius: 12px;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5em;
            color: #777;
        }

        /* 플레이리스트 제목 */
        #playlist-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #333;
            margin-bottom: 25px;
        }

        /* 메인 박스 (배경 연한 파랑) */
        #playlist-box {
            background-color: #eaf3ff;
            border-radius: 12px;
            max-width: 800px;
            margin: 0 auto 40px;
            padding: 25px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        /* 전체 재생 버튼 */
        #playlist-box .btn-playall {
            background-color: #7ab8f5;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            margin-bottom: 15px;
        }
        #playlist-box .btn-playall:hover {
            background-color: #5b9be0;
        }
        .btn-home {
            background-color: #ffffff;
            color: #4e7cfb;
            border: 1px solid #4e7cfb;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            margin-bottom: 10px;
            transition: all 0.2s ease;
        }

        .btn-home:hover {
            background-color: #4e7cfb;
            color: #fff;
        }




        /* 곡 목록 */
        #playlist {
            list-style: none;
            padding: 0;
            margin: 0;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }

        #playlist li {
            background-color: #f2f5f9;
            border-radius: 10px;
            padding: 10px 15px;
            margin: 10px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s ease;
        }

        #playlist li:hover {
            background-color: #e6eefc;
        }

        /* 곡 정보 영역 */
        .track-info {
            display: flex;
            align-items: center;
            gap: 10px;
            text-align: left;
        }

        .track-info img {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            object-fit: cover;
        }

        .track-info div {
            display: flex;
            flex-direction: column;
        }

        .track-info b {
            font-size: 1em;
            color: #222;
        }

        .track-info span {
            font-size: 0.9em;
            color: #555;
        }

        /* ▶ 버튼 */
        .play-btn {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.2em;
            color: #4e7cfb;
            transition: transform 0.1s;
        }
        .play-btn:hover {
            transform: scale(1.2);
        }

        /* footer 항상 하단 */
        footer {
            width: 100vw !important;
            margin: 0 !important;
            padding: 0 !important;
            position: relative;
            left: 0;
            right: 0;
        }



    </style>
</head>

<body id="playlist-page">

<%@ include file="../Common/navbar.jsp" %>

<section id="playlist-header" style="margin-top: 130px;">
    <div id="playlist-cover">🎵</div>
    <div id="playlist-title">playlist</div>
</section>



<section id="playlist-box"
style="margin-top: 5px; margin-bottom:100px;"
>
    <button class="btn-home" onclick="goHome()" style="
    padding-top: 5px;
    padding-bottom: 5px;
    padding-right: 5px;
    padding-left: 5px;
    border-top-width: 0px;
    border-right-width: 0px;
    border-bottom-width: 0px;
    border-left-width: 0px;
    margin-right: 140px;
    margin-bottom: 15px;
">🔍</button>


    <button class="btn-playall" onclick="playAll()" style="
    padding-top: 5px;
    padding-bottom: 5px;
    padding-right: 5px;
    padding-left: 5px;
    width: 120px;
">▶ 전체 재생</button>


    <ul id="playlist"></ul>

    <audio id="player" controls></audio>
</section>

<%@ include file="../Common/footer.jsp" %>



<script>
    async function loadPlaylist() {
        const res = await fetch("../playlist/list");
        //겟 요청
        const list = await res.json();
        const ul = document.getElementById("playlist");

        if (!list || list.length === 0) {
            ul.innerHTML = "<p>아직 추가된 곡이 없습니다 🎵</p>";
            return;
        }

        ul.innerHTML = list.map((t, i) => {
            const coverSrc = String(t.albumCover || "")
                .replace(/^http:\/\//, "https://")
                .trim() || "../../images/default.png";

            const safeTitle = String(t.title || "제목 없음").trim().replace(/"/g, "&quot;");
            const safeArtist = String(t.artist || "아티스트 미상").trim().replace(/"/g, "&quot;");

            return `
      <li onclick="play(\${i})">
        <div class="track-info">
          <img src="\${coverSrc}"
               alt="앨범 커버"
               referrerpolicy="no-referrer"
               onerror="this.src='../../images/default.png';" />
          <div>
            <b>\${safeTitle}</b>
            <span>\${safeArtist}</span>
          </div>
        </div>
        <button class="play-btn"
                onclick="event.stopPropagation(); play(\${i});">▶</button>
      </li>`;
        }).join("");




        console.log("🎯 최종 innerHTML:", document.getElementById("playlist").innerHTML);


        window.tracks = list;
    }

    function play(i) {
        const player = document.getElementById("player");
        player.src = window.tracks[i].previewUrl;
        player.play();
    }

    function playAll() {
        let i = 0;
        const player = document.getElementById("player");
        if (!window.tracks || window.tracks.length === 0) return;
        play(i);
        player.onended = () => {
            i++;
            if (i < window.tracks.length) play(i);
        };
    }

    loadPlaylist();
    function goHome() {
        // 홈 경로는 프로젝트 구조에 따라 변경 가능
        location.href = "<%= request.getContextPath() %>/pages/music.jsp";
    }


</script>




</body>
</html>
