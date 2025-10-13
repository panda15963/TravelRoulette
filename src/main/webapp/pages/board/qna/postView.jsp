<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 질의응답 게시판</title>
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
            <h1 class="h3 fw-bold text-primary mb-4">질의응답 게시판</h1>

            <!-- 질문 본문 -->
            <div class="card border-info shadow-sm mb-4">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-bold">게시글 등록이 안돼요 😢</span>
                    <small class="text-muted">작성일자: 2025-10-11</small>
                </div>
                <div class="card-body">
                    <p class="text-secondary mb-2">작성자: 이서연</p>
                    <hr>
                    <p class="mb-0">
                        게시글 등록을 시도하면 오류가 발생합니다.
                        작성 버튼을 눌러도 반응이 없어요.
                        혹시 서버 설정이 잘못된 걸까요?
                    </p>
                </div>
            </div>

            <!-- 관리자 답변 목록 -->
            <div class="mb-4">
                <div class="border rounded p-3 mb-2">
                    <strong>TripWiki 관리자</strong>
                    <p class="mb-1">
                        안녕하세요 😊 오류 확인 결과, DB 연결 설정에 누락된 항목이 있었습니다.
                        현재 수정 완료되었으며, 다시 시도해보시면 정상적으로 등록됩니다!
                    </p>
                    <small class="text-muted">2025-10-11 14:20</small>
                </div>

                <div class="border rounded p-3 mb-2">
                    <strong>홍길동</strong>
                    <p class="mb-1">
                        저도 같은 문제 겪었는데, 지금은 잘 됩니다! 감사합니다 🙌
                    </p>
                    <small class="text-muted">2025-10-11 15:00</small>
                </div>
            </div>

            <!-- 답변 입력 -->
            <form class="d-flex align-items-center mt-3">
                <label>
                    <input type="text" class="form-control border-info" placeholder="답변을 남겨주세요" />
                </label>
                <button type="submit" class="btn text-white ms-2" style="background-color: #64A5E6;">➤</button>
            </form>

            <!-- 뒤로가기 버튼 -->
            <div class="mt-4 text-end">
                <a href="QnABoard.jsp" class="btn btn-outline-secondary px-4 fw-semibold">뒤로가기</a>
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