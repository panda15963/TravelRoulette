<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>Map</title>
	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
	<!-- Bootstrap-Select CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-select@1.14.0-beta3/dist/css/bootstrap-select.min.css">
</head>
<body id="pageBody" class="d-flex flex-column h-100 bg-light text-dark">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<div class="container mt-4">
	<h3 class="mb-3">랜덤 도시 선택</h3>

	<!-- 대륙 선택 -->
	<div class="mb-3">
		<label for="continentSelect" class="form-label">대륙</label>
		<select id="continentSelect" class="form-select"
		        onchange="loadCountriesByContinent(this.value)">
			<option value="">대륙 선택</option>
			<option value="아시아">아시아</option>
			<option value="아프리카">아프리카</option>
			<option value="유럽">유럽</option>
			<option value="북아메리카">북아메리카</option>
			<option value="남아메리카">남아메리카</option>
			<option value="오세아니아">오세아니아</option>
		</select>
	</div>

	<!-- 나라 선택 (Bootstrap-Select) -->
	<div class="dropdown">
		<button class="btn btn-light dropdown-toggle" type="button" id="countryDropdown" data-bs-toggle="dropdown">
			나라 선택
		</button>
		<ul class="dropdown-menu" id="countryMenu"></ul>
	</div>

	<!-- 선택된 값을 담을 hidden input -->
	<input type="hidden" id="countryInput" name="country">

	<!-- 버튼 -->
	<button type="button" class="btn btn-primary" onclick="pickRandomCity()">랜덤 도시 뽑기</button>

	<!-- JSP로 전달할 form -->
	<form id="locationForm" method="post" action="showResult.jsp">
		<input type="hidden" name="continent" id="continentInput">
		<input type="hidden" name="country" id="countryInput">
		<input type="hidden" name="city" id="cityInput">
	</form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Bootstrap-Select JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.14.0-beta3/dist/js/bootstrap-select.min.js"></script>
<!-- Custom JS -->
<script src="../js/randomCity.js"></script>
</body>
</html>