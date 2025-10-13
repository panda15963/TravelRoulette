const createSignupSubmitHandler = (form) => (event) => {
    const { userPassword, passwordChk, email } = form;
    const password = userPassword.value;
    const passwordConfirm = passwordChk.value;
    const emailValue = email.value;

    if (password !== passwordConfirm) {
        event.preventDefault();
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
