import { pickRandomCity } from "./utils/cityUtils.js";
import { loadCountriesByContinent } from "./utils/menuUtils.js";
import { continentFileMap } from "./utils/config/continentMap.js";

export function initRandomCityUI() {
    const continentMenu = document.getElementById("continentMenu");
    const pickBtn = document.getElementById("pickRandomCityBtn");
    const countryDropdown = document.getElementById("countryDropdown");

    // ✅ inline onclick에서도 접근 가능하도록 전역 등록
    window.pickRandomCity = pickRandomCity;

    // 초기에는 나라 버튼과 랜덤 버튼 비활성화
    if (countryDropdown) {
        countryDropdown.disabled = true;
    }
    if (pickBtn) {
        pickBtn.disabled = true;
    }

    if (!continentMenu) {
        console.warn("continentMenu 요소를 찾을 수 없습니다. HTML에 #continentMenu를 추가하세요.");
    } else {
        // 대륙 리스트를 continentFileMap의 키(한글명)으로 구성
        continentMenu.innerHTML = "";
        Object.keys(continentFileMap).forEach(continentKr => {
            const li = document.createElement("li");
            li.className = "nav-item";
            li.innerHTML = `<a class="dropdown-item" href="#" data-continent="${continentKr}">${continentKr}</a>`;
            li.addEventListener("click", (e) => {
                e.preventDefault();

                // 대륙 선택 시 나라 목록 생성
                loadCountriesByContinent(continentKr);

                // 나라 버튼 활성화 (단, pickRandomCityBtn은 여전히 비활성화)
                if (countryDropdown && countryDropdown.disabled) {
                    countryDropdown.disabled = false;
                }
            });
            continentMenu.appendChild(li);
        });
    }

    if (!pickBtn) {
        console.warn("pickRandomCityBtn 요소를 찾을 수 없습니다. HTML에 #pickRandomCityBtn을 추가하세요.");
    } else {
        // 클릭 이벤트
        pickBtn.addEventListener("click", (e) => {
            e.preventDefault();
            pickRandomCity();
        });
    }
}