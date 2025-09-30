document.addEventListener('DOMContentLoaded', function() {
    const loggedInUserJson = sessionStorage.getItem('loggedInUser');
    const loginLink = document.querySelector('#nav-login');
    const signupLink = document.querySelector('#nav-signup');

    if (loggedInUserJson && loginLink && signupLink) {
        const loggedInUser = JSON.parse(loggedInUserJson);
        loginLink.textContent = `${loggedInUser.name}님`;
        loginLink.href = '#';

        // --- 회원가입 링크를 로그아웃 버튼으로 변경 ---
        signupLink.textContent = '로그아웃';
        signupLink.href = '#';

        signupLink.addEventListener('click', function(e) {
            e.preventDefault();
            sessionStorage.removeItem('loggedInUser');
            alert('로그아웃 되었습니다.');
            window.location.reload();
        });
    }
});