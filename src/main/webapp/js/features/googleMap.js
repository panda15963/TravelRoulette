let map;
let marker;
let service;
let infowindow;
let placeMarkers = []; // 👉 검색 결과 마커 저장소

// ✅ 지도 초기화 (수동 실행)
export function initMap() {
    const itTowerSongpa = { lat: 37.497913, lng: 127.119530 };

    map = new google.maps.Map(document.getElementById("map"), {
        center: itTowerSongpa,
        zoom: 13,
        mapTypeId: "hybrid",
        disableDefaultUI: true,
        gestureHandling: "greedy"
    });

    marker = new google.maps.Marker({
        position: itTowerSongpa,
        map,
        title: "IT벤처타워 (송파구)"
    });

    infowindow = new google.maps.InfoWindow();
    service = new google.maps.places.PlacesService(map);

    // ✅ 초기 관광지 검색
    searchPlaces("tourist_attraction", itTowerSongpa, "placesAttractions");
    setActiveButton("btnAttractions");

    // ✅ 초기 도시명 배너 표시
    updateCityBanner("IT벤처타워 (송파구)");
}

// ✅ 지도 리사이즈 강제 호출
export function triggerMapResize() {
    if (map) {
        google.maps.event.trigger(map, "resize");
        const center = map.getCenter();
        if (center) map.setCenter(center);
    }
}

// ✅ 도시명 투명 배너 업데이트
function updateCityBanner(name) {
    const banner = document.getElementById("currentCityBanner");
    const span = document.getElementById("selectedCityName");
    if (banner && span) {
        span.textContent = name;
        banner.style.display = "block";
    }
}

// ✅ 마커 업데이트 (랜덤 도시 선택 시 호출)
export function updateMarker(lat, lng, title = "랜덤 도시") {
    if (!map) return;
    const position = { lat, lng };
    map.setCenter(position);
    map.setZoom(13);

    if (marker) marker.setMap(null);
    marker = new google.maps.Marker({ position, map, title });

    updateCityBanner(title);

    searchPlaces("tourist_attraction", position, "placesAttractions");
    setActiveButton("btnAttractions");
}

// ✅ Places API 검색
export function searchPlaces(type, location, listId) {
    if (!service) return;

    clearPlaceMarkers();

    // 다른 리스트 초기화
    ["placesAttractions", "placesRestaurants", "placesHotels"].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.innerHTML = id === listId ? `<li class="list-group-item text-muted">검색 중...</li>` : "";
    });

    const request = {
        location: new google.maps.LatLng(location.lat, location.lng),
        radius: 3000, // 3km 반경
        type
    };

    service.nearbySearch(request, (results, status) => {
        console.log("검색 상태:", status, results);
        if (status === google.maps.places.PlacesServiceStatus.OK && results.length > 0) {
            displayPlaces(results, listId);
        } else {
            const list = document.getElementById(listId);
            if (list) {
                list.innerHTML = `<li class="list-group-item text-muted">검색 결과 없음 (${status})</li>`;
            }
        }
    });
}

// ✅ Place Details API 요청
function getPlaceDetails(placeId, placeMarker) {
    if (!service) return;

    service.getDetails(
        {
            placeId,
            fields: [
                "name",
                "formatted_address",
                "formatted_phone_number",
                "opening_hours",
                "website",
                "rating",
                "user_ratings_total",
                "reviews"
            ]
        },
        (place, status) => {
            if (status === google.maps.places.PlacesServiceStatus.OK && place) {
                infowindow.setContent(`
                    <div style="max-width:250px">
                        <strong>${place.name}</strong><br>
                        ${place.formatted_address || ""}<br>
                        📞 ${place.formatted_phone_number || "전화번호 없음"}<br>
                        🌐 <a href="${place.website || '#'}" target="_blank">웹사이트</a><br>
                        ⭐ ${place.rating || "N/A"} (${place.user_ratings_total || 0} 리뷰)<br>
                        🕒 ${place.opening_hours?.weekday_text?.join("<br>") || "운영시간 정보 없음"}<br><br>
                        <h6>리뷰</h6>
                        <ul style="max-height:100px;overflow-y:auto;padding-left:16px">
                            ${(place.reviews || []).slice(0,3).map(r =>
                    `<li>"${r.text}" - <em>${r.author_name}</em></li>`
                ).join("")}
                        </ul>
                    </div>
                `);
                infowindow.open(map, placeMarker);
            } else {
                console.error("Place details 요청 실패:", status);
            }
        }
    );
}

// ✅ 기존 마커 제거 함수
function clearPlaceMarkers() {
    placeMarkers.forEach(m => m.setMap(null));
    placeMarkers = [];
}

// ✅ 검색 결과를 지도 + 리스트에 표시
function displayPlaces(places, listId) {
    const list = document.getElementById(listId);
    if (!list) return;
    list.innerHTML = "";

    const markerIcons = {
        placesAttractions: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
        placesRestaurants: "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
        placesHotels: "http://maps.google.com/mapfiles/ms/icons/orange-dot.png"
    };

    places.forEach((place) => {
        if (!place?.geometry?.location) return;

        const placeMarker = new google.maps.Marker({
            map,
            position: place.geometry.location,
            title: place.name,
            icon: markerIcons[listId] || null
        });
        placeMarkers.push(placeMarker);

        google.maps.event.addListener(placeMarker, "click", () => {
            getPlaceDetails(place.place_id, placeMarker);
        });

        const li = document.createElement("li");
        li.className = "list-group-item list-group-item-action";
        li.innerHTML = `
            <strong>${place.name}</strong><br>
            ${place.vicinity || "주소 정보 없음"}<br>
            ⭐ ${place.rating || "N/A"} (${place.user_ratings_total || 0} 리뷰)
        `;

        li.onclick = () => {
            map.setCenter(place.geometry.location);
            getPlaceDetails(place.place_id, placeMarker);
        };

        list.appendChild(li);
    });
}

// ✅ 버튼 상태 갱신
function setActiveButton(activeId) {
    ["btnAttractions", "btnRestaurants", "btnHotels"].forEach(id => {
        const btn = document.getElementById(id);
        if (btn) {
            btn.classList.remove("active");
            if (id === activeId) btn.classList.add("active");
        }
    });
}

// ✅ 버튼 이벤트 연결
document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("btnAttractions")?.addEventListener("click", () => {
        const center = map.getCenter();
        searchPlaces("tourist_attraction", { lat: center.lat(), lng: center.lng() }, "placesAttractions");
        setActiveButton("btnAttractions");
    });

    document.getElementById("btnRestaurants")?.addEventListener("click", () => {
        const center = map.getCenter();
        searchPlaces("restaurant", { lat: center.lat(), lng: center.lng() }, "placesRestaurants");
        setActiveButton("btnRestaurants");
    });

    document.getElementById("btnHotels")?.addEventListener("click", () => {
        const center = map.getCenter();
        searchPlaces("lodging", { lat: center.lat(), lng: center.lng() }, "placesHotels");
        setActiveButton("btnHotels");
    });
});