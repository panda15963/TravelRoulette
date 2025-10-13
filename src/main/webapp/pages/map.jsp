<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../assets/favicon.ico?v=2" />
    <link href="../css/styles.css" rel="stylesheet" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body id="pageBody" class="d-flex flex-column h-100"
      data-mode="light" style="background-color:#fff; color:#000;">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

<div class="container mt-4">
    <h3 class="mb-3">랜덤 도시 선택</h3>

    <!-- 대륙/나라 선택 -->
    <div class="row g-3 align-items-center">
        <!-- 대륙 선택 -->
        <div class="col-md-6">
            <span class="form-label text-center d-block w-100">대륙</span>
            <div class="dropdown" data-bs-container="body">
                <button class="btn btn-light dropdown-toggle w-100 border pe-4"
                        id="continentDropdown" data-bs-toggle="dropdown">
                    대륙 선택
                </button>
                <ul class="dropdown-menu w-100" id="continentMenu"></ul>
            </div>
        </div>

        <!-- 나라 선택 -->
        <div class="col-md-6">
            <span class="form-label text-center d-block w-100">나라</span>
            <div class="dropdown" data-bs-container="body">
                <button class="btn btn-light dropdown-toggle w-100 border pe-4"
                        id="countryDropdown" data-bs-toggle="dropdown" disabled>
                    나라 선택
                </button>
                <ul class="dropdown-menu w-100" id="countryMenu"
                    style="max-height:250px; overflow-y:auto;"></ul>
            </div>
        </div>
    </div>

    <!-- hidden inputs -->
    <input type="hidden" id="continentInput" name="continent">
    <input type="hidden" id="countryInput" name="country">
    <input type="hidden" id="countryEnglishInput" name="countryEnglish">
    <input type="hidden" id="countryCodeInput" name="countryCode">
    <input type="hidden" id="cityInput" name="city">

    <!-- 랜덤 도시 버튼 -->
    <div class="mt-3 row g-3">
        <div class="col-md-12">
            <button type="button"
                    class="btn btn-primary d-flex align-items-center justify-content-center gap-2 w-100"
                    id="pickRandomCityBtn" disabled>
                <span>랜덤 도시 뽑기</span>
                <output id="loadingSpinner"
                        class="spinner-border spinner-border-sm text-light d-none"
                        aria-live="polite">
                    <span class="visually-hidden">Loading...</span>
                </output>
            </button>
        </div>
    </div>

    <!-- 지도 + 장소 리스트 -->
    <div class="d-flex mt-3">
        <div class="position-relative" style="width:70%; height:500px;">
            <!-- 지도 위 배너 -->
            <div id="currentCityBanner"
                 class="position-absolute top-0 start-50 translate-middle-x p-2 px-4 rounded"
                 style="background: rgba(0,0,0,0.5); color:#fff; z-index:50; margin-top:10px; display:none;">
                <h5 class="m-0">현재 도시: <span id="selectedCityName"></span></h5>
            </div>
            <!-- 지도 -->
            <div id="map" class="rounded shadow" style="width:100%; height:100%;"></div>
        </div>

        <!-- 장소 패널 -->
        <div id="placesPanel" class="ms-3 border rounded bg-light d-flex flex-column"
             style="width:30%; height:500px;">
            <div class="p-2 border-bottom bg-light sticky-top" style="z-index: 10;">
                <h5 class="mb-2">주변 장소</h5>
                <div class="btn-group w-100">
                    <button class="btn btn-outline-primary active" id="btnAttractions">관광지</button>
                    <button class="btn btn-outline-success" id="btnRestaurants">식당</button>
                    <button class="btn btn-outline-warning" id="btnHotels">호텔</button>
                </div>
            </div>
            <div class="flex-grow-1 overflow-auto p-2">
                <ul id="placesAttractions" class="list-group"></ul>
                <ul id="placesRestaurants" class="list-group"></ul>
                <ul id="placesHotels" class="list-group"></ul>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Dark/Light Mode JS -->
<script src="../js/features/darkmode.js"></script>

<!-- Random City UI 초기화 -->
<script type="module">
    import { initRandomCityUI } from "../js/features/randomCity.js";
    initRandomCityUI();
</script>

<!-- Google Maps JS API (callback 제거) -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDK_cxakbGGco-bruqrtL1PPdKYYj_a1UA&libraries=places" async defer></script>

<!-- Google Map Logic (모듈 + 수동 실행) -->
<script type="module">
    import { initMap, triggerMapResize } from "../js/features/googleMap.js";

    window.addEventListener("load", () => {
        initMap();
        setTimeout(() => triggerMapResize(), 300);
    });
</script>

</body>
</html>