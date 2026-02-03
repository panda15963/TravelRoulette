<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../assets/favicon.ico?v=2" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/features/sign/signStyle.css" rel="stylesheet"/>
</head>
<body id="pageBody" class="sign-page-body" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

<div class="container" style="max-width: 450px; margin-top: 70px; margin-bottom: 50px;">
    <div class="card shadow-sm" style="border: none; border-radius: 16px;">
        <div class="card-body p-4 p-md-5">
            <!-- 헤더 -->
            <div class="text-center mb-4">
                <h2 class="fw-bold mb-2"><i class="bi bi-box-arrow-in-right text-primary"></i> 로그인</h2>
                <p class="text-muted">TripWiki에 오신 것을 환영합니다</p>
            </div>

            <!-- 회원가입 성공 메시지 -->
            <c:if test="${param.status eq 'signupSuccess'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill"></i> 회원가입이 완료되었습니다. 로그인해주세요.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            </c:if>

            <!-- 로그인 실패 메시지 -->
            <% if ("loginFail".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> 아이디 또는 비밀번호가 일치하지 않습니다.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <form name="signinForm" action="${pageContext.request.contextPath}/auth" method="post" id="signinForm">
                <input type="hidden" name="action" value="signin">

                <!-- 아이디 -->
                <div class="mb-3">
                    <label for="userId" class="form-label fw-semibold">
                        <i class="bi bi-person"></i> 아이디
                    </label>
                    <input type="text" class="form-control" name="userId" id="userId" placeholder="아이디를 입력해주세요" required>
                </div>

                <!-- 비밀번호 -->
                <div class="mb-4">
                    <label for="userPassword" class="form-label fw-semibold">
                        <i class="bi bi-lock"></i> 비밀번호
                    </label>
                    <input type="password" class="form-control" name="userPassword" id="userPassword" placeholder="비밀번호를 입력해주세요" required>
                </div>

                <!-- 로그인 버튼 -->
                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold" style="border-radius: 8px;">
                    <i class="bi bi-check-lg"></i> 로그인
                </button>

                <!-- 회원가입 링크 -->
                <div class="text-center mt-3">
                    <small class="text-muted">
                        아직 계정이 없으신가요?
                        <a href="${pageContext.request.contextPath}/pages/signUp.jsp" class="text-decoration-none">회원가입</a>
                    </small>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/utils/authManager.js"></script>
<script>
    /**
     * signIn.jsp 스크립트
     * - AJAX를 이용한 로그인 처리 및 AuthManager를 통해 사용자 정보를 세션 스토리지에 저장합니다.
     */
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
                    Swal.fire({
                        icon: 'error',
                        title: '오류 발생',
                        text: '로그인 처리 중 오류가 발생했습니다.',
                        timer: 2000,
                        timerProgressBar: true,
                        showConfirmButton: false,
                        background: isDarkMode ? '#2a2a2a' : '#fff',
                        color: isDarkMode ? '#eaeaea' : '#000'
                    });
                });
            });
        }
    });
</script>
</body>
</html>
