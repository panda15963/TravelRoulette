import { pickRandomCity } from "./utils/cityUtils.js";
import { loadCountriesByContinent } from "./utils/menuUtils.js";
import { continentFileMap } from "./utils/config/continentMap.js";

export function initRandomCityUI() {
    const continentMenu = document.getElementById("continentMenu");
    const pickBtn = document.getElementById("pickRandomCityBtn");

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
                // 대륙을 선택하면 menuUtils의 loadCountriesByContinent로 JSON 로드/나라 목록 생성
                loadCountriesByContinent(continentKr);
                // 드롭다운 버튼 텍스트를 바꾸려면 menuUtils에서 이미 처리됨
            });
            continentMenu.appendChild(li);
        });
    }

    if (!pickBtn) {
        console.warn("pickRandomCityBtn 요소를 찾을 수 없습니다. HTML에 #pickRandomCityBtn을 추가하세요.");
    } else {
        pickBtn.addEventListener("click", (e) => {
            e.preventDefault();
            pickRandomCity();
        });
    }
}
