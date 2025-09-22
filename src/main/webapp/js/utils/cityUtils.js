import { cleanWikipediaResults } from "./cleanWikipediaResults.js";
import { excludePatterns } from "../constants/constants.js";

// 위키백과 API 호출
function fetchCities(wikiCountry, category) {
    const url = `https://en.wikipedia.org/w/api.php?action=query&list=categorymembers` +
        `&cmtitle=Category:${category}_in_${encodeURIComponent(wikiCountry)}` +
        `&cmlimit=50&format=json&origin=*`;
    return fetch(url).then(res => res.json());
}

// 결과 표시
function showResultBelow(continent, country, countryEnglish, city) {
    const resultDiv = document.getElementById("randomCityResult");
    resultDiv.innerHTML = `
        <div class="card mt-3 p-3">
            <h5 class="card-title">랜덤 도시 결과</h5>
            <p><strong>대륙:</strong> ${continent}</p>
            <p><strong>나라:</strong> ${country} (${countryEnglish})</p>
            <p><strong>도시:</strong> ${city}</p>
        </div>
    `;
}

// 랜덤 도시 뽑기
export function pickRandomCity() {
    const continent = document.getElementById("continentInput").value;
    const country = document.getElementById("countryInput").value;
    const countryEnglish = document.getElementById("countryEnglishInput").value;

    if (!continent || !countryEnglish) {
        alert("대륙과 나라를 모두 선택하세요!");
        return;
    }

    const wikiCountry = countryEnglish.replace(/\s+/g, "_");

    fetchCities(wikiCountry, "Cities")
        .then(data => {
            console.log("📌 1차 응답 (Cities):", data);

            let cities = data?.query?.categorymembers || [];
            if (cities.length === 0) {
                console.log("⚠️ Cities 결과 없음, Populated_places 재시도");
                return fetchCities(wikiCountry, "Populated_places");
            }
            return data;
        })
        .then(data => {
            console.log("📌 최종 응답 (Cities/Populated_places):", data);

            let cities = data?.query?.categorymembers || [];

            // 🚩 데이터 정제 (유틸 함수 활용)
            cities = cleanWikipediaResults(cities, excludePatterns);

            console.log("✅ 가공된 목록:", cities.map(c => c.title));

            if (cities.length > 0) {
                const randomCity = cities[Math.floor(Math.random() * cities.length)].title;
                console.log("🎯 선택된 랜덤 도시:", randomCity);
                showResultBelow(continent, country, countryEnglish, randomCity);
            } else {
                alert("도시 정보를 찾을 수 없습니다.");
            }
        })
        .catch(err => console.error("Wikipedia API 오류:", err));
}