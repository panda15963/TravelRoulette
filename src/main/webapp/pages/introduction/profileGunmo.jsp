<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../../assets/favicon.ico?v=2" />
    <link href = "../../css/styles.css" rel = "stylesheet" />
    <!-- Bootstrap CSS -->
    <link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />
</head>
<body id = "pageBody" class = "d-flex flex-column h-100"
      style = "background-color:#fff; color:#000;" data-mode = "light">

<%@ include file = "/common/navbar.jsp" %>
<%@ include file = "/common/sidebar.jsp" %>

<!-- 프로필 상세 섹션 -->
<div class="container mt-auto d-flex justify-content-center bg-white">
    <iframe src="https://gmkoo-d3v.github.io/my-web/"
            width="100%"
            height="800"
            style="border:none;"
            title="California">
    </iframe>
</div>
<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src = "../../js/features/darkmode.js"></script>
</body>
</html>