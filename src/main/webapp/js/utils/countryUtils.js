// 공통: hidden input 값 업데이트
function updateHiddenInputs({ code, name, englishName, flag }) {
    document.getElementById("countryInput").value = name;
    document.getElementById("countryEnglishInput").value = englishName;
    document.getElementById("countryCodeInput").value = code;
}

// 나라 선택
export function selectCountry({ code, name, englishName, flag }) {
    // 버튼 표시 변경
    document.getElementById("countryDropdown").innerHTML =
        `<img src="${flag}" width="20" style="margin-right:6px;" alt="${englishName} flag"> ${name}`;

    // hidden input 값 갱신
    updateHiddenInputs({ code, name, englishName, flag });

    // 국기 출력 영역
    const flagDisplay = document.getElementById("flagDisplay");
    if (flagDisplay) {
        flagDisplay.innerHTML =
            `<img src="${flag}" width="40" style="vertical-align:middle; margin-right:8px;" alt="${englishName} flag"> ${name}`;
    }
}