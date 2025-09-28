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
    randomBtn?.setAttribute("disabled", true);

    if (!continent || !countryEnglish) {
        throw new Error("대륙과 나라를 모두 선택하세요!");
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

    // 🚩 UI는 여기서 최소화
    randomBtn?.toggleAttribute("disabled", validCitiesCache.length === 0);

    return {
        validCount: validCitiesCache.length,
        invalidCount: noCoordCitiesCache.length
    };
}

// 🚩 랜덤 도시 뽑기 (데이터만 리턴)
export function pickRandomCity() {
    if (validCitiesCache.length === 0) {
        throw new Error("좌표가 있는 도시를 찾을 수 없습니다.");
    }

    return validCitiesCache[Math.floor(Math.random() * validCitiesCache.length)];
}
