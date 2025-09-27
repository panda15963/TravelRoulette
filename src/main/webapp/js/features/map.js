let map;
let marker;

export function initMap() {
    const seoul = { lat: 37.5665, lng: 126.9780 };

    // 지도 생성
    map = new google.maps.Map(document.getElementById("map"), {
        center: seoul,
        zoom: 10,
        mapTypeId: 'hybrid',
        disableDefaultUI: true,
    });

    // 마커 생성 후 변수에 저장
    marker = new google.maps.Marker({
        position: seoul,
        map: map,
        title: "서울",
    });
}

// Google Maps API callback 에서 호출할 수 있도록 전역 등록
window.initMap = initMap;