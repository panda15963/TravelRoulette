import { selectCountry } from "./countryUtils.js";

export function resetCountryMenu(message, isError = false) {
    const menu = document.getElementById("countryMenu");
    menu.innerHTML = `
        <li><span class="dropdown-item ${isError ? "text-danger" : "text-muted"}">${message}</span></li>
    `;
}

// ✅ 수정된 createCountryList() — selectCountry()와 데이터 구조 일치시킴
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

        // ✅ selectCountry()가 { code, name, englishName, flag }를 받도록 수정
        li.querySelector("a").onclick = (e) => {
            e.preventDefault();
            onSelect({
                code: c.countryCode ?? "",        // countryCode가 있을 경우
                name: c.countryNameKor,
                englishName: c.countryNameEng,
                flag: c.flagURL
            });
        };

        menu.appendChild(li);
    });
}

export async function loadCountriesByContinent(continentNumber, continentNameKor) {
    try {
        // ✅ 번호로 요청
        const res = await fetch(`/countries?continentNumber=${continentNumber}`);

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

        // ✅ 나라 목록 표시
        createCountryList(countries, selectCountry);

        // ✅ 드롭다운 제목을 대륙 이름으로 갱신
        document.getElementById("continentDropdown").innerHTML =
            `<span class="me-auto pe-2">${continentNameKor}</span>`;

        // ✅ 나라 선택 초기화
        document.getElementById("countryDropdown").innerHTML =
            `<span class="me-auto pe-2">나라 선택</span>`;

        console.log(`🌍 ${continentNameKor} (${continentNumber}번) 국가 ${countries.length}개 로드 완료`);
    } catch (err) {
        console.warn("나라 목록 불러오기 실패 (네트워크 오류):", err.message);
        resetCountryMenu("나라 목록 불러오기 실패", true);
    }
}