import { selectCountry } from "./countryUtils.js";
import { continentFileMap } from "../config/continentMap.js";

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
               data-country="${c.name}"
               data-country-english="${c.englishName}">
                <img src="${c.flag}" width="20" style="margin-right:8px;" alt="${c.englishName} flag"> ${c.name}
            </a>`;
        li.onclick = () => onSelect(c);
        menu.appendChild(li);
    });
}

export async function loadCountriesByContinent(continentKr) {
    const fileName = continentFileMap[continentKr];

    try {
        const res = await fetch(`/assets/json/${fileName}.json`);

        // 응답 상태 확인 (throw 대신 조건문 처리)
        if (!res.ok) {
            let errorMsg = res.status === 404
                ? "데이터 파일을 찾을 수 없습니다."
                : `서버 오류 (코드: ${res.status})`;

            console.warn("나라 목록 불러오기 실패:", errorMsg);
            resetCountryMenu("나라 목록 불러오기 실패", true);
            return; // 에러 발생 시 여기서 함수 종료
        }

        const countries = await res.json();

        if (!countries || countries.length === 0) {
            resetCountryMenu("등록된 나라 없음");
            return;
        }

        createCountryList(countries, selectCountry);

        document.getElementById("continentDropdown").innerHTML =
            `<span class="me-auto pe-2">${continentKr}</span>`;

        document.getElementById("countryDropdown").innerHTML =
            `<span class="me-auto pe-2">나라 선택</span>`;

        document.getElementById("continentInput").value = continentKr;

    } catch (err) {
        // 네트워크 오류(fetch 자체 실패)만 여기서 처리됨
        console.warn("나라 목록 불러오기 실패 (네트워크 오류):", err.message);
        resetCountryMenu("나라 목록 불러오기 실패", true);
    }
}