<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<!-- Password Verification Modal -->
<div class="modal fade" id="passwordVerificationModal" tabindex="-1" aria-labelledby="passwordVerificationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="passwordVerificationModalLabel">비밀번호 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>마이페이지에 접근하려면 비밀번호를 입력해주세요.</p>
                <input type="password" id="verifyPasswordInput" class="form-control" placeholder="비밀번호" required>
                <div id="verifyPasswordError" class="text-danger mt-2" style="display: none;"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="verifyPasswordBtn">확인</button>
            </div>
        </div>
    </div>
</div>

<div class="container" id="myPageContent" style="display: none; max-width: 900px; margin-top: 70px; margin-bottom: 50px;">
    <div class="text-center mb-4">
        <h2 class="fw-bold">내 정보 관리</h2>
        <p class="text-muted">개인정보를 안전하게 관리하세요</p>
    </div>

    <div class="row g-4">
        <%-- 사용자 정보 표시 --%>
        <div class="col-md-6">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="bi bi-person-circle"></i> 기본 정보</h5>
                    <div class="mb-3">
                        <label class="text-muted small mb-1">아이디</label>
                        <div class="fw-bold"><%= ((AuthenticatedUser)session.getAttribute("authenticatedUser")).getUserId() %></div>
                    </div>
                    <div class="mb-3">
                        <label class="text-muted small mb-1">성별</label>
                        <%
                            String gender = ((AuthenticatedUser)session.getAttribute("authenticatedUser")).getGender();
                            String displayGender = "알 수 없음";
                            if ("male".equalsIgnoreCase(gender)) {
                                displayGender = "남성";
                            } else if ("female".equalsIgnoreCase(gender)) {
                                displayGender = "여성";
                            }
                        %>
                        <div class="fw-bold"><%= displayGender %></div>
                    </div>
                    <div class="mb-0">
                        <label class="text-muted small mb-1">현재 이메일</label>
                        <div class="fw-bold"><%= ((AuthenticatedUser)session.getAttribute("authenticatedUser")).getEmail() %></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 비밀번호 변경 영역 -->
        <div class="col-md-6">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="bi bi-shield-lock"></i> 비밀번호 변경</h5>
                    <div id="pwMsg"></div>
                    <div class="mb-2">
                        <input type="password" id="currentPassword" class="form-control form-control-sm" placeholder="현재 비밀번호" required>
                    </div>
                    <div class="mb-2">
                        <input type="password" id="newPassword" class="form-control form-control-sm" placeholder="새 비밀번호" required>
                    </div>
                    <div class="mb-3">
                        <input type="password" id="confirmPassword" class="form-control form-control-sm" placeholder="새 비밀번호 확인" required>
                    </div>
                    <button class="btn btn-primary w-100" onclick="changePassword()">비밀번호 변경</button>
                </div>
            </div>
        </div>

        <!-- 이메일 변경 영역 -->
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="bi bi-envelope"></i> 이메일 변경</h5>
                    <div id="emailMsg"></div>
                    <div class="row align-items-end">
                        <div class="col-md-8">
                            <input type="email" id="newEmail" class="form-control" placeholder="새 이메일 주소 입력" required>
                        </div>
                        <div class="col-md-4 mt-2 mt-md-0">
                            <button class="btn btn-primary w-100" onclick="changeEmail()">이메일 변경</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .card {
        border: none;
        border-radius: 12px;
        transition: transform 0.2s, background-color 0.3s, border-color 0.3s;
    }
    .card:hover {
        transform: translateY(-5px);
    }
    .card-title {
        color: #495057;
        font-weight: 600;
        font-size: 1.1rem;
    }
    .card-title i {
        margin-right: 8px;
        color: #007bff;
    }
    .form-control-sm {
        border-radius: 8px;
    }
    .btn-primary {
        border-radius: 8px;
        padding: 10px;
        font-weight: 500;
    }

    /* 다크모드 스타일 */
    [data-mode="dark"] .card {
        background-color: #2a2a2a;
        border-color: #444;
    }
    [data-mode="dark"] .card-title {
        color: #eaeaea;
    }
    [data-mode="dark"] .form-control,
    [data-mode="dark"] .form-control-sm {
        background-color: #333;
        border-color: #555;
        color: #eaeaea;
    }
    [data-mode="dark"] .form-control:focus,
    [data-mode="dark"] .form-control-sm:focus {
        background-color: #3a3a3a;
        border-color: #0d6efd;
        color: #eaeaea;
    }
    [data-mode="dark"] .text-muted {
        color: #aaa !important;
    }
    [data-mode="dark"] .fw-bold {
        color: #eaeaea;
    }
    [data-mode="dark"] h2 {
        color: #eaeaea;
    }
    [data-mode="dark"] .modal-content {
        background-color: #2a2a2a;
        color: #eaeaea;
    }
    [data-mode="dark"] .modal-header {
        border-bottom-color: #444;
    }
    [data-mode="dark"] .modal-footer {
        border-top-color: #444;
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/utils/authManager.js"></script>
<script>
    // Function to handle password change
    async function changePassword() {
        const isDarkMode = document.body.getAttribute('data-mode') === 'dark';
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

        const msgEl = document.getElementById("pwMsg");
        if (data.success) {
            Swal.fire({
                icon: 'success',
                title: '비밀번호 변경 성공!',
                text: data.message,
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false,
                background: isDarkMode ? '#2a2a2a' : '#fff',
                color: isDarkMode ? '#eaeaea' : '#000'
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: '비밀번호 변경 실패',
                text: data.message,
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false,
                background: isDarkMode ? '#2a2a2a' : '#fff',
                color: isDarkMode ? '#eaeaea' : '#000'
            });
        }
    }

    // Function to handle email change
    async function changeEmail() {
        const isDarkMode = document.body.getAttribute('data-mode') === 'dark';
        const newEmail = document.getElementById("newEmail").value;
        const emailMsgEl = document.getElementById("emailMsg");

        if (!newEmail) {
            Swal.fire({
                icon: 'warning',
                title: '이메일 입력',
                text: '새 이메일을 입력해주세요.',
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false,
                background: isDarkMode ? '#2a2a2a' : '#fff',
                color: isDarkMode ? '#eaeaea' : '#000'
            });
            return;
        }

        // Client-side email format validation
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!emailPattern.test(newEmail)) {
            Swal.fire({
                icon: 'warning',
                title: '이메일 형식 오류',
                text: '유효하지 않은 이메일 형식입니다.',
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false,
                background: isDarkMode ? '#2a2a2a' : '#fff',
                color: isDarkMode ? '#eaeaea' : '#000'
            });
            return;
        }

        const formData = new URLSearchParams();
        formData.append("newEmail", newEmail);

        try {
            const res = await fetch("${pageContext.request.contextPath}/mypage/change-email", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: formData
            });

            const data = await res.json();

            if (data.success) {
                Swal.fire({
                    icon: 'success',
                    title: '이메일 변경 성공!',
                    text: data.message,
                    timer: 2000,
                    timerProgressBar: true,
                    showConfirmButton: false,
                    background: isDarkMode ? '#2a2a2a' : '#fff',
                    color: isDarkMode ? '#eaeaea' : '#000'
                }).then(() => {
                    window.location.href = '${pageContext.request.contextPath}/index.jsp'; // Redirect to index.jsp
                });
            } else {
                let timer = 2000;
                if (data.message.includes("이미 사용 중인 이메일입니다.")) {
                    timer = 4000; // 4 seconds for duplicate email error
                }
                Swal.fire({
                    icon: 'error',
                    title: '이메일 변경 실패',
                    text: data.message,
                    timer: timer,
                    timerProgressBar: true,
                    showConfirmButton: false,
                    background: isDarkMode ? '#2a2a2a' : '#fff',
                    color: isDarkMode ? '#eaeaea' : '#000'
                });
            }
        } catch (error) {
            console.error('Email change error:', error);
            Swal.fire({
                icon: 'error',
                title: '오류 발생',
                text: '이메일 변경 중 오류가 발생했습니다.',
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false,
                background: isDarkMode ? '#2a2a2a' : '#fff',
                color: isDarkMode ? '#eaeaea' : '#000'
            });
        }
    }

    // Password verification logic for myPage access
    document.addEventListener('DOMContentLoaded', function() {
        const myPageContent = document.getElementById('myPageContent');
        const passwordVerificationModal = new bootstrap.Modal(document.getElementById('passwordVerificationModal'));
        const verifyPasswordInput = document.getElementById('verifyPasswordInput');
        const verifyPasswordBtn = document.getElementById('verifyPasswordBtn');
        const verifyPasswordError = document.getElementById('verifyPasswordError');

        // Show modal on page load
        passwordVerificationModal.show();

        verifyPasswordBtn.addEventListener('click', async function() {
            const isDarkMode = document.body.getAttribute('data-mode') === 'dark';
            const password = verifyPasswordInput.value;
            if (!password) {
                verifyPasswordError.textContent = '비밀번호를 입력해주세요.';
                verifyPasswordError.style.display = 'block';
                return;
            }

            verifyPasswordError.style.display = 'none';

            // Retrieve userId from session (assuming it's available via AuthManager or a hidden input)
            // If not, you'll need to pass the userId from the server-side to the JSP.
            const userId = AuthManager.getUserId(); // Assuming AuthManager provides this

            const formData = new URLSearchParams();
            formData.append("action", "signin"); // Reuse existing signin action
            formData.append("ajax", "true");
            formData.append("userId", userId); // Pass the logged-in user's ID
            formData.append("userPassword", password); // Pass the password from the modal

            try {
                const response = await fetch("${pageContext.request.contextPath}/auth", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData
                });
                const data = await response.json();

                if (data.success) {
                    passwordVerificationModal.hide();
                    myPageContent.style.display = 'block'; // Show my page content
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '비밀번호 불일치',
                        text: '비밀번호가 일치하지 않습니다.',
                        timer: 2000,
                        timerProgressBar: true,
                        showConfirmButton: false,
                        background: isDarkMode ? '#2a2a2a' : '#fff',
                        color: isDarkMode ? '#eaeaea' : '#000'
                    }).then(() => {
                        window.location.href = '${pageContext.request.contextPath}/index.jsp'; // Redirect to index.jsp
                    });
                }
            } catch (error) {
                console.error('Password verification error:', error);
                Swal.fire({
                    icon: 'error',
                    title: '오류 발생',
                    text: '비밀번호 확인 중 오류가 발생했습니다.',
                    timer: 2000,
                    timerProgressBar: true,
                    showConfirmButton: false,
                    background: isDarkMode ? '#2a2a2a' : '#fff',
                    color: isDarkMode ? '#eaeaea' : '#000'
                }).then(() => {
                    window.location.href = '${pageContext.request.contextPath}/index.jsp'; // Redirect to index.jsp
                });
            }
        });

        // Handle modal close button click (redirect to index.jsp if closed without verification)
        document.getElementById('passwordVerificationModal').addEventListener('hidden.bs.modal', function () {
            if (myPageContent.style.display === 'none') { // If content is still hidden, means user closed modal without verifying
                window.location.href = '${pageContext.request.contextPath}/index.jsp';
            }
        });
    });
</script>
</body>
</html>