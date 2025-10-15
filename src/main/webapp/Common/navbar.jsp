<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ include file="/Common/AuthInit.jsp" %>
<%@ page import="com.travelroulette.Dto.User.AuthenticatedUser" %>
<!-- Navigation-->
<!-- authUser는 AuthInit.jsp에서 request.setAttribute("authUser", ...)로 저장되어 있음 -->
<nav id = "mainNavbar" class = "navbar navbar-expand-lg navbar-light bg-light fixed-top"
     style = "border-bottom: 1px solid #000000;">
	<div class = "container px-5">
		<a class = "navbar-brand" href = "${pageContext.request.contextPath}/index.jsp">
			<img src = "${pageContext.request.contextPath}/images/logo.png" alt = "Logo" width = "30" height = "30"
			     class = "d-inline-block align-text-top">
			TripWiki
		</a>

		<!-- 햄버거 버튼 -->
		<button class = "navbar-toggler" type = "button" data-bs-toggle = "offcanvas"
		        data-bs-target = "#sidebarMenu" aria-controls = "sidebarMenu">
			<span class = "navbar-toggler-icon"></span>
		</button>

        <!-- 메뉴 -->
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/kanban.jsp">칸반</a></li>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/board/common/mainBoard.jsp">게시판</a></li>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/video.jsp">도시홍보영상</a></li>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/chart.jsp">환율 차트</a></li>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/music.jsp">음악 차트</a></li>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/map.jsp">지도</a></li>

                <% if (request.getAttribute("authUser") == null) { %>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/signIn.jsp">로그인</a></li>
                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/pages/signUp.jsp">회원가입</a></li>
                <% } else { %>
                <li class="nav-item"><a class="nav-link text-primary fw-bold"
                                        href="#"><%= ((AuthenticatedUser)request.getAttribute("authUser")).getUserId() %>님</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="#" id="navLogoutBtn">로그아웃</a>
                </li>
                <% } %>
                <!-- 다크모드 토글 버튼 -->
                <li class="nav-item">
                    <button id="modeToggle"
                            class="btn btn-outline-light btn-sm ms-3"
                            style="border:1px solid white;">
                        🌙
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>






















<!-- 로그인 상태 관리 -->
<form id="navLogoutForm" action="${pageContext.request.contextPath}/auth" method="post" style="display: none;">
    <input type="hidden" name="action" value="signout">
</form>

<script>
    // 로그아웃 버튼 클릭 이벤트
    document.addEventListener('DOMContentLoaded', function() {
        const logoutBtn = document.getElementById('navLogoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function(e) {
                e.preventDefault();

                // sessionStorage 파기
                if (typeof AuthManager !== 'undefined') {
                    AuthManager.clearUser();
                }

                // 서버 로그아웃 (세션 무효화)
                document.getElementById('navLogoutForm').submit();
            });
        }
    });
</script>