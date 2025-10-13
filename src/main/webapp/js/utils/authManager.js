const AuthManager = {
    // 세션 스토리지 키
    SESSION_KEY: 'authenticatedUser',

    /**
     * 로그인 상태 확인
     * @returns {boolean} 로그인 여부
     */
    isLoggedIn() {
        return sessionStorage.getItem(this.SESSION_KEY) !== null;
    },

    /**
     * 사용자 정보 저장
     * @param {Object} userData - 사용자 정보 객체 {userId, email}
     */
    setUser(userData) {
        sessionStorage.setItem(this.SESSION_KEY, JSON.stringify(userData));
    },

    /**
     * 사용자 정보 가져오기
     * @returns {Object|null} 사용자 정보 또는 null
     */
    getUser() {
        const userData = sessionStorage.getItem(this.SESSION_KEY);
        return userData ? JSON.parse(userData) : null;
    },

    /**
     * 로그아웃 (세션 스토리지 삭제)
     */
    clearUser() {
        sessionStorage.removeItem(this.SESSION_KEY);
    },

    /**
     * 사용자 ID 가져오기
     * @returns {string|null} 사용자 ID 또는 null
     */
    getUserId() {
        const user = this.getUser();
        return user ? user.userId : null;
    },

    /**
     * 로그인 필요한 페이지 접근 체크
     * @param {string} redirectUrl - 로그인 후 돌아갈 URL (선택사항)
     */
    requireLogin(redirectUrl = null) {
        if (!this.isLoggedIn()) {
            const returnUrl = redirectUrl || window.location.href;
            const contextPath = this.getContextPath();
            alert('로그인이 필요한 서비스입니다.');
            window.location.href = `${contextPath}/pages/signIn.jsp?returnUrl=${encodeURIComponent(returnUrl)}`;
            return false;
        }
        return true;
    },

    /**
     * 네비게이션 바 UI 업데이트
     */
    updateNavbar() {
        const loginLink = document.getElementById('nav-login');
        const signupLink = document.getElementById('nav-signup');

        if (!loginLink || !signupLink) return;

        if (this.isLoggedIn()) {
            const user = this.getUser();
            const userId = user ? user.userId : '사용자';

            // 로그인/회원가입을 사용자명/로그아웃으로 변경
            loginLink.textContent = `${userId}님`;
            loginLink.href = '#';
            loginLink.style.cursor = 'default';
            loginLink.classList.add('text-primary', 'fw-bold');

            signupLink.textContent = '로그아웃';
            signupLink.href = '#';
            signupLink.onclick = (e) => {
                e.preventDefault();
                this.logout();
            };
        } else {
            // 로그아웃 상태로 복원
            loginLink.textContent = '로그인';
            loginLink.href = `${this.getContextPath()}/pages/signIn.jsp`;
            loginLink.style.cursor = 'pointer';
            loginLink.classList.remove('text-primary', 'fw-bold');

            signupLink.textContent = '회원가입';
            signupLink.href = `${this.getContextPath()}/pages/signUp.jsp`;
            signupLink.onclick = null;
        }
    },

    /**
     * 로그아웃 처리
     */
    logout() {
        if (confirm('로그아웃 하시겠습니까?')) {
            const contextPath = this.getContextPath();

            // 세션 스토리지 삭제
            this.clearUser();

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
     * Context Path 가져오기
     * @returns {string} Context Path
     */
    getContextPath() {
        const pathArray = window.location.pathname.split('/');
        return pathArray.length > 1 ? `/${pathArray[1]}` : '';
    },

    /**
     * 페이지 로드 시 초기화
     */
    init() {
        // 네비게이션 바 업데이트
        this.updateNavbar();
    }
};

// DOM 로드 완료 시 초기화
document.addEventListener('DOMContentLoaded', () => {
    AuthManager.init();
});
