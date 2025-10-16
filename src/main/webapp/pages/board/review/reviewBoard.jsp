<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 여행후기 게시판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="../../../assets/favicon.ico?v=2" />
    <link href="../../../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        .table-fixed { table-layout: fixed; width: 100%; }
        .col-num   { width: 80px; min-width: 70px; }
        .col-title { width: auto; }
        .col-author, .col-date { width: 25%; }

        thead th:first-child, tbody td:first-child {
            font-variant-numeric: tabular-nums;
        }

        tbody td:nth-child(2) {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>

<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

<!-- ===== 메인 콘텐츠 (사이드바 + 본문) ===== -->
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <!-- ===== 오른쪽 본문 ===== -->
        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <!-- 상단 헤더 영역 -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1">여행후기 게시판</h1>
                    <p class="text-muted mb-0">총 <strong>3</strong>개의 후기</p>
                </div>
            </div>

            <!-- ✅ 검색 + 정렬 + 글쓰기 -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <label>
                        <input id="searchInput" type="text" class="form-control border-info" placeholder="후기를 검색하세요" style="width: 250px;" />
                    </label>
                    <label>
                        <select id="sortSelect" class="form-select border-info w-auto">
                            <option value="desc">최신순</option>
                            <option value="asc">오래된순</option>
                        </select>
                    </label>
                    <button class="btn btn-info text-white fw-semibold">검색</button>
                </div>

                <!-- 오른쪽: 글쓰기 버튼 -->
                <a href="writeForm.jsp" class="btn btn-info text-white fw-semibold shadow-sm">
                    후기 작성
                </a>
            </div>

            <!-- 게시판 목록 -->
            <div class="card border-info shadow-sm">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-semibold text-primary">여행후기 목록</span>
                    <small class="text-muted">당신의 여행 이야기를 공유해보세요!</small>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-hover mb-0 table-fixed">
                            <colgroup>
                                <col class="col-num">
                                <col class="col-title">
                                <col class="col-author">
                                <col class="col-date">
                            </colgroup>

                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                            </tr>
                            </thead>

                            <tbody id="post-list-body" class="text-center">
                            <tr>
                                <td>3</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        제주도 일주 여행기 🌴
                                    </a>
                                </td>
                                <td>홍길동</td>
                                <td>2025-10-11</td>
                            </tr>

                            <tr>
                                <td>2</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        일본 오사카 맛집 탐방기 🍜
                                    </a>
                                </td>
                                <td>김민수</td>
                                <td>2025-10-10</td>
                            </tr>

                            <tr>
                                <td>1</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        유럽 배낭여행 후기 ✈️
                                    </a>
                                </td>
                                <td>이영희</td>
                                <td>2025-10-09</td>
                            </tr>
                            </tbody>
                        </table>

                        <!-- 페이지네이션 -->
                        <nav class="d-flex justify-content-center my-3">
                            <ul id="pagination" class="pagination mb-0"></ul>
                        </nav>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- ===== JS ===== -->
<script defer src="../../../js/utils/board.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

<!-- 기존 JS 로직 그대로 유지 -->
<script>
    // (loadList, renderTable, renderPagination 등 기존 코드 유지)
</script>
</body>
</html>