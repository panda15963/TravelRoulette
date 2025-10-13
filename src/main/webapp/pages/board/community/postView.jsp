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

<%@ include file="/Common/navbar.jsp" %>

<!-- ===== 메인 콘텐츠 (사이드바 + 본문) ===== -->
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <!-- ===== 오른쪽 본문 ===== -->
        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <!-- 페이지 제목 -->
            <h1 class="h3 fw-bold text-primary mb-4">자유게시판</h1>

            <!-- 게시글 본문 -->
            <div class="card border-info shadow-sm mb-4">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span id="post-title" class="fw-bold">Lorem Ipsum</span>
                    <small id="post-date" class="text-muted">작성일자: 2025-10-11</small>
                </div>
                <div class="card-body">
                    <p id="post-author" class="text-secondary mb-2">작성자: 홍길동</p>
                    <hr>
                    <p id="post-content" class="mb-0">
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

<%--            <!-- 뒤로가기 버튼 -->--%>
<%--            <div class="mt-4 text-end">--%>
<%--                <a href="communityBoard.jsp" class="btn btn-outline-secondary px-4 fw-semibold">뒤로가기</a>--%>
<%--            </div>--%>

            <!-- 수정, 삭제, 글 목록 버튼 -->
            <div class="mt-4 d-flex justify-content-end gap-2">
                <a href="#" id="edit-button" class="btn btn-outline-primary px-4 fw-semibold">수정</a>
                <a href="#" id="delete-button" class="btn btn-outline-danger px-4 fw-semibold">삭제</a>
                <a href="communityBoard.jsp" class="btn btn-outline-secondary px-4 fw-semibold">글 목록</a>
            </div>


        </main>
    </div> <!-- /row -->
</div> <!-- /container-fluid -->

<!-- ===== JS ===== -->
<script defer src="../../../js/utils/board.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

<script>
    // 페이지가 모두 로드된 후 실행
    window.onload = function() {
        // 1. URL 주소에서 "postNumber=5" 같은 파라미터 값을 가져옵니다.
        const urlParams = new URLSearchParams(window.location.search);
        const postNumber = urlParams.get('postNumber');

        // postNumber가 유효한 경우에만 서버에 데이터를 요청
        if (postNumber) {
            // 2. fetch를 이용해 서버에 게시글 상세 데이터를 비동기적으로 요청
            fetch(`/TravelRoulette_war/board/community/detail.do?postNumber=\${postNumber}`)
                .then(response => response.json()) // 응답을 JSON으로 변환
                .then(post => {
                    // 3. 받아온 JSON 데이터로 HTML 요소의 내용을 채웁니다.
                    console.log("서버로부터 받은 상세 데이터:", post);

                    document.getElementById('post-title').innerText = post.postTitle;
                    document.getElementById('post-date').innerText = '작성일: ' + post.postDateWritten;
                    document.getElementById('post-author').innerText = '작성자: ' + post.userId;
                    document.getElementById('post-content').innerText = post.postDescription;

                    document.getElementById('edit-button').href = `editForm.jsp?postNumber=\${post.postNumber}`;
                })
                .catch(error => {
                    console.error('게시글 상세 정보 로딩 중 오류 발생:', error);
                    document.getElementById('post-content').innerText = '게시글을 불러오는 데 실패했습니다.';
                });
        }
    };
</script>

</body>
</html>