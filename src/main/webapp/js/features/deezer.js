const player = document.getElementById("main-player");
const titleEl = document.getElementById("track-title");
const artistEl = document.getElementById("track-artist");
const coverEl = document.getElementById("album-cover");
const seekBar = document.getElementById("seek-bar");
const playBtn = document.getElementById("play-btn");

let currentTrack = null;

// ✅ Deezer 검색
async function searchDeezer() {
    const query = document.getElementById("query").value.trim();
    const resultDiv = document.getElementById("result");
    resultDiv.innerHTML = "검색 중...";

    if (!query) {
        resultDiv.innerHTML = "검색어를 입력하세요.";
        return;
    }

    try {
        const url = `https://api.deezer.com/search?q=${encodeURIComponent(query)}&output=jsonp`;
        const response = await fetchJsonp(url);
        const data = await response.json();

        resultDiv.innerHTML = data.data
            .map((t) => {
                // ✅ 안전한 커버 URL (fallback 포함)
                const coverUrl =
                    t.album.cover_medium ||
                    t.album.cover ||
                    t.album.cover_big ||
                    t.album.cover_xl ||
                    "";

                const safeData = encodeURIComponent(
                    JSON.stringify({
                        title: t.title,
                        artist: t.artist.name,
                        previewUrl: t.preview, // ✅ Track.java와 필드명 동일
                        cover: coverUrl
                    })
                );

                return `
          <div class="track"
               style="display:flex; align-items:center; justify-content:space-between; gap:10px;
                      border-bottom:1px solid #ddd; padding:8px 0;
                      ">
            <div style="display:flex; align-items:center; gap:10px; cursor:pointer;padding-left: 10px;"
                 onclick="playEncoded('${safeData}')">
              <img src="${coverUrl}"
                   alt="cover"
                   onerror="this.src='../../images/default.png';"
                   style="width:50px;height:50px;border-radius:6px;object-fit:cover;">
              <div style="text-align:left;">
                <b>${t.title}</b><br>
                <span style="font-size:0.9em;color:#555;">${t.artist.name}</span>
              </div>              
            </div>
            <button class="add-btn"
                    onclick="addToPlaylist(event, '${safeData}')" style="padding-right: 10px;">➕</button>
          </div>`;
            })
            .join("");
    } catch (e) {
        console.error(e);
        resultDiv.innerHTML = "❌ 오류: API 호출 실패";
    }
}

// ✅ 클릭 시 재생
function playEncoded(encodedData) {
    const data = JSON.parse(decodeURIComponent(encodedData));
    playTrack(data.title, data.artist, data.previewUrl, data.cover);
}

// ✅ 메인 플레이어 제어
function playTrack(title, artist, previewUrl, albumCover) {
    const albumArtEl = document.querySelector(".album-art");

    if (!previewUrl) {
        titleEl.textContent = "⚠️ 미리듣기 없음";
        artistEl.textContent = "";
        coverEl.src = getDefaultCover();
        player.pause();
        albumArtEl.classList.remove("playing");
        return;
    }

    currentTrack = previewUrl;
    player.src = previewUrl;
    player.play();

    titleEl.textContent = title;
    artistEl.textContent = artist;
    coverEl.src = albumCover || getDefaultCover();

    playBtn.textContent = "⏸";
    albumArtEl.classList.add("playing");
}

// ✅ 재생 / 일시정지 버튼
playBtn.addEventListener("click", () => {
    const albumArtEl = document.querySelector(".album-art");
    if (!player.src) return;
    if (player.paused) {
        player.play();
        playBtn.textContent = "⏸";
        albumArtEl.classList.add("playing");
    } else {
        player.pause();
        playBtn.textContent = "▶";
        albumArtEl.classList.remove("playing");
    }
});

// ✅ 시크바 동기화
player.addEventListener("timeupdate", () => {
    if (player.duration) {
        seekBar.value = (player.currentTime / player.duration) * 100;
    }
});

// ✅ 시크바 제어
seekBar.addEventListener("input", () => {
    if (player.duration) {
        player.currentTime = (seekBar.value / 100) * player.duration;
    }
});

// ✅ JSONP 유틸
function fetchJsonp(url) {
    return new Promise((resolve, reject) => {
        const callbackName = "jsonp_callback_" + Math.round(100000 * Math.random());
        const script = document.createElement("script");
        script.src = url + "&callback=" + callbackName;
        document.body.appendChild(script);

        window[callbackName] = (data) => {
            resolve({ json: () => Promise.resolve(data) });
            script.remove();
            delete window[callbackName];
        };

        script.onerror = reject;
    });
}

// ✅ 기본 앨범 커버 경로 유틸 (프로젝트 구조 맞춤)
function getDefaultCover() {
    return "../../images/default.png";
}

// ✅ 플레이리스트에 추가 (서버 연동)
async function addToPlaylist(event, encoded) {
    event.stopPropagation(); // 부모 클릭 방지
    const data = JSON.parse(decodeURIComponent(encoded));

    try {
        const res = await fetch("../playlist/add", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            // ✅ Track.java의 필드명과 완벽히 일치
            body: JSON.stringify({
                title: data.title,
                artist: data.artist,
                previewUrl: data.previewUrl,
                albumCover: data.cover
            }),


        });

        if (!res.ok) {
            throw new Error("서버 응답 오류: " + res.status);
        }

        alert(`✅ ${data.title} 플레이리스트에 추가 성공`);
    } catch (err) {
        console.error("❌ addToPlaylist 오류:", err);
        alert("❌ 플레이리스트 추가 실패");
    }
}
