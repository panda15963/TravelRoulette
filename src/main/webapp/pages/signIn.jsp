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




<%--<script>--%>
<%--    const CONTEXT_PATH = "${pageContext.request.contextPath}";--%>
<%--</script>--%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/utils/authManager.js"></script>
<script>
    /**
     * signIn.jsp 스크립트
     * - URL 파라미터로 전달된 에러 메시지(로그인 실패 등)를 화면에 표시합니다.
     * - AJAX를 이용한 로그인 성공 시 AuthManager를 통해 사용자 정보를 세션 스토리지에 저장합니다.
     */
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        const status = urlParams.get('status');
        const errorMessageDiv = document.getElementById('errorMessage');

        if (error === 'loginFail') {
            errorMessageDiv.textContent = '아이디 또는 비밀번호가 일치하지 않습니다.';
        } else if (status === 'signupSuccess') {
            errorMessageDiv.textContent = '회원가입이 완료되었습니다. 로그인해주세요.';
            errorMessageDiv.style.color = 'blue';
        }

        const signinForm = document.forms.signinForm;
        if (signinForm) {
            signinForm.addEventListener('submit', async function(e) {
                e.preventDefault();

                const formData = new FormData(signinForm);
                formData.append('ajax', 'true'); // AJAX 요청임을 명시

                const response = await fetch(signinForm.action, {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                });

                const result = await response.json();

                if (result.success) {
                    AuthManager.setUser({ userId: result.userId, email: result.email });
                    window.location.href = '${pageContext.request.contextPath}/index.jsp';
                } else {
                    errorMessageDiv.textContent = result.message || '로그인에 실패했습니다.';
                }
            });
        }
    });
</script>














<script>
    // AJAX 로그인 처리
    document.addEventListener('DOMContentLoaded', function() {
        const signinForm = document.getElementById('signinForm');

        if (signinForm) {
            signinForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const isDarkMode = document.body.getAttribute('data-mode') === 'dark';

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
                        const loginMessage = (data.success ? data.userId  + '님 환영합니다!' : '로그인 성공!')
                                             + '\n잠시 후 메인으로 이동합니다...';

                        Swal.fire({
                          title: '로그인 성공!',
                          text: loginMessage,
                          icon: 'success',
                          showConfirmButton: false,
                          timer: 2000,
                          timerProgressBar: true,
                          background: isDarkMode ? '#2a2a2a' : '#fff',
                          color: isDarkMode ? '#eaeaea' : '#000',
                          didClose: () => {
                            window.location.href = '${pageContext.request.contextPath}/index.jsp';
                          }
                        });

                    } else {
                        // 로그인 실패
                        const errorMessage = data.message || '로그인에 실패했습니다. 잠시 후 다시 시도해 주세요.';
                        Swal.fire({
                          icon: 'error',
                          title: '로그인 오류',
                          text: errorMessage,
                          timer: 2000,
                          timerProgressBar: true,
                          showConfirmButton: false,
                          background: isDarkMode ? '#2a2a2a' : '#fff',
                          color: isDarkMode ? '#eaeaea' : '#000'
                        });
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
