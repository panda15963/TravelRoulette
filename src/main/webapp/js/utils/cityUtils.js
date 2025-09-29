let citiesCache = [];

// ✅ 국가명 보정 (Google Geocoding에서 인식 잘 되도록)
const countryFix = {
    "Korea": "South Korea",
    "United States of America": "United States",
    "Russia": "Russian Federation",
    "UAE": "United Arab Emirates",
    // 필요 시 추가...
};

// ✅ CountriesNow API 호출
async function fetchCitiesByCountry(countryEnglish) {
    const url = "https://countriesnow.space/api/v0.1/countries/cities";
    const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ country: countryEnglish }),
    });
    return res.json();
}

// ✅ Google Geocoding API로 좌표 가져오기 (방어 처리 + 재시도 포함)
async function getCoordinates(cityName, countryEnglish) {
    const baseUrl = "https://maps.googleapis.com/maps/api/geocode/json";
    const apiKey = "AIzaSyDK_cxakbGGco-bruqrtL1PPdKYYj_a1UA";

    // 보정된 국가명 적용
    const fixedCountry = countryFix[countryEnglish] || countryEnglish;

    // 1차 요청: 도시 + 국가
    let query = `${cityName}, ${fixedCountry}`;
    let url = `${baseUrl}?address=${encodeURIComponent(query)}&key=${apiKey}`;

    let res = await fetch(url);
    let data = await res.json();

    // 2차 요청: 도시명만 (1차 실패 시)
    if (data.status !== "OK" || data.results.length === 0) {
        console.warn("Geocoding 1차 실패:", query, data.status, data.error_message);

        query = cityName;
        url = `${baseUrl}?address=${encodeURIComponent(query)}&key=${apiKey}`;
        res = await fetch(url);
        data = await res.json();
    }

    if (data.status === "OK" && data.results.length > 0) {
        const loc = data.results[0].geometry.location;
        return { lat: loc.lat, lng: loc.lng };
    } else {
        console.error("Geocoding 최종 실패:", query, data.status, data.error_message);
        return null; // 🚩 좌표 못 찾으면 null 반환
    }
}

// 🚩 랜덤 도시 뽑기 + 좌표 얻기
export async function pickRandomCity(countryEnglish) {
    if (citiesCache.length === 0) {
        throw new Error("도시를 찾을 수 없습니다.");
    }

    const city = citiesCache[Math.floor(Math.random() * citiesCache.length)];
    console.log("pickRandomCity 선택:", city);

    const coords = await getCoordinates(city, countryEnglish);

    if (!coords) {
        console.warn(`좌표를 찾을 수 없는 도시: ${city}`);
        return null;
    }

    return { title: city, ...coords };
}

// 🚩 나라 선택 시 도시 목록 불러오기
export async function loadCitiesOnCountrySelect(continent, country, countryEnglish) {
    const randomBtn = document.getElementById("pickRandomCityBtn");
    randomBtn?.setAttribute("disabled", true);

    if (!continent || !countryEnglish) {
        throw new Error("대륙과 나라를 모두 선택하세요!");
    }

    // ✅ 보정 적용
    countryEnglish = countryFix[countryEnglish] || countryEnglish;

    try {
        const data = await fetchCitiesByCountry(countryEnglish);

        if (data.error) {
            console.warn("API 오류:", data.msg);
            citiesCache = [];
            return { validCount: 0 };
        }

        citiesCache = data.data || [];
        console.log("도시 목록:", citiesCache);

        randomBtn?.toggleAttribute("disabled", citiesCache.length === 0);

        return { validCount: citiesCache.length };
    } catch (err) {
        console.error("도시 불러오기 오류:", err);
        return { validCount: 0 };
    }
}