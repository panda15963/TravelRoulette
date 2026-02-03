// authManager.js - 중복 방지 + 세션스토리지 관리만
// 문제생기면 utils/temp폴더안에있는거랑 바꿔치기
// 네비바랑 사이드바 로그인 회원가입 가로채기랑 그로인한 어스매니저 중복 해결책
if (typeof AuthManager === 'undefined') {
    const AuthManager = {
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

        getContextPath() {
            const path = window.location.pathname;
            const index = path.indexOf('/', 1);
            return index > 0 ? path.substring(0, index) : '';
        },

        requireLogin(redirectUrl = null) {
            if (!this.isLoggedIn()) {
                const contextPath = this.getContextPath();
                alert('로그인이 필요한 서비스입니다.');
                window.location.href = `${contextPath}/pages/signIn.jsp`;
                return false;
            }
            return true;
        }
    };

    window.AuthManager = AuthManager;
}