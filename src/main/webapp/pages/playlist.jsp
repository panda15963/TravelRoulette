<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>나의 여행 플레이리스트</title>

    <!-- ✅ 새 구조에 맞춘 CSS 경로 -->
    <link rel="stylesheet" href="../../css/features/music/music.css" />

    <style>
        body {
            font-family: "Noto Sans KR", sans-serif;
            background-color: #f7f7f7;
            text-align: center;
            margin: 0;
            padding: 20px;
        }
        h2 { margin-bottom: 20px; }
        ul { list-style: none; padding: 0; }
        li {
            background: white;
            margin: 8px auto;
            padding: 10px;
            width: 60%;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        li img { width: 50px; border-radius: 8px; margin-right: 10px; }
        li div { text-align: left; flex: 1; }
        button {
            background-color: #7ab8f5;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 6px;
            cursor: pointer;
        }
        #player { margin-top: 30px; }
    </style>
</head>
<body>

<h2>🎶 나의 여행 플레이리스트</h2>

<ul id="playlist"></ul>

<div>
    <button onclick="playAll()">▶ 전체 재생</button>
    <button onclick="clearList()">🗑 전체 비우기</button>
</div>

<audio id="player" controls></audio>

<script>
    // ✅ 플레이리스트 불러오기
    async function loadPlaylist() {
        // ✅ 컨트롤러 경로는 그대로 (세션 유지)
        const res = await fetch("../playlist/list");
        const list = await res.json();
        const ul = document.getElementById("playlist");

        if (!list || list.length === 0) {
            ul.innerHTML = "<p>아직 추가된 곡이 없습니다 🎵</p>";
            return;
        }

        // ✅ 리스트 렌더링
        ul.innerHTML = list.map((t, i) => {
            let coverSrc = (t.albumCover || "").trim();

            // ✅ http → https 변환
            if (coverSrc.startsWith("http://")) {
                coverSrc = coverSrc.replace(/^http:\/\//, "https://");
            }

            // ✅ Deezer 이미지가 아니거나 비어 있으면 fallback
            if (!/^https?:\/\//.test(coverSrc)) {
                coverSrc = "../../images/default.png";
            }

            // ✅ 안전 문자열 처리
            const safeTitle = (t.title || "제목 없음").replace(/"/g, "&quot;");
            const safeArtist = (t.artist || "아티스트 미상").replace(/"/g, "&quot;");

            return `
          <li onclick="play(${i})"
              style="display:flex;align-items:center;justify-content:space-between;
                     gap:10px;border-bottom:1px solid #ddd;padding:8px 0;">
            <div style="display:flex;align-items:center;gap:10px;">
              <img src="${coverSrc}"
                   alt="앨범 커버"
                   referrerpolicy="no-referrer"
                   onerror="this.src='../../images/default.png';"
                   style="width:60px;height:60px;border-radius:8px;object-fit:cover;">
              <div style="text-align:left;">
                <b>${safeTitle}</b><br>
                <span style="font-size:0.9em;color:#555;">${safeArtist}</span>
              </div>
            </div>
            <button onclick="event.stopPropagation(); play(${i});"
                    style="background:none;border:none;cursor:pointer;font-size:1.2em;">▶</button>
          </li>`;
        }).join("");

        window.tracks = list;
    }

    // ✅ 단일 곡 재생
    function play(i) {
        const player = document.getElementById("player");
        player.src = window.tracks[i].previewUrl;
        player.play();
    }

    // ✅ 전체 재생 기능
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
