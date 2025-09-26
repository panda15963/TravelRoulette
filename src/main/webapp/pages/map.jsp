<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang = "ko">
<head>
    <title>Map</title>
    <link href = "../css/styles.css" rel = "stylesheet" />
    <!-- Bootstrap CSS -->
    <link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />
    <style>
        #map {
            width: 100%;
            height: 500px; /* 필요에 따라 높이 조정 */
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body id = "pageBody" class = "d-flex flex-column h-100"
      data-mode = "light" style = "background-color:#fff; color:#000;">

<%@ include file = "/common/navbar.jsp" %>
<%@ include file = "/common/sidebar.jsp" %>

<div class = "container mt-4">
    <h3 class = "mb-3">랜덤 도시 선택</h3>

    <div class = "row g-3 align-items-center">
        <!-- 대륙 선택 -->
        <div class = "col-md-6">
            <span class = "form-label text-center d-block w-99">대륙</span>
            <div class = "dropdown">
                <button class = "btn btn-light dropdown-toggle w-100 border pe-4"
                        id = "continentDropdown" data-bs-toggle = "dropdown">
                    대륙 선택
                </button>
                <ul class = "dropdown-menu w-100" id = "continentMenu"></ul>
            </div>
        </div>

        <!-- 나라 선택 -->
        <div class = "col-md-6">
            <span class = "form-label text-center d-block w-100">나라</span>
            <div class = "dropdown">
                <button class = "btn btn-light dropdown-toggle w-100 border pe-4"
                        id = "countryDropdown" data-bs-toggle = "dropdown" disabled>
                    나라 선택
                </button>
                <ul class = "dropdown-menu w-100" id = "countryMenu" style = "max-height:250px; overflow-y:auto;"></ul>
            </div>
        </div>
    </div>

    <!-- hidden inputs -->
    <input type = "hidden" id = "continentInput" name = "continent">
    <input type = "hidden" id = "countryInput" name = "country">
    <input type = "hidden" id = "countryEnglishInput" name = "countryEnglish">
    <input type = "hidden" id = "countryCodeInput" name = "countryCode">
    <input type = "hidden" id = "cityInput" name = "city">

    <!-- 랜덤 도시 버튼 -->
    <div class = "mt-3">
        <button type = "button" class = "btn btn-primary" id = "pickRandomCityBtn" disabled>
            랜덤 도시 뽑기
        </button>
    </div>

    <!-- 결과 표시 -->
    <div id = "randomCityResult" class = "mt-3"></div>

    <!-- 지도 영역 -->
    <div id="map"></div>
</div>

<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Dark/Light Mode JS -->
<script src = "../js/features/darkmode.js"></script>

<!-- Google Maps JS API -->
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
<!-- 분리된 JS -->
<script src="../js/features/map.js"></script>

<!-- 랜덤 도시 UI 초기화 -->
<script type = "module">
    import {initRandomCityUI} from "../js/features/randomCity.js";

    initRandomCityUI();
</script>
</body>
</html>