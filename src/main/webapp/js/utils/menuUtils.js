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

export function loadCountriesByContinent(continentKr) {
    const fileName = continentFileMap[continentKr];
    fetch(`/assets/json/${fileName}.json`)
        .then(res => {
            if (!res.ok) throw new Error(`HTTP 오류! ${res.status}`);
            return res.json();
        })
        .then(countries => {
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
        })
        .catch(err => {
            console.error("JSON 로드 실패:", err);
            resetCountryMenu("나라 목록 불러오기 실패", true);
        });
}