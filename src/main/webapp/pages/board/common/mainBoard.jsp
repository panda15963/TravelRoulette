<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.travelroulette.Dao.TotalBoardDAO" %>
<%@ page import="com.travelroulette.Dto.TotalBoard.TotalBoardPageDto" %>
<%@ page import="com.travelroulette.Dto.TotalBoard.TotalBoardDto" %>
<%@ page import="java.util.*" %>

<%
    int pageNumber = 1;
    if (request.getParameter("page") != null) {
        pageNumber = Integer.parseInt(request.getParameter("page"));
    }

    TotalBoardDAO dao = new TotalBoardDAO();
    TotalBoardPageDto pageDto = dao.findPagedPosts(pageNumber);

    request.setAttribute("boardList", pageDto.getPosts());
    request.setAttribute("currentPage", pageDto.getCurrentPage());
    request.setAttribute("startPage", pageDto.getStartPage());
    request.setAttribute("endPage", pageDto.getEndPage());
    request.setAttribute("hasPrev", pageDto.isHasPrev());
    request.setAttribute("hasNext", pageDto.isHasNext());
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
                                            <c:when test="${post.boardType eq '여행후기게시판'}">
                                                <span class="badge bg-success-subtle text-success">여행후기게시판</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info text-dark">자유게시판</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-start ps-3">
                                        <c:choose>
                                            <c:when test="${post.boardType eq '질의응답'}">
                                                <a href="../qna/postView.jsp?qnaNumber=${post.originalId}" class="text-decoration-none text-dark fw-semibold">
                                                        ${post.title}
                                                </a>
                                            </c:when>
                                            <c:when test="${post.boardType eq '여행후기'}">
                                                <a href="../review/postView.jsp?postNumber=${post.originalId}" class="text-decoration-none text-dark fw-semibold">
                                                        ${post.title}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <%-- 자유게시판 --%>
                                                <a href="../community/postView.jsp?postNumber=${post.originalId}" class="text-decoration-none text-dark fw-semibold">
                                                        ${post.title}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${post.userId}</td>
                                    <td>
                                        <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd" var="formattedDate" />
                                        <c:out value="${formattedDate}" />
                                    </td>
                                </tr>
                            </c:forEach>

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

            <!-- ✅ TripWiki 스타일 페이지네이션 -->
            <nav class="d-flex justify-content-center my-3 w-100 mb-0">
                <ul id="pagination"
                    class="pagination mb-0"
                    style="display:flex; justify-content:center; align-items:center; gap:0; margin-bottom:0;
             border-radius:10px; overflow:hidden;
             border:1px solid #d0d0d0; background-color:#f0f2f5;">
                    <!-- JS에서 버튼(li) 자동 생성 -->
                </ul>
            </nav>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>

<script>
    // ✅ 페이지네이션 JS 함수
    function renderPagination(opts) {
        const ul = document.getElementById('pagination');
        if (!ul) return;

        const c = Number(opts.currentPage) || 1;
        const t = Number(opts.totalPages) || 1;
        const s = Number(opts.startPage) || 1;
        const e = Number(opts.endPage) || t;

        const hasPrevBlock = opts.hasPrev;
        const hasNextBlock = opts.hasNext;

        // ✅ 버튼 생성 함수 (회색 배경 + 파란색 활성 + 구분선 수정)
        function li(label, page, disabled, active, isLast) {
            // 마지막(`»`)만 border-right 제거
            const borderStyle = isLast ? "" : "border-right:1px solid #d9d9d9;";
            const baseStyle =
                "background-color:#e9ecef; color:#0d6efd; border:none; margin:0; " +
                borderStyle +
                " border-radius:0; padding:8px 14px; transition:background-color 0.2s;";
            const activeStyle = active
                ? "background-color:#0d6efd; color:#fff; font-weight:600;"
                : "";
            const disabledStyle = disabled
                ? "color:#adb5bd; pointer-events:none;"
                : "";
            const hoverAttr = disabled
                ? ""
                : 'onmouseover="if(!this.parentElement.classList.contains(\'active\')) this.style.backgroundColor=\'#d8d8d8\'" ' +
                'onmouseout="if(!this.parentElement.classList.contains(\'active\')) this.style.backgroundColor=\'#e9ecef\'"';

            const cls =
                "page-item" + (disabled ? " disabled" : "") + (active ? " active" : "");
            return (
                '<li class="' +
                cls +
                '" style="list-style:none;">' +
                '<a class="page-link" href="#" data-page="' +
                page +
                '" ' +
                hoverAttr +
                ' style="' +
                baseStyle +
                activeStyle +
                disabledStyle +
                '">' +
                label +
                "</a></li>"
            );
        }

        let html = "";
        html += li("«", 1, c === 1, false, false);
        html += li("‹", hasPrevBlock ? s - 1 : c, !hasPrevBlock, false, false);

        for (let p = s; p <= e; p++) {
            html += li(String(p), p, false, p === c, false);
        }

        html += li("›", hasNextBlock ? e + 1 : c, !hasNextBlock, false, false);
        html += li("»", t, c === t, false, true); // ✅ 마지막만 border 제거

        ul.innerHTML = html;

        // ✅ 클릭 이벤트 처리
        const links = ul.querySelectorAll("a[data-page]");
        for (let link of links) {
            link.addEventListener("click", function (e) {
                e.preventDefault();
                if (this.parentElement.classList.contains("disabled")) return;
                const next = Number(this.getAttribute("data-page"));
                if (!next || next === c) return;
                location.href = "?page=" + next;
            });
        }
    }

    // ✅ 서버에서 받은 값으로 JS 페이지네이션 렌더링
    document.addEventListener('DOMContentLoaded', () => {
        renderPagination({
            currentPage: ${currentPage},
            totalPages: ${endPage},
            startPage: ${startPage},
            endPage: ${endPage},
            hasPrev: ${hasPrev},
            hasNext: ${hasNext}
        });
    });
</script>
</body>
</html>