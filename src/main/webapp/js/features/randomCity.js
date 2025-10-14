import { pickRandomCity, loadCitiesOnCountrySelect } from "../utils/cityUtils.js";
import { loadCountriesByContinent } from "../utils/menuUtils.js";
import { updateMarker } from "./googleMap.js"; // 지도 업데이트용

export async function initRandomCityUI() {
    const continentDropdown = document.getElementById("continentDropdown");
    const continentMenu = document.getElementById("continentMenu");
    const pickBtn = document.getElementById("pickRandomCityBtn");
    const countryDropdown = document.getElementById("countryDropdown");
    const countryMenu = document.getElementById("countryMenu");
    const spinner = document.getElementById("loadingSpinner");
    const cityInput = document.getElementById("cityInput");

    // 초기 비활성화
    countryDropdown?.setAttribute("disabled", true);
    pickBtn?.setAttribute("disabled", true);

    /**
     * ✅ [변경 사항]
     * 페이지 로드시 fetch() 실행 ❌
     * → “대륙 선택” 버튼 클릭 시 fetch() 실행 ⭕
     */
    continentDropdown?.addEventListener("click", async () => {
        // 이미 로드된 경우 다시 불러오지 않음
        if (continentMenu.childElementCount > 0) return;

        continentMenu.innerHTML = `<li class="dropdown-item text-muted">불러오는 중...</li>`;

        try {
            const response = await fetch(`${window.location.origin}${window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : ''}/continent`);
            if (!response.ok) throw new Error("대륙 목록 불러오기 실패");

            const continents = await response.json();

            // ✅ 콘솔 출력
            console.log("🌍 서버에서 불러온 대륙 목록:", continents);

            continentMenu.innerHTML = ""; // 기존 “불러오는 중” 문구 제거

            // 대륙 항목 생성
            continents.forEach(continent => {
                const li = document.createElement("li");
                li.className = "nav-item";
                li.innerHTML = `
                    <a class="dropdown-item" href="#"
                       data-continent="${continent.continentNameKor}"
                       data-continent-eng="${continent.continentNameEng}">
                       ${continent.continentNameKor}
                    </a>
                `;

                li.addEventListener("click", async (e) => {
                    e.preventDefault();

                    // ✅ hidden input에 대륙 이름 / 번호 모두 저장
                    document.getElementById("continentInput").value = continent.continentNameKor;
                    document.getElementById("continentInputNumber").value = continent.continentNumber;

                    console.log(
                        `✅ 선택된 대륙: ${continent.continentNameKor} (${continent.continentNameEng}), 번호: ${continent.continentNumber}`
                    );

                    try {
                        // ✅ 번호로 나라 데이터 요청 (API는 번호 기반)
                        await loadCountriesByContinent(continent.continentNumber, continent.continentNameKor);
                        countryDropdown.disabled = false;
                    } catch (err) {
                        console.error("대륙 선택 오류:", err);
                    }
                });

                continentMenu.appendChild(li);
            });

        } catch (error) {
            console.error("❌ 대륙 메뉴 로드 오류:", error);
            continentMenu.innerHTML = `<li class="dropdown-item text-danger">대륙 목록을 불러오지 못했습니다.</li>`;
        }
    });

    // ✅ 나라 선택 시 도시 목록 로드
    countryMenu?.addEventListener("click", async (e) => {
        if (!e.target.matches(".dropdown-item")) return;

        e.preventDefault();
        const continent = document.getElementById("continentInput").value;
        const country = e.target.textContent.trim();
        const countryEnglish = e.target.getAttribute("data-country-english");

        spinner?.classList.remove("d-none");

        try {
            console.log(`🌏 나라 선택됨: ${country} (${countryEnglish}), 대륙: ${continent}`);
            const { validCount } = await loadCitiesOnCountrySelect(continent, country, countryEnglish);
            pickBtn.disabled = validCount === 0;
        } catch (err) {
            console.error("나라 선택 오류:", err);
        } finally {
            spinner?.classList.add("d-none");
        }
    });

    // ✅ 랜덤 도시 버튼 클릭
    pickBtn?.addEventListener("click", async (e) => {
        e.preventDefault();
        spinner?.classList.remove("d-none");

        try {
            const city = await pickRandomCity();
            if (!city) {
                console.warn("❌ 랜덤 도시를 찾을 수 없습니다.");
                return;
            }

            console.log("🎯 선택된 랜덤 도시:", city);

            // 지도 마커 업데이트
            updateMarker(city.lat, city.lng, city.title);

            // hidden input에도 반영
            if (cityInput) cityInput.value = city.title;
        } catch (err) {
            console.error("도시 선택 오류:", err);
        } finally {
            spinner?.classList.add("d-none");
        }
    });
}