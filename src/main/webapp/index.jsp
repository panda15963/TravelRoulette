<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang = "en">
<head>
	<meta charset = "utf-8" />
	<meta name = "viewport" content = "width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name = "description" content = "TripWiki" />

	<title>TripWiki</title>

	<!-- Favicon -->
	<link rel = "icon" type = "image/x-icon" href = "assets/favicon.ico?v=2" />

	<!-- Bootstrap CSS -->
	<link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />

	<!-- Bootstrap icons -->
	<link href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel = "stylesheet" />

	<!-- Core theme CSS -->
	<link href = "css/styles.css" rel = "stylesheet" />
</head>
<body id = "pageBody" class = "d-flex flex-column h-100"
      style = "background-color:#fff; color:#000;" data-mode = "light">
<main class = "flex-shrink-0">
	<%@ include file = "/Common/navbar.jsp" %>
	<%@ include file = "/Common/sidebar.jsp" %>

	<!-- Hero Section -->
	<header class = "bg-dark text-white py-5"
	        style = "background: url('images/travel_title.jpg') center/cover no-repeat;
               min-height: 500px; display: table; width: 100%;">
		<div style = "display: table-cell; vertical-align: middle; text-align: center;">
			<h1 class = "display-4 fw-bolder">TripWiki</h1>
			<p class = "lead fw-normal text-white-50 mb-0">세상을 여행하는 새로운 방법</p>
		</div>
	</header>

	<%@ include file = "/Sections/about.jsp" %>

	<%@ include file = "/Common/footer.jsp" %>
</main>

<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src = "js/features/darkmode.js"></script>







</body>
</html>