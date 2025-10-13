import { selectCountry } from "./countryUtils.js";

export function resetCountryMenu(message, isError = false) {
    const menu = document.getElementById("countryMenu");
    menu.innerHTML = `
        <li><span class="dropdown-item ${isError ? "text-danger" : "text-muted"}">${message}</span></li>
    `;
}

export function createCountryList(countries, onSelect) {
    const menu = document.getElementById("countryMenu");
    menu.innerHTML = "";

    countries.forEach(c => {
        const li = document.createElement("li");
        li.innerHTML = `
            <a class="dropdown-item" href="#"
               data-country="${c.countryNameKor}"
               data-country-english="${c.countryNameEng}">
                <img src="${c.flagURL}" width="20" style="margin-right:8px;" alt="${c.countryNameEng} flag"> ${c.countryNameKor}
            </a>`;
        li.onclick = () => onSelect(c);
        menu.appendChild(li);
    });
}

export async function loadCountriesByContinent(continentKr) {
    try {
        // ✅ DB 연동 API 호출 (Controller → DAO → DB)
        const res = await fetch(`/TravelRoulette/api/countries?continent=${encodeURIComponent(continentKr)}`);

        if (!res.ok) {
            const errorMsg = res.status === 404
                ? "데이터를 찾을 수 없습니다."
                : `서버 오류 (코드: ${res.status})`;
            console.warn("나라 목록 불러오기 실패:", errorMsg);
            resetCountryMenu("나라 목록 불러오기 실패", true);
            return;
        }

        const countries = await res.json();

        if (!countries || countries.length === 0) {
            resetCountryMenu("등록된 나라 없음");
            return;
        }

        // ✅ DB에서 가져온 나라 목록 표시
        createCountryList(countries, selectCountry);

        document.getElementById("continentDropdown").innerHTML =
            `<span class="me-auto pe-2">${continentKr}</span>`;

        document.getElementById("countryDropdown").innerHTML =
            `<span class="me-auto pe-2">나라 선택</span>`;

        document.getElementById("continentInput").value = continentKr;

    } catch (err) {
        console.warn("나라 목록 불러오기 실패 (네트워크 오류):", err.message);
        resetCountryMenu("나라 목록 불러오기 실패", true);
    }
}