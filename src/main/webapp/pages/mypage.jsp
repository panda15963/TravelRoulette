<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../assets/favicon.ico?v=2" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/features/sign/signStyle.css" rel="stylesheet"/>
</head>
<body id="pageBody" class="sign-page-body" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>


<h2>🙋 내 정보 관리</h2>

    <!-- 비밀번호 변경 영역 -->
    <div class="card mt-4 p-4">
        <h4>비밀번호 변경</h4>
        <div id="pwMsg"></div>

        <div class="mb-3">
            <label class="form-label">현재 비밀번호</label>
            <input type="password" id="currentPassword" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">새 비밀번호</label>
            <input type="password" id="newPassword" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">새 비밀번호 확인</label>
            <input type="password" id="confirmPassword" class="form-control" required>
        </div>
        <button class="btn btn-primary" onclick="changePassword()">변경</button>
    </div>

    <script>
    async function changePassword() {
        const formData = new URLSearchParams();
        formData.append("currentPassword", document.getElementById("currentPassword").value);
        formData.append("newPassword", document.getElementById("newPassword").value);
        formData.append("confirmPassword", document.getElementById("confirmPassword").value);

        const res = await fetch("${pageContext.request.contextPath}/mypage/change-password", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: formData
        });

        const data = await res.json();

        const msgEl = document.getElementById("resultMessage");
        if (data.success) {
            msgEl.innerHTML = `<div class='alert alert-success'>${data.message}</div>`;
            document.getElementById("passwordForm").reset();
        } else {
            msgEl.innerHTML = `<div class='alert alert-danger'>${data.message}</div>`;
        }
    }

    </script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script defer src="${pageContext.request.contextPath}/js/features/signUpAndValidate.js"></script>
</body>
</html>
