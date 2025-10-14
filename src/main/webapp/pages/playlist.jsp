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
        /* ✅ 페이지 전용 영역 (CSS 충돌 방지용) */
        #playlist-page {
            font-family: "Noto Sans KR", sans-serif;
            background-color: #f7f7f7;
            text-align: center;
            margin: 0;
            padding: 0;
            min-height: 100vh; /* footer를 화면 하단에 고정시키기 위한 기반 */
            display: flex;
            flex-direction: column;
        }

        /* ✅ navbar 높이만큼 상단 여백 확보 */
        #playlist-content {
            flex: 1; /* footer 제외 나머지 영역 확장 */
            padding-top: 100px;
        }

        /* ✅ 제목 */
        #playlist-content h2 {
            margin-bottom: 20px;
        }

        /* ✅ 리스트 전체 컨테이너 */
        #playlist-content ul {
            list-style: none;
            padding: 0;
            margin: 0 auto;
            width: 100%;
            max-width: 800px;
        }

        /* ✅ 개별 아이템 */
        #playlist-content li {
            background: white;
            margin: 8px auto;
            padding: 10px 20px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.1s ease-in-out;
        }

        #playlist-content li:hover {
            transform: scale(1.01);
        }

        /* ✅ 앨범 이미지 */
        #playlist-content li img {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            margin-right: 10px;
            object-fit: cover;
        }

        /* ✅ 곡 정보 텍스트 */
        #playlist-content li div {
            text-align: left;
            flex: 1;
        }

        /* ✅ 버튼 */
        #playlist-content button {
            background-color: #7ab8f5;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s ease-in-out;
        }

        #playlist-content button:hover {
            background-color: #5d9bea;
        }

        /* ✅ 오디오 플레이어 */
        #playlist-content audio {
            margin-top: 30px;
        }

        /* ✅ footer 여백 제거 (footer.jsp 수정 없이 적용됨) */
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

<main id="playlist-content">
    <h2>🎶 나의 여행 플레이리스트</h2>

    <ul id="playlist"></ul>

    <div>
        <button onclick="playAll()">▶ 전체 재생</button>
        <button onclick="clearList()">🗑 전체 비우기</button>
    </div>

    <audio id="player" controls></audio>
</main>

<%@ include file="../Common/footer.jsp" %>

<script>
    // ✅ 플레이리스트 불러오기
    async function loadPlaylist() {
        const res = await fetch("../playlist/list");
        const list = await res.json();
        const ul = document.getElementById("playlist");

        if (!list || list.length === 0) {
            ul.innerHTML = "<p>아직 추가된 곡이 없습니다 🎵</p>";
            return;
        }

        ul.innerHTML = list.map((t, i) => {
            let coverSrc = (t.albumCover || "").trim();

            if (coverSrc.startsWith("http://")) {
                coverSrc = coverSrc.replace(/^http:\/\//, "https://");
            }

            if (!/^https?:\/\//.test(coverSrc)) {
                coverSrc = "../../images/default.png";
            }

            const safeTitle = (t.title || "제목 없음").replace(/"/g, "&quot;");
            const safeArtist = (t.artist || "아티스트 미상").replace(/"/g, "&quot;");

            return `
                <li onclick="play(${i})">
                    <div style="display:flex;align-items:center;gap:10px;">
                        <img src="${coverSrc}" alt="앨범 커버"
                             referrerpolicy="no-referrer"
                             onerror="this.src='../../images/default.png';">
                        <div>
                            <b>${safeTitle}</b><br>
                            <span style="font-size:0.9em;color:#555;">${safeArtist}</span>
                        </div>
                    </div>
                    <button onclick="event.stopPropagation(); play(${i});">▶</button>
                </li>`;
        }).join("");

        window.tracks = list;
    }

    // ✅ 단일곡 재생
    function play(i) {
        const player = document.getElementById("player");
        player.src = window.tracks[i].previewUrl;
        player.play();
    }

    // ✅ 전체 재생
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

    // ✅ 전체 비우기
    async function clearList() {
        await fetch("../playlist/clear", { method: "POST" });
        alert("🗑 플레이리스트가 비워졌습니다.");
        loadPlaylist();
    }

    // ✅ 페이지 로드 시 자동 실행
    loadPlaylist();
</script>
</body>
</html>
