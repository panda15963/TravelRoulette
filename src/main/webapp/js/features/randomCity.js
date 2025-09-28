import { pickRandomCity, loadCitiesOnCountrySelect } from "../utils/cityUtils.js";
import { loadCountriesByContinent } from "../utils/menuUtils.js";
import { continentFileMap } from "../config/continentMap.js";
import { updateMarker } from "./googleMap.js"; // 지도 업데이트용

export function initRandomCityUI() {
    const continentMenu = document.getElementById("continentMenu");
    const pickBtn = document.getElementById("pickRandomCityBtn");
    const countryDropdown = document.getElementById("countryDropdown");
    const countryMenu = document.getElementById("countryMenu");
    const spinner = document.getElementById("loadingSpinner"); // 👉 로딩 스피너 (버튼 옆)

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

                // 대륙 클릭 시 → 나라 목록만 로드 (스피너 ❌)
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
    } else {
        console.warn("continentMenu 요소를 찾을 수 없습니다.");
    }

    // 나라 선택 시 도시 데이터 로드 + 스피너 표시
    countryMenu?.addEventListener("click", async (e) => {
        if (e.target.matches(".dropdown-item")) {
            e.preventDefault();

            const continent = document.getElementById("continentInput").value;
            const country = e.target.textContent.trim();
            const countryEnglish = e.target.getAttribute("data-country-english");

            spinner?.classList.remove("d-none"); // 👉 버튼 옆 로딩 표시
            try {
                await loadCitiesOnCountrySelect(continent, country, countryEnglish);
                pickBtn?.removeAttribute("disabled"); // 도시 데이터 준비 완료 → 버튼 활성화
            } catch (err) {
                console.error("나라 선택 오류:", err);
            } finally {
                spinner?.classList.add("d-none"); // 👉 로딩 종료
            }
        }
    });

    // 랜덤 도시 버튼 클릭 이벤트
    pickBtn?.addEventListener("click", (e) => {
        e.preventDefault();

        spinner?.classList.remove("d-none"); // 👉 버튼 옆 로딩 표시
        try {
            const city = pickRandomCity(); // { title, lat, lon }

            if (city) {
                const continent = document.getElementById("continentInput").value;
                const country = document.getElementById("countryInput").value;
                const countryEnglish = document.getElementById("countryEnglishInput").value;

                const resultDiv = document.getElementById("randomCityResult");
                if (resultDiv) {
                    resultDiv.innerHTML = `
                        <div class="card mt-3 p-3">
                            <h5 class="card-title">랜덤 도시 결과</h5>
                            <p><strong>대륙:</strong> ${continent}</p>
                            <p><strong>나라:</strong> ${country} (${countryEnglish})</p>
                            <p><strong>도시:</strong> ${city.title}</p>
                            <p><strong>좌표:</strong> lat=${city.lat}, lon=${city.lon}</p>
                        </div>
                    `;
                }

                updateMarker?.(city.lat, city.lon, city.title);
            }
        } catch (err) {
            console.error("도시 선택 중 오류:", err);
            alert("도시 선택 중 오류가 발생했습니다.");
        } finally {
            spinner?.classList.add("d-none"); // 👉 로딩 종료
        }
    });
}