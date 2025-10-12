<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<div class="sign-container signin-container">
    <h2>로그인</h2>

    <c:if test="${param.status eq 'signupSuccess'}">
    <div class="alert alert-success">회원가입이 완료되었습니다. 로그인해주세요.</div>
    </c:if>

    <% if ("loginFail".equals(request.getParameter("error"))) { %>
    <div class="error-message">아이디 또는 비밀번호가 일치하지 않습니다.</div>
    <% } %>

    <form name="signinForm" action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="signin">
        <input type="text" name="userId" placeholder="아이디를 입력해주세요." required>
        <input type="password" name="userPassword" placeholder="비밀번호를 입력해주세요." required>
        <button type="submit">로그인</button>
    </form>
</div>





<div class="modal fade" id="loginSuccessModal" tabindex="-1" aria-labelledby="loginSuccessModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="loginSuccessModalLabel">로그인 성공</h5>
            </div>
            <div class="modal-body" id="modal-welcome-message">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="modal-confirm-button">확인</button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script defer src="${pageContext.request.contextPath}/js/features/signUpAndValidate.js"></script>
</body>
</html>
