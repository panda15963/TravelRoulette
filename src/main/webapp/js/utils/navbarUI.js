/**
 * Navbar UI Manager
 * 네비게이션 바와 사이드바의 UI 업데이트를 담당
 * AuthManager에 의존하여 로그인 상태에 따라 메뉴를 변경
 */
const NavbarUI = {
    /**
     * 네비게이션 바 UI 업데이트
     */
    updateNavbar() {
        const contextPath = AuthManager.getContextPath();

        // navbar와 sidebar의 로그인/회원가입 링크들 가져오기
        const navbarLoginLink = document.getElementById('nav-login');
        const navbarSignupLink = document.getElementById('nav-signup');
        const sidebarLoginLink = document.getElementById('sidebar-login');
        const sidebarSignupLink = document.getElementById('sidebar-signup');

        const loginLinks = [navbarLoginLink, sidebarLoginLink].filter(link => link !== null);
        const signupLinks = [navbarSignupLink, sidebarSignupLink].filter(link => link !== null);

        if (loginLinks.length === 0 || signupLinks.length === 0) return;

        if (AuthManager.isLoggedIn()) {
            const user = AuthManager.getUser();
            const userId = user ? user.userId : '사용자';

            // 모든 로그인 링크를 사용자명으로 변경
            loginLinks.forEach(loginLink => {
                loginLink.textContent = `${userId}님`;
                loginLink.href = '#';
                loginLink.style.cursor = 'default';
                loginLink.classList.add('text-primary', 'fw-bold');
            });

            // 모든 회원가입 링크를 로그아웃으로 변경
            signupLinks.forEach(signupLink => {
                signupLink.textContent = '로그아웃';
                signupLink.href = '#';
                signupLink.onclick = (e) => {
                    e.preventDefault();
                    this.handleLogout();
                };
            });
        } else {
            // 로그아웃 상태로 복원
            loginLinks.forEach(loginLink => {
                loginLink.textContent = '로그인';
                loginLink.href = `${contextPath}/pages/signIn.jsp`;
                loginLink.style.cursor = 'pointer';
                loginLink.classList.remove('text-primary', 'fw-bold');
            });

            signupLinks.forEach(signupLink => {
                signupLink.textContent = '회원가입';
                signupLink.href = `${contextPath}/pages/signUp.jsp`;
                signupLink.onclick = null;
            });
        }
    },

    /**
     * 로그아웃 처리
     */
    handleLogout() {
        if (confirm('로그아웃 하시겠습니까?')) {
            const contextPath = AuthManager.getContextPath();

            // 세션 스토리지 삭제
            AuthManager.clearUser();

            // 서버 세션 무효화
            fetch(`${contextPath}/auth`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=signout'
            }).then(() => {
                alert('로그아웃 되었습니다.');
                window.location.href = `${contextPath}/index.jsp`;
            }).catch((error) => {
                console.error('로그아웃 중 오류 발생:', error);
                // 오류가 발생해도 클라이언트는 로그아웃 처리
                alert('로그아웃 되었습니다.');
                window.location.href = `${contextPath}/index.jsp`;
            });
        }
    },

    /**
     * 페이지 로드 시 초기화
     */
    init() {
        // 네비게이션 바 업데이트
        this.updateNavbar();
    }
};

// DOM 로드 완료 시 자동 초기화
document.addEventListener('DOMContentLoaded', () => {
    NavbarUI.init();
});
