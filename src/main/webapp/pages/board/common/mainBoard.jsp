<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.travelroulette.Dao.TotalBoardDAO" %>
<%@ page import="com.travelroulette.Dto.TotalBoard.TotalBoardDto" %>
<%@ page import="java.util.List" %>

<%
    // ✅ JSP에서 DAO 직접 호출 — Controller 없이도 작동
    TotalBoardDAO dao = new TotalBoardDAO();
    List<TotalBoardDto> boardList = dao.findAll();
    request.setAttribute("boardList", boardList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 전체 게시판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="../../../assets/favicon.ico?v=2" />
    <link href="../../../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1">전체 게시판</h1>
                    <p class="text-muted mb-0">자유게시판과 질의응답 게시판의 모든 글을 한눈에 확인하세요.</p>
                </div>
            </div>

            <div class="card border-info shadow-sm">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-semibold text-primary">게시글 목록</span>
                    <small class="text-muted">전체 게시글을 한눈에 확인하세요!</small>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-hover mb-0">
                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th>번호</th>
                                <th>분류</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                            </tr>
                            </thead>

                            <tbody class="text-center">
                            <c:forEach var="post" items="${boardList}">
                                <tr>
                                    <td>${post.id}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${post.boardType eq '질의응답'}">
                                                <span class="badge bg-primary-subtle text-primary">질의응답</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info text-dark">자유게시판</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-start ps-3">
                                        <a href="../community/postView.jsp"
                                           class="text-decoration-none text-dark fw-semibold">
                                                ${post.title}
                                        </a>
                                    </td>
                                    <td>${post.userId}</td>
                                    <td>
                                        <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd" var="formattedDate" />
                                        <c:out value="${formattedDate}" />
                                    </td>
                                </tr>
                            </c:forEach>

                            <!-- ✅ 게시글이 없을 경우 -->
                            <c:if test="${empty boardList}">
                                <tr>
                                    <td colspan="5" class="text-muted py-4">등록된 게시글이 없습니다.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
</body>
</html>