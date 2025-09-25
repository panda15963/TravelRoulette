import {cleanWikipediaResults} from "./cleanWikipediaResults.js";
import {excludePatterns} from "../constants/constants.js";

// 좌표 있는 도시 / 없는 도시 저장소 (전역 캐시)
let validCitiesCache = [];
let noCoordCitiesCache = [];

// 위키백과 API 호출
function fetchCities(wikiCountry, category) {
    const url = `https://en.wikipedia.org/w/api.php?action=query&list=categorymembers` +
        `&cmtitle=Category:${category}_in_${encodeURIComponent(wikiCountry)}` +
        `&cmlimit=50&format=json&origin=*`;
    return fetch(url).then(res => res.json());
}

// 좌표 가져오기
function fetchCityCoordinates(cityTitle) {
    const url = `https://en.wikipedia.org/w/api.php?action=query&titles=${encodeURIComponent(cityTitle)}&prop=coordinates&format=json&origin=*`;
    return fetch(url).then(res => res.json());
}

// 🚩 나라 선택 시 도시 목록 불러오기 + 좌표 필터링
export async function loadCitiesOnCountrySelect(continent, country, countryEnglish) {
    const randomBtn = document.getElementById("pickRandomCityBtn");
    if (randomBtn) randomBtn.disabled = true; // 🔹 먼저 비활성화

    if (!continent || !countryEnglish) {
        alert("대륙과 나라를 모두 선택하세요!");
        return;
    }

    const wikiCountry = countryEnglish.replace(/\s+/g, "_");

    let data = await fetchCities(wikiCountry, "Cities");
    let cities = data?.query?.categorymembers || [];

    if (cities.length === 0) {
        data = await fetchCities(wikiCountry, "Populated_places");
        cities = data?.query?.categorymembers || [];
    }

    cities = cleanWikipediaResults(cities, excludePatterns);

    validCitiesCache = [];
    noCoordCitiesCache = [];

    for (const city of cities) {
        try {
            const coordData = await fetchCityCoordinates(city.title);
            const pages = coordData?.query?.pages || {};
            const page = Object.values(pages)[0];
            const coord = page?.coordinates?.[0];

            if (coord) {
                validCitiesCache.push({
                    title: city.title,
                    lat: coord.lat,
                    lon: coord.lon
                });
            } else {
                noCoordCitiesCache.push(city.title);
            }
        } catch (err) {
            console.error("좌표 가져오기 오류:", err);
        }
    }

    const resultDiv = document.getElementById("cityFilterResult");
    if (resultDiv) {
        resultDiv.innerHTML = `
            <div class="card mt-3 p-3">
                <h6>도시 데이터 정리 완료</h6>
                <p><strong>좌표 있는 도시:</strong> ${validCitiesCache.length}개</p>
                <p><strong>좌표 없는 도시:</strong> ${noCoordCitiesCache.length}개</p>
            </div>
        `;
    }
    if (randomBtn) {
        randomBtn.disabled = validCitiesCache.length === 0;
    }
}

// 🚩 랜덤 도시 뽑기 (이미 필터링된 validCitiesCache 사용)
export function pickRandomCity() {
    if (validCitiesCache.length === 0) {
        alert("좌표가 있는 도시를 찾을 수 없습니다. (나라 선택 시 필터링 실패)");
        return;
    }

    const continent = document.getElementById("continentInput").value;
    const country = document.getElementById("countryInput").value;
    const countryEnglish = document.getElementById("countryEnglishInput").value;

    // 🚩 랜덤 선택
    const randomCity = validCitiesCache[Math.floor(Math.random() * validCitiesCache.length)];
    console.log(`🎯 선택된 랜덤 도시: ${randomCity.title}`);
    console.log(`📍 좌표: lat=${randomCity.lat}, lon=${randomCity.lon}`);

    const resultDiv = document.getElementById("randomCityResult");
    if (resultDiv) {
        resultDiv.innerHTML = `
            <div class="card mt-3 p-3">
                <h5 class="card-title">랜덤 도시 결과</h5>
                <p><strong>대륙:</strong> ${continent}</p>
                <p><strong>나라:</strong> ${country} (${countryEnglish})</p>
                <p><strong>도시:</strong> ${randomCity.title}</p>
            </div>
        `;
    }
}