<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- authUser는 navbar.jsp에서 이미 선언됨 - 여기서는 선언 제거 -->

<div class="offcanvas offcanvas-start" tabindex="-1" id="sidebarMenu">
    <!-- 로고 + 브랜드명 -->
    <a class="navbar-brand d-flex align-items-center mb-3 mt-2 ms-3"
       href="${pageContext.request.contextPath}/index.jsp">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="30" height="30"
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
                                    href="${pageContext.request.contextPath}/pages/map.jsp">지도</a></li>

            <% if (authUser == null) { %>
            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/signIn.jsp">로그인</a></li>
            <li class="nav-item"><a class="nav-link"
                                    href="${pageContext.request.contextPath}/pages/SignUp.jsp">회원가입</a></li>
            <% } else { %>
            <li class="nav-item"><a class="nav-link text-primary fw-bold"
                                    href="#"><%= authUser.getUserId() %>님</a></li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="event.preventDefault();
                document.getElementById('sidebarLogoutForm').submit();">로그아웃</a>
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

<form id="sidebarLogoutForm" action="${pageContext.request.contextPath}/auth" method="post" style="display: none;">
    <input type="hidden" name="action" value="signout">
</form>