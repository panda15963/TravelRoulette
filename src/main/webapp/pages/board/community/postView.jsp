<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="../../../assets/favicon.ico?v=2" />
    <link href="../../../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">

<%@ include file="/common/navbar.jsp" %>

<!-- ===== 메인 콘텐츠 (사이드바 + 본문) ===== -->
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/common/boardSidebar.jsp" %>

        <!-- ===== 오른쪽 본문 ===== -->
        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <!-- 페이지 제목 -->
            <h1 class="h3 fw-bold text-primary mb-4">자유게시판</h1>

            <!-- 게시글 본문 -->
            <div class="card border-info shadow-sm mb-4">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-bold">Lorem Ipsum</span>
                    <small class="text-muted">작성일자: 2025-10-11</small>
                </div>
                <div class="card-body">
                    <p class="text-secondary mb-2">작성자: 홍길동</p>
                    <hr>
                    <p class="mb-0">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                        Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                    </p>
                </div>
            </div>

            <!-- 댓글 목록 -->
            <div class="mb-4">
                <div class="border rounded p-3 mb-2">
                    <strong>이민호</strong>
                    <p class="mb-1">좋은 글이에요!</p>
                    <small class="text-muted">2025-10-11 14:00</small>
                </div>
                <div class="border rounded p-3 mb-2">
                    <strong>김하늘</strong>
                    <p class="mb-1">저도 가보고 싶네요 ✈️</p>
                    <small class="text-muted">2025-10-11 13:45</small>
                </div>
            </div>

            <!-- 댓글 입력 -->
            <form class="d-flex align-items-center mt-3">
                <label>
                    <input type="text" class="form-control border-info" placeholder="댓글을 남겨주세요" />
                </label>
                <button type="submit" class="btn text-white ms-2" style="background-color: #64A5E6;">➤</button>
            </form>

            <!-- 뒤로가기 버튼 -->
            <div class="mt-4 text-end">
                <a href="communityBoard.jsp" class="btn btn-outline-secondary px-4 fw-semibold">뒤로가기</a>
            </div>
        </main>
    </div> <!-- /row -->
</div> <!-- /container-fluid -->

<!-- ===== JS ===== -->
<script defer src="../../../js/utils/board.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

</body>
</html>