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

<div class="container" style="max-width: 550px; margin-top: 70px; margin-bottom: 50px;">
    <div class="card shadow-sm" style="border: none; border-radius: 16px;">
        <div class="card-body p-4 p-md-5">
            <!-- 헤더 -->
            <div class="text-center mb-4">
                <h2 class="fw-bold mb-2"><i class="bi bi-person-plus-fill text-primary"></i> 회원가입</h2>
                <p class="text-muted">TripWiki와 함께 여행을 시작하세요</p>
            </div>

            <%
                String error = request.getParameter("error");
                String errorMessage = "";
                if (error != null) {
                    switch (error) {
                        case "idDuplicate": errorMessage = "이미 사용 중인 아이디입니다."; break;
                        case "emailDuplicate": errorMessage = "이미 등록된 이메일입니다."; break;
                        case "validationFail": errorMessage = "입력 형식이 올바르지 않습니다."; break;
                    }
                }
            %>
            <% if (!errorMessage.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <form name="signupForm" action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="action" value="signup">

                <!-- 아이디 -->
                <div class="mb-3">
                    <label for="userId" class="form-label fw-semibold">
                        <i class="bi bi-person"></i> 아이디
                    </label>
                    <div class="input-group">
                        <input type="text" class="form-control" name="userId" id="userId" placeholder="아이디를 입력해주세요" required>
                        <button class="btn btn-outline-primary" type="button" id="checkUserIdDuplicateBtn">
                            <i class="bi bi-check-circle"></i> 중복확인
                        </button>
                    </div>
                    <div id="userIdMessage" class="form-text"></div>
                </div>

                <!-- 비밀번호 -->
                <div class="mb-3">
                    <label for="userPassword" class="form-label fw-semibold">
                        <i class="bi bi-lock"></i> 비밀번호
                    </label>
                    <input type="password" class="form-control" name="userPassword" id="userPassword" placeholder="비밀번호를 입력해주세요" required>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="mb-3">
                    <label for="passwordChk" class="form-label fw-semibold">
                        <i class="bi bi-lock-fill"></i> 비밀번호 확인
                    </label>
                    <input type="password" class="form-control" name="passwordChk" id="passwordChk" placeholder="비밀번호를 다시 입력해주세요" required>
                    <div id="passwordChkMessage" class="form-text"></div>
                </div>

                <!-- 이메일 -->
                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold">
                        <i class="bi bi-envelope"></i> 이메일
                    </label>
                    <div class="input-group">
                        <input type="email" class="form-control" name="email" id="email" placeholder="이메일 주소를 입력해주세요" required>
                        <button class="btn btn-outline-primary" type="button" id="checkEmailDuplicateBtn">
                            <i class="bi bi-check-circle"></i> 중복확인
                        </button>
                    </div>
                    <div id="emailMessage" class="form-text"></div>
                </div>

                <!-- 성별 -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">
                        <i class="bi bi-gender-ambiguous"></i> 성별
                    </label>
                    <div class="d-flex gap-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" id="male" value="male" checked>
                            <label class="form-check-label" for="male">
                                남성
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" id="female" value="female">
                            <label class="form-check-label" for="female">
                                여성
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 가입 버튼 -->
                <button type="submit" id="submitBtn" class="btn btn-primary w-100 py-2 fw-semibold" style="border-radius: 8px;">
                    <i class="bi bi-check-lg"></i> 가입하기
                </button>

                <!-- 로그인 링크 -->
                <div class="text-center mt-3">
                    <small class="text-muted">
                        이미 계정이 있으신가요?
                        <a href="${pageContext.request.contextPath}/pages/signIn.jsp" class="text-decoration-none">로그인</a>
                    </small>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/features/signUpAndValidate.js"></script>
<script>
    /**
     * signUp.jsp 스크립트
     * - 회원가입 폼의 실시간 유효성 검사 및 UI 피드백을 처리합니다.
     */
    document.addEventListener('DOMContentLoaded', function() {
        // --- DOM 요소 및 컨텍스트 경로 변수 선언 ---
        const contextPath = '${pageContext.request.contextPath}';
        const signupForm = document.forms.signupForm;
        const checkUserIdDuplicateBtn = document.getElementById('checkUserIdDuplicateBtn');
        const checkEmailDuplicateBtn = document.getElementById('checkEmailDuplicateBtn');
        const userIdInput = document.getElementById('userId');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('userPassword');
        const passwordChkInput = document.getElementById('passwordChk');
        const submitBtn = document.getElementById('submitBtn');

        const userIdMessage = document.getElementById('userIdMessage');
        const emailMessage = document.getElementById('emailMessage');
        const passwordChkMessage = document.getElementById('passwordChkMessage');

        // --- 유효성 검사 상태를 추적하는 플래그 ---
        let isIdCheckedAndValid = false;
        let isEmailCheckedAndValid = false;

        /**
         * ✅ 전체 폼의 유효성을 검사하는 함수
         */
        function isFormValid() {
            const isPasswordValid = passwordInput.value !== '' && passwordInput.value === passwordChkInput.value;
            const areAllFieldsFilled = userIdInput.value !== '' && emailInput.value !== '' && passwordInput.value !== '' && passwordChkInput.value !== '';
            return isIdCheckedAndValid && isEmailCheckedAndValid && isPasswordValid && areAllFieldsFilled;
        }

        /**
         * ✅ 폼 유효성 상태에 따라 가입 버튼의 시각적/기능적 상태를 업데이트하는 함수
         */
        function updateSubmitButtonState() {
            if (isFormValid()) {
                submitBtn.classList.remove('btn-custom-disabled');
            } else {
                submitBtn.classList.add('btn-custom-disabled');
            }
        }

        /**
         * ✅ 사용자가 입력 필드를 수정할 때 유효성 상태를 초기화하고 안내 메시지를 표시하는 함수
         */
        function handleValidationInput(inputElement, messageElement, flagSetter, validationMessage) {
            flagSetter(false);
            messageElement.textContent = validationMessage;
            messageElement.style.color = 'red';
            updateSubmitButtonState();
        }

        // --- 각 입력 필드에 대한 실시간 이벤트 리스너 ---
        userIdInput.addEventListener('input', () => handleValidationInput(userIdInput, userIdMessage, (val) => isIdCheckedAndValid = val, '아이디 중복확인을 해야합니다.'));
        emailInput.addEventListener('input', () => handleValidationInput(emailInput, emailMessage, (val) => isEmailCheckedAndValid = val, '이메일 중복확인을 해야합니다.'));

        /**
         * ✅ 비밀번호 일치 여부를 실시간으로 확인하는 함수
         */
        function checkPasswordMatch() {
            if (passwordInput.value !== '' && passwordChkInput.value !== '') {
                if (passwordInput.value === passwordChkInput.value) {
                    passwordChkMessage.textContent = '비밀번호가 일치합니다.';
                    passwordChkMessage.style.color = 'green';
                } else {
                    passwordChkMessage.textContent = '비밀번호가 일치하지 않습니다.';
                    passwordChkMessage.style.color = 'red';
                }
            } else {
                passwordChkMessage.textContent = '';
            }
            updateSubmitButtonState();
        }

        passwordInput.addEventListener('input', checkPasswordMatch);
        passwordChkInput.addEventListener('input', checkPasswordMatch);

        // --- 중복 확인 버튼 이벤트 리스너 ---
        if (checkUserIdDuplicateBtn) {
            checkUserIdDuplicateBtn.addEventListener('click', async function() {
                const isDarkMode = document.body.getAttribute('data-mode') === 'dark';
                const userId = userIdInput.value;
                if (!userId) {
                    Swal.fire({ icon: 'warning', title: '아이디 입력', text: '아이디를 입력해주세요.', timer: 2000, timerProgressBar: true, showConfirmButton: false, background: isDarkMode ? '#2a2a2a' : '#fff', color: isDarkMode ? '#eaeaea' : '#000' });
                    return;
                }
                const result = await checkDuplicate('userId', userId, contextPath);
                isIdCheckedAndValid = result.isValid;
                Swal.fire({ icon: result.isValid ? 'success' : 'error', title: '중복 확인', text: result.message, timer: 2000, timerProgressBar: true, showConfirmButton: false, background: isDarkMode ? '#2a2a2a' : '#fff', color: isDarkMode ? '#eaeaea' : '#000' });
                userIdMessage.textContent = result.message;
                userIdMessage.style.color = result.isValid ? 'green' : 'red';
                updateSubmitButtonState();
            });
        }

        if (checkEmailDuplicateBtn) {
            checkEmailDuplicateBtn.addEventListener('click', async function() {
                const isDarkMode = document.body.getAttribute('data-mode') === 'dark';
                const email = emailInput.value;
                if (!email) {
                    Swal.fire({ icon: 'warning', title: '이메일 입력', text: '이메일을 입력해주세요.', timer: 2000, timerProgressBar: true, showConfirmButton: false, background: isDarkMode ? '#2a2a2a' : '#fff', color: isDarkMode ? '#eaeaea' : '#000' });
                    return;
                }
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
                if (!emailPattern.test(email)) {
                    Swal.fire({ icon: 'warning', title: '이메일 형식 오류', text: '유효하지 않은 이메일 형식입니다.', timer: 2000, timerProgressBar: true, showConfirmButton: false, background: isDarkMode ? '#2a2a2a' : '#fff', color: isDarkMode ? '#eaeaea' : '#000' });
                    return;
                }
                const result = await checkDuplicate('email', email, contextPath);
                isEmailCheckedAndValid = result.isValid;
                Swal.fire({ icon: result.isValid ? 'success' : 'error', title: '중복 확인', text: result.message, timer: 2000, timerProgressBar: true, showConfirmButton: false, background: isDarkMode ? '#2a2a2a' : '#fff', color: isDarkMode ? '#eaeaea' : '#000' });
                emailMessage.textContent = result.message;
                emailMessage.style.color = result.isValid ? 'green' : 'red';
                updateSubmitButtonState();
            });
        }

        // --- 최종 가입 버튼 클릭 이벤트 핸들러 ---
        submitBtn.addEventListener('click', function(event) {
            event.preventDefault(); // 폼 제출을 일단 막습니다.
            const isDarkMode = document.body.getAttribute('data-mode') === 'dark';

            if (isFormValid()) {
                signupForm.submit(); // 유효하면 폼을 제출합니다.
            } else {
                // 유효하지 않은 이유를 찾아 안내 메시지를 표시합니다.
                let alertMessage = '';
                if (userIdInput.value === '' || emailInput.value === '' || passwordInput.value === '' || passwordChkInput.value === '') {
                    alertMessage = '모든 입력칸을 채워주세요.';
                } else if (!isIdCheckedAndValid) {
                    alertMessage = '아이디 중복확인을 해주세요.';
                } else if (!isEmailCheckedAndValid) {
                    alertMessage = '이메일 중복확인을 해주세요.';
                } else if (passwordInput.value !== passwordChkInput.value) {
                    alertMessage = '비밀번호가 일치하지 않습니다.';
                }
                Swal.fire({
                    icon: 'error',
                    title: '가입 조건 미충족',
                    text: alertMessage,
                    background: isDarkMode ? '#2a2a2a' : '#fff',
                    color: isDarkMode ? '#eaeaea' : '#000'
                });
            }
        });

        // 페이지 로드 시 버튼의 초기 상태를 설정합니다.
        updateSubmitButtonState();
    });
</script>
</body>
</html>
