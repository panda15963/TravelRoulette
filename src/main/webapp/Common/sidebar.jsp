<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ include file="/Common/AuthInit.jsp" %>
<%@ page import="com.travelroulette.Dto.User.AuthenticatedUser" %>
<!-- Sidebar -->
<!-- authUser는 AuthInit.jsp에서 request.setAttribute("authUser", ...)로 저장되어 있음 -->
<div class="offcanvas offcanvas-start" tabindex="-1" id="sidebarMenu">
	<!-- 로고 + 브랜드명 -->
	<a class="navbar-brand d-flex align-items-center mb-3 mt-2 ms-3"
	   href="${pageContext.request.contextPath}/index.jsp">
		<img src="${pageContext.request.contextPath}/images/logo.png"
		     alt="Logo" width="30" height="30"
		     class="d-inline-block align-text-top me-2">
		<h5 class="mb-0 d-inline">TripWiki</h5>
	</a>

	<div class="offcanvas-body">
		<ul class="navbar-nav">
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
			                        href="${pageContext.request.contextPath}/pages/myPage.jsp"><%= ((AuthenticatedUser)request.getAttribute("authUser")).getUserId() %>님</a></li>
			<li class="nav-item">
				<a class="nav-link" href="#" id="sidebarLogoutBtn">로그아웃</a>
			</li>
			<% } %>

			<!-- 다크모드 토글 버튼 -->
			<li class="nav-item mt-3">
				<button id="modeToggleSidebar"
				        class="btn btn-outline-light btn-sm ms-3"
				        style="border:1px solid white;">
					🌙
				</button>
			</li>
		</ul>
	</div>
</div>

<!-- 로그인 상태 관리 -->
<form id="sidebarLogoutForm" action="${pageContext.request.contextPath}/auth" method="post" style="display: none;">
    <input type="hidden" name="action" value="signout">
</form>

<script src="${pageContext.request.contextPath}/js/utils/authManager.js"></script>
<script>
    // 사이드바 로그아웃 버튼 클릭 이벤트
    document.addEventListener('DOMContentLoaded', function() {
        const sidebarLogoutBtn = document.getElementById('sidebarLogoutBtn');
        if (sidebarLogoutBtn) {
            sidebarLogoutBtn.addEventListener('click', function(e) {
                e.preventDefault();

                // sessionStorage 파기
                if (typeof AuthManager !== 'undefined') {
                    AuthManager.clearUser();
                }

                // 서버 로그아웃 (세션 무효화)
                document.getElementById('sidebarLogoutForm').submit();
            });
        }
    });
</script>
