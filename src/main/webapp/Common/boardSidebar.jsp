<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String currentPath = request.getRequestURI(); // 현재 페이지 경로 확인
%>

<!-- Sidebar -->
<nav id="sidebarMenu" class="col-12 col-md-3 col-lg-2 border-end p-3 min-vh-100">
    <h5 class="fw-bold text-primary mb-4">게시판</h5>

    <ul class="nav nav-pills flex-column">
        <!-- 전체 게시판 -->
        <li class="nav-item mb-2">
            <a href="${pageContext.request.contextPath}/pages/board/common/mainBoard.jsp"
               class="nav-link fw-semibold
               <%= currentPath.endsWith("mainBoard.jsp") ? "active bg-info fw-bold" : "" %>">
                전체게시판
            </a>
        </li>

        <li class="nav-item px-0 mb-2">
            <hr style="
                border: none;
                border-top: 2px solid #64A5E6;
                opacity: 1;
                margin: 0 -1rem;
            ">
        </li>

        <!-- 자유게시판 -->
        <li class="nav-item mb-2">
            <a href="${pageContext.request.contextPath}/pages/board/community/communityBoard.jsp"
               class="nav-link fw-semibold
               <%= currentPath.endsWith("communityBoard.jsp") ? "active bg-info fw-bold" : "" %>">
                자유게시판
            </a>
        </li>

        <!-- 질문답변게시판 -->
        <li class="nav-item mb-2">
            <a href="${pageContext.request.contextPath}/pages/board/qna/QnABoard.jsp"
               class="nav-link fw-semibold
               <%= currentPath.endsWith("QnABoard.jsp") ? "active bg-info fw-bold" : "" %>">
                질문답변게시판
            </a>
        </li>
    </ul>
</nav>