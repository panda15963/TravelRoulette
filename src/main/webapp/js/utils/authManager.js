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

    requireLogin(redirectUrl = null) {
        if (!this.isLoggedIn()) {
            const returnUrl = redirectUrl || window.location.href;
            const contextPath = this.getContextPath();
            alert('로그인이 필요한 서비스입니다.');
            window.location.href = `${contextPath}/signIn.jsp?returnUrl=${encodeURIComponent(returnUrl)}`;
            return false;
        }
        return true;
    },
    */
    getContextPath() {
        const path = window.location.pathname;
        const index = path.indexOf('/', 1);
        return index > 0 ? path.substring(0, index) : '';
    },

    requireLogin(redirectUrl = null) {
        if (!this.isLoggedIn()) {
            const contextPath = this.getContextPath();
            alert('로그인이 필요한 서비스입니다.');
            // returnUrl 제거하고 단순 이동
            window.location.href = `${contextPath}/pages/signIn.jsp`;
            return false;
        }
        return true;
    },

    /**
     * Context Path 가져오기
     * @returns {string} Context Path
     */
    getContextPath() {
        const pathArray = window.location.pathname.split('/');
        return pathArray.length > 1 ? `/${pathArray[1]}` : '';
    }
};
