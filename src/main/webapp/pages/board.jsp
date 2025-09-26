<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Board</title>
    <link href="../css/styles.css" rel="stylesheet" />
    <!-- Bootstrap CSS (필요하다면 추가) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- SEO/반응형 기본 -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />


</head>
<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<!-- 여기에 Board 관련 내용 작성 -->

<!-- 메인 컨테이너 & 상단 헤더 -->
<main class="wrap container pt-5 mt-4 mt-lg-5">
    <!-- 페이지 타이틀 -->
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 m-0">여행 후기 게시판</h1>
            <p class="text-muted m-0">총 <strong id="count">0</strong>개의 글</p>
        </div>
        <div>
            <button id="writeBtn" type="button" class="btn btn-primary btn-sm">글 쓰기</button>

        </div>
    </div>

    <!-- 검색/정렬 툴바 -->
    <section class="toolbar d-flex flex-wrap gap-2 align-items-center mb-3" aria-label="검색 및 정렬" id="toolbar">
        <div class="flex-grow-1" style="min-width: 260px;">
            <label for="q" class="form-label mb-1">검색</label>
            <div class="d-flex gap-2">
                <input id="q" type="search" class="form-control" placeholder="제목·작성자·내용" />
                <button id="clear" type="button" class="btn btn-outline-secondary">🧹</button>
            </div>
        </div>
        <div style="min-width: 200px;">
            <label for="sort" class="form-label mb-1">정렬</label>
            <select id="sort" class="form-select">
                <option value="new">최신순</option>
                <option value="old">오래된순</option>
                <option value="title">제목순</option>
                <option value="author">작성자순</option>
            </select>
        </div>
    </section>

    <!-- 목록 -->
    <section class="card">
        <header class="card-header d-flex justify-content-between align-items-center">
            <span class="fw-semibold">게시글 목록</span>
            <small class="text-muted">여행 후기를 적어주세요!</small>
        </header>

        <div class="card-body p-0">
            <div class="table-responsive">

                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 80px;">No</th>
                        <th>제목</th>
                        <th style="width: 160px;">작성자</th>
                        <th style="width: 180px;">작성일</th>
                        <th style="width: 160px;"></th>
                    </tr>
                    </thead>
                    <tbody id="rows">
                    <!-- js에서 렌더링 -->
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- 보기 모달 -->
    <dialog id="viewDialog" class="p-0" style="border:0; border-radius:.75rem; max-width: 720px; width: calc(100% - 2rem);">
        <div class="card mb-0">
            <div class="card-header d-flex justify-content-between align-items-center">
                <strong>글 보기</strong>
                <form method="dialog">
                    <button class="btn btn-sm btn-outline-secondary">닫기</button>
                </form>
            </div>
            <div class="card-body">
                <div id="viewMount" class="vstack gap-2"><!-- JS가 내용 주입 --></div>
            </div>
        </div>
    </dialog>

    <!-- 글쓰기 모달  -->
    <dialog id="writeDialog" class="p-0" style="border:0; border-radius:.75rem; max-width: 720px; width: calc(100% - 2rem);">
        <div class="card mb-0">
            <div class="card-header d-flex justify-content-between align-items-center">
                <strong>새 글 작성</strong>
                <form method="dialog">
                    <button class="btn btn-sm btn-outline-secondary" id="cancelBtn">닫기</button>
                </form>
            </div>
            <div class="card-body">
                <div id="writeMount">
                    <!-- js에서 postForm.html을 fetch하여 삽입했삼 -->
                </div>
            </div>
        </div>
    </dialog>

    <!-- [추가] 토스트: 하단 중앙 고정 -->
    <div id="toast" class="position-fixed bottom-0 start-50 translate-middle-x mb-4 px-3 py-2 bg-dark text-white rounded-3 shadow"
         role="status" aria-live="polite" hidden>
        처리되었습니다.
    </div>
</main>

<!-- JS 연결 -->
<script defer src="../js/board.js"></script>

<!-- Bootstrap JS (필요하다면 추가) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script> -->
<!--<script src="${pageContext.request.contextPath}/js/board.js" defer></script>-->

<script src="../js/darkmode.js"></script>
</body>
</html>