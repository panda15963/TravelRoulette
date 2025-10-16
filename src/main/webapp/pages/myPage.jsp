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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

<div class="sign-container mypage-container" id="myPageContent" style="display: none;">
    <h2>🙋 내 정보 관리</h2>

    <%-- 사용자 정보 표시 --%>
    <div class="card mt-4 p-4">
        <h4>기본 정보</h4>
        <div class="mb-3">
            <label class="form-label fw-bold">아이디</label>
            <p class="form-control-plaintext"><%= ((AuthenticatedUser)session.getAttribute("authenticatedUser")).getUserId() %></p>
        </div>
        <div class="mb-3">
            <label class="form-label fw-bold">성별</label>
            <% 
                String gender = ((AuthenticatedUser)session.getAttribute("authenticatedUser")).getGender();
                String displayGender = "알 수 없음";
                if ("male".equalsIgnoreCase(gender)) {
                    displayGender = "남성";
                } else if ("female".equalsIgnoreCase(gender)) {
                    displayGender = "여성";
                }
            %>
            <p class="form-control-plaintext"><%= displayGender %></p>
        </div>
    </div>

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

    <!-- 이메일 변경 영역 -->
    <div class="card mt-4 p-4">
        <h4>이메일 변경</h4>
        <div id="emailMsg"></div>
        <div class="mb-3">
            <label class="form-label">현재 이메일</label>
            <p class="form-control-plaintext"><%= ((AuthenticatedUser)session.getAttribute("authenticatedUser")).getEmail() %></p>
        </div>
        <div class="mb-3">
            <label class="form-label">새 이메일</label>
            <input type="email" id="newEmail" class="form-control" required>
        </div>
        <button class="btn btn-primary" onclick="changeEmail()">변경</button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/utils/authManager.js"></script>
<script>
    // Function to handle password change
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

        const msgEl = document.getElementById("pwMsg");
        if (data.success) {
            Swal.fire({
                icon: 'success',
                title: '비밀번호 변경 성공!',
                text: data.message,
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: '비밀번호 변경 실패',
                text: data.message,
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false
            });
        }
    }

    // Function to handle email change
    async function changeEmail() {
        const newEmail = document.getElementById("newEmail").value;
        const emailMsgEl = document.getElementById("emailMsg");

        if (!newEmail) {
            Swal.fire({
                icon: 'warning',
                title: '이메일 입력',
                text: '새 이메일을 입력해주세요.',
                timer: 2000,
                timerProgressBar: true,
                showConfirmButton: false
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
                showConfirmButton: false
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
                    showConfirmButton: false
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
                    showConfirmButton: false
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
                showConfirmButton: false
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
                        showConfirmButton: false
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
                    showConfirmButton: false
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