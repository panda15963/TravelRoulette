import { loadCitiesOnCountrySelect } from "./cityUtils.js";

// 공통: hidden input 값 업데이트
function updateHiddenInputs({ code, name, englishName, flag }) {
    document.getElementById("countryInput").value = name;
    document.getElementById("countryEnglishInput").value = englishName;
    document.getElementById("countryCodeInput").value = code;
}

// 나라 선택
export function selectCountry({ code, name, englishName, flag }) {
    // 🔹 국기 + 이름을 span으로 감싸서 화살표와 간격 유지
    document.getElementById("countryDropdown").innerHTML =
        `<span class="me-auto">
            <img src="${flag}" width="20" style="margin-right:6px;" alt="${englishName} flag"> ${name}
        </span>`;

    // hidden input 값 갱신
    document.getElementById("countryInput").value = name;
    document.getElementById("countryEnglishInput").value = englishName;
    document.getElementById("countryCodeInput").value = code;

    // 국기 출력 영역
    const flagDisplay = document.getElementById("flagDisplay");
    if (flagDisplay) {
        flagDisplay.innerHTML =
            `<img src="${flag}" width="40" style="vertical-align:middle; margin-right:8px;" alt="${englishName} flag"> ${name}`;
    }

    // 🚩 나라 선택 시 도시 좌표 필터링 실행
    const continent = document.getElementById("continentInput").value;
    loadCitiesOnCountrySelect(continent, name, englishName).then(r => {
        console.log(`✅ ${name} (${englishName}) 도시 데이터 로드 완료:`, r);
    })
}