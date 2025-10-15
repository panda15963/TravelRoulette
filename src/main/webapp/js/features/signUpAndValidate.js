/**
 * @file signUpAndValidate.js
 * 회원가입, 로그인 등 인증 관련 폼의 유효성 검사 로직을 제공합니다.
 */

/**
 * 서버에 특정 필드(userId, email)의 중복 여부를 비동기적으로 확인합니다.
 * @param {string} type - 확인할 필드 타입 ('userId' 또는 'email').
 * @param {string} value - 확인할 값.
 * @param {string} contextPath - 애플리케이션의 컨텍스트 경로.
 * @returns {Promise<{isValid: boolean, message: string}>} 검증 결과 객체를 담은 프로미스.
 */
async function checkDuplicate(type, value, contextPath) {
    const action = type === 'userId' ? 'checkUserIdDuplicate' : 'checkEmailDuplicate';

    const formData = new URLSearchParams();
    formData.append("action", action);
    formData.append(type, value);

    try {
        const response = await fetch(`${contextPath}/auth`, {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: formData
        });
        const data = await response.json();
        return { isValid: !data.isDuplicate, message: data.message };
    } catch (error) {
        console.error(`${type} duplicate check error:`, error);
        return { isValid: false, message: `서버 오류: ${type} 중복 확인 실패` };
    }
}

// 기존 유효성 검사 로직 (submit 시)
const createSignupSubmitHandler = (form) => (event) => {
    const { userPassword, passwordChk, email } = form;
    const password = userPassword.value;
    const passwordConfirm = passwordChk.value;
    const emailValue = email.value;

    if (password !== passwordConfirm) {
        event.preventDefault();
        // SweetAlert는 JSP에서 직접 처리하므로 여기서는 alert 또는 console 경고만 사용
        alert('비밀번호가 일치하지 않습니다.');
        return;
    }

    if (!/^[^@]+@[^@]+\.[^@]+$/.test(emailValue)) {
        event.preventDefault();
        alert('이메일 주소 형식이 올바르지 않습니다.');
        return;
    }
};

const createSigninSubmitHandler = (form) => (event) => {
    const userId = form.userId.value;
    const password = form.userPassword.value;
    if (!userId.trim() || !password.trim()) {
        event.preventDefault();
        alert('아이디와 비밀번호를 모두 입력해주세요.');
    }
};

const initAuthFormValidation = () => {
    const signupForm = document.forms.signupForm;
    if (signupForm) {
        signupForm.addEventListener('submit', createSignupSubmitHandler(signupForm));
    }

    const signinForm = document.forms.signinForm;
    if (signinForm) {
        signinForm.addEventListener('submit', createSigninSubmitHandler(signinForm));
    }
};

document.addEventListener('DOMContentLoaded', initAuthFormValidation);