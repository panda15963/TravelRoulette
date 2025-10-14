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

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

<div class="sign-container signin-container">
    <h2>로그인</h2>

    <c:if test="${param.status eq 'signupSuccess'}">
    <div class="alert alert-success">회원가입이 완료되었습니다. 로그인해주세요.</div>
    </c:if>

    <% if ("loginFail".equals(request.getParameter("error"))) { %>
    <div class="error-message">아이디 또는 비밀번호가 일치하지 않습니다.</div>
    <% } %>

    <form name="signinForm" action="${pageContext.request.contextPath}/auth" method="post" id="signinForm">
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

<%--<script>--%>
<%--    const CONTEXT_PATH = "${pageContext.request.contextPath}";--%>
<%--</script>--%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/utils/authManager.js"></script>
<%--<script defer src="${pageContext.request.contextPath}/js/features/signUpAndValidate.js"></script>--%>
<script>
    // AJAX 로그인 처리
    document.addEventListener('DOMContentLoaded', function() {
        const signinForm = document.getElementById('signinForm');

        if (signinForm) {
            signinForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const formData = new FormData(signinForm);
                formData.append('ajax', 'true');

                fetch('${pageContext.request.contextPath}/auth', {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 세션 스토리지에 사용자 정보 저장
                        AuthManager.setUser({
                            userId: data.userId,
                            email: data.email
                        });

                        // 로그인 성공 메시지
                        alert(data.userId + '님 환영합니다!');

                        // 메인 페이지로 이동
                        window.location.href = '${pageContext.request.contextPath}/index.jsp';
                    } else {
                        // 로그인 실패
                        alert(data.message || '로그인에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('로그인 오류:', error);
                    alert('로그인 처리 중 오류가 발생했습니다.');
                });
            });
        }
    });
</script>
</body>
</html>
