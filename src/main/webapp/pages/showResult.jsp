<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>선택 결과</title>
    <link href="../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container mt-4">

<h2 class="mb-3">선택 결과</h2>

<div class="card p-3">
    <p><strong>대륙:</strong> <%= request.getParameter("continent") %></p>
    <p><strong>나라:</strong> <%= request.getParameter("country") %></p>
    <p><strong>영문 국가명:</strong> <%= request.getParameter("countryEnglish") %></p>
    <p><strong>도시:</strong> <%= request.getParameter("city") %></p>
</div>

<div class="mt-3">
    <a href="map.jsp" class="btn btn-secondary">돌아가기</a>
</div>

</body>
</html>