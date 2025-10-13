<%@ page import="java.util.*, com.travelroulette.dto.continent.ContinentDto" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head><title>대륙 목록</title></head>
<body>
<h2>🌍 대륙 목록</h2>

<table border="1" cellpadding="8">
    <tr><th>ID</th><th>한글명</th><th>영문명</th></tr>
    <%
        List<ContinentDto> list = (List<ContinentDto>) request.getAttribute("continents");
        if (list != null) {
            for (ContinentDto dto : list) {
    %>
    <tr>
        <td><%= dto.getContinentNumber() %></td>
        <td><%= dto.getContinentNameKor() %></td>
        <td><%= dto.getContinentNameEng() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="3">조회된 데이터가 없습니다.</td></tr>
    <%
        }
    %>
</table>
</body>
</html>
