let map;
let marker;

export function initMap() {
    const seoul = { lat: 37.5665, lng: 126.9780 };

    map = new google.maps.Map(document.getElementById("map"), {
        center: seoul,
        zoom: 5,
        mapTypeId: 'hybrid',
        disableDefaultUI: true,
    });

    marker = new google.maps.Marker({
        position: seoul,
        map: map,
        title: "서울",
    });
}

// ✅ 새로운 좌표로 마커 이동
export function updateMarker(lat, lng, title = "랜덤 도시") {
    if (!map) return;

    const position = { lat, lng };

    // 마커 위치 이동
    if (marker) {
        marker.setMap(null); // 기존 마커 제거
    }

    marker = new google.maps.Marker({
        position,
        map,
        title,
    });

    // 지도 중심도 같이 이동
    map.setCenter(position);
    map.setZoom(6);
}

// Google Maps API callback 전역 등록
window.initMap = initMap;