// 한국어 대륙 ↔ JSON 파일명 매핑
const continentFileMap = {
    "아시아": "Asia",
    "아프리카": "Africa",
    "유럽": "Europe",
    "북아메리카": "NorthAmerica",
    "남아메리카": "SouthAmerica",
    "오세아니아": "Oceania"
};

// 대륙 선택 시 나라 목록 불러오기
// 대륙 선택 시 나라 목록 불러오기
function loadCountriesByContinent(continentKr) {
    const fileName = continentFileMap[continentKr];

    fetch(`../assets/json/${fileName}.json`)
        .then(res => res.json())
        .then(countries => {
            const menu = document.getElementById("countryMenu");
            menu.innerHTML = ""; // 초기화

            countries.forEach(c => {
                const li = document.createElement("li");
                li.innerHTML = `
                    <a class="dropdown-item" href="#">
                        <img src="${c.flag}" width="20" style="margin-right:8px;"> ${c.name}
                    </a>`;
                li.onclick = () => {
                    // 버튼에 선택된 나라와 국기 표시
                    document.getElementById("countryDropdown").innerHTML =
                        `<img src="${c.flag}" width="20" style="margin-right:8px;"> ${c.name}`;
                    // hidden input에 값 저장
                    document.getElementById("countryInput").value = c.name;
                };
                menu.appendChild(li);
            });
        })
        .catch(err => console.error("JSON 로드 실패:", err));
}

// 나라 선택 시 버튼 텍스트 + hidden input 변경 + 국기 표시
function selectCountry(code, name, flagUrl) {
    // 드롭다운 버튼에 선택값 표시
    document.getElementById("countryDropdown").innerHTML =
        `<img src="${flagUrl}" width="20" style="margin-right:6px;"> ${name}`;

    // form hidden input 값 업데이트
    document.getElementById("countryInput").value = name;

    // 선택된 국기 아래 표시
    document.getElementById("flagDisplay").innerHTML =
        `<img src="${flagUrl}" width="40" style="vertical-align:middle; margin-right:8px;"> ${name}`;
}

// 나라 기준 랜덤 도시 뽑기 (Wikipedia API)
function pickRandomCity() {
    const country = document.getElementById("countryInput").value;
    if (!country) {
        alert("먼저 나라를 선택하세요!");
        return;
    }

    const url = `https://en.wikipedia.org/w/api.php?action=query&list=categorymembers` +
        `&cmtitle=Category:Cities_in_${encodeURIComponent(country)}` +
        `&cmlimit=50&format=json&origin=*`;

    fetch(url)
        .then(res => res.json())
        .then(data => {
            const cities = data.query.categorymembers;
            if (cities.length > 0) {
                const randomCity = cities[Math.floor(Math.random() * cities.length)].title;
                submitLocationForm(country, randomCity);
            } else {
                alert("도시 정보를 찾을 수 없습니다.");
            }
        })
        .catch(err => console.error("Wikipedia API 오류:", err));
}

// JSP로 값 전달
function submitLocationForm(country, city) {
    document.getElementById("continentInput").value =
        document.getElementById("continentSelect").value;
    document.getElementById("countryInput").value = country;
    document.getElementById("cityInput").value = city;
    document.getElementById("locationForm").submit();
}