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

<div class="sign-container signup-container">
    <h2>회원가입</h2>







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
    <div class="error-message"><%= errorMessage %></div>
    <% } %>

    <form name="signupForm" action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="signup">
        ID<input type="text" name="userId" id="userId" placeholder="아이디를 입력해주세요." required>
        <div id="userIdMessage" class="validation-message"></div>
                <button type="button" id="checkUserIdDuplicateBtn">아이디 중복확인</button>
        비밀번호<input type="password" name="userPassword" id="userPassword" placeholder="비밀번호를 입력해주세요." required>
        비밀번호 확인<input type="password" name="passwordChk" id="passwordChk" placeholder="비밀번호를 다시 입력해주세요." required>
        <div id="passwordChkMessage" class="validation-message"></div>
        이메일<input type="email" name="email" id="email" placeholder="이메일 주소를 입력해주세요." required>
        <div id="emailMessage" class="validation-message"></div>
               <button type="button" id="checkEmailDuplicateBtn">이메일 중복확인</button>

        <div class="radio-group">
            <input type="radio" id="male" name="gender" value="male" checked>
            <label for="male">남성</label>
            <input type="radio" id="female" name="gender" value="female">
            <label for="female">여성</label>
        </div>

        <button type="submit" id="submitBtn">가입</button>
    </form>
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
                const userId = userIdInput.value;
                if (!userId) {
                    Swal.fire({ icon: 'warning', title: '아이디 입력', text: '아이디를 입력해주세요.', timer: 2000, timerProgressBar: true, showConfirmButton: false });
                    return;
                }
                const result = await checkDuplicate('userId', userId, contextPath);
                isIdCheckedAndValid = result.isValid;
                Swal.fire({ icon: result.isValid ? 'success' : 'error', title: '중복 확인', text: result.message, timer: 2000, timerProgressBar: true, showConfirmButton: false });
                userIdMessage.textContent = result.message;
                userIdMessage.style.color = result.isValid ? 'green' : 'red';
                updateSubmitButtonState();
            });
        }

        if (checkEmailDuplicateBtn) {
            checkEmailDuplicateBtn.addEventListener('click', async function() {
                const email = emailInput.value;
                if (!email) {
                    Swal.fire({ icon: 'warning', title: '이메일 입력', text: '이메일을 입력해주세요.', timer: 2000, timerProgressBar: true, showConfirmButton: false });
                    return;
                }
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
                if (!emailPattern.test(email)) {
                    Swal.fire({ icon: 'warning', title: '이메일 형식 오류', text: '유효하지 않은 이메일 형식입니다.', timer: 2000, timerProgressBar: true, showConfirmButton: false });
                    return;
                }
                const result = await checkDuplicate('email', email, contextPath);
                isEmailCheckedAndValid = result.isValid;
                Swal.fire({ icon: result.isValid ? 'success' : 'error', title: '중복 확인', text: result.message, timer: 2000, timerProgressBar: true, showConfirmButton: false });
                emailMessage.textContent = result.message;
                emailMessage.style.color = result.isValid ? 'green' : 'red';
                updateSubmitButtonState();
            });
        }

        // --- 최종 가입 버튼 클릭 이벤트 핸들러 ---
        submitBtn.addEventListener('click', function(event) {
            event.preventDefault(); // 폼 제출을 일단 막습니다.

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
                });
            }
        });

        // 페이지 로드 시 버튼의 초기 상태를 설정합니다.
        updateSubmitButtonState();
</script>
</body>
</html>
