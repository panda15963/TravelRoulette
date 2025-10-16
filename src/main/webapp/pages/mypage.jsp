<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
<main>
    <h2>마이페이지</h2>

    <!-- ✅ 이메일 변경 -->
    <div class="form-section">
        <h5>이메일 변경</h5>
        <form action="${pageContext.request.contextPath}/updateEmail" method="post">
            <div class="mb-3">
                <label for="currentEmail" class="form-label">현재 이메일</label>
                <input type="email" id="currentEmail" name="currentEmail" class="form-control" 
                       value="${sessionScope.authenticatedUser.email}" readonly>
            </div>
            <div class="mb-3">
                <label for="newEmail" class="form-label">새 이메일</label>
                <input type="email" id="newEmail" name="newEmail" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">이메일 변경</button>
        </form>
    </div>

    <!-- ✅ 비밀번호 변경 -->
    <div class="form-section">
        <h5>비밀번호 변경</h5>
        <form action="${pageContext.request.contextPath}/updatePassword" method="post">
            <div class="mb-3">
                <label for="currentPassword" class="form-label">현재 비밀번호</label>
                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="newPassword" class="form-label">새 비밀번호</label>
                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-success w-100">비밀번호 변경</button>
        </form>
    </div>
</main>
</body>
</html>