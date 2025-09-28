import { pickRandomCity, loadCitiesOnCountrySelect } from "../utils/cityUtils.js";
import { loadCountriesByContinent } from "../utils/menuUtils.js";
import { continentFileMap } from "../config/continentMap.js";
import { updateMarker } from "./googleMap.js"; // 지도 업데이트용

export function initRandomCityUI() {
    const continentMenu = document.getElementById("continentMenu");
    const pickBtn = document.getElementById("pickRandomCityBtn");
    const countryDropdown = document.getElementById("countryDropdown");
    const countryMenu = document.getElementById("countryMenu");
    const spinner = document.getElementById("loadingSpinner");

    // 초기 비활성화
    countryDropdown?.setAttribute("disabled", true);
    pickBtn?.setAttribute("disabled", true);

    // 대륙 메뉴 세팅
    if (continentMenu) {
        continentMenu.innerHTML = "";
        Object.keys(continentFileMap).forEach(continentKr => {
            const li = document.createElement("li");
            li.className = "nav-item";
            li.innerHTML = `<a class="dropdown-item" href="#" data-continent="${continentKr}">${continentKr}</a>`;

            li.addEventListener("click", async (e) => {
                e.preventDefault();
                try {
                    await loadCountriesByContinent(continentKr);
                    if (countryDropdown?.disabled) {
                        countryDropdown.disabled = false;
                    }
                } catch (err) {
                    console.error("대륙 선택 오류:", err);
                }
            });

            continentMenu.appendChild(li);
        });
    }

    // 나라 선택 시
    countryMenu?.addEventListener("click", async (e) => {
        if (e.target.matches(".dropdown-item")) {
            e.preventDefault();
            const continent = document.getElementById("continentInput").value;
            const country = e.target.textContent.trim();
            const countryEnglish = e.target.getAttribute("data-country-english");

            spinner?.classList.remove("d-none");
            try {
                await loadCitiesOnCountrySelect(continent, country, countryEnglish);
                pickBtn?.removeAttribute("disabled");
            } catch (err) {
                console.error("나라 선택 오류:", err);
            } finally {
                spinner?.classList.add("d-none");
            }
        }
    });

    // 랜덤 도시 버튼 클릭
    pickBtn?.addEventListener("click", (e) => {
        e.preventDefault();
        spinner?.classList.remove("d-none");

        try {
            const city = pickRandomCity();
            if (city) {
                // 👉 지도 마커 & 투명 배너 업데이트
                updateMarker(city.lat, city.lon, city.title);

                // 👉 hidden input에도 반영
                document.getElementById("cityInput").value = city.title;
            }
        } catch (err) {
            console.error("도시 선택 오류:", err);
        } finally {
            spinner?.classList.add("d-none");
        }
    });
}