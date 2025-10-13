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
        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5 bg-white">
            <div class="container py-4">
                <!-- 제목 -->
                <h1 class="h3 fw-bold text-primary mb-4">질문 등록</h1>

                <!-- 글쓰기 폼 -->
                <form action="/board/qna/savePost.jsp" method="post" class="border-0">
                    <!-- 질문 제목 입력 -->
                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold text-secondary">질문 제목</label>
                        <input
                                type="text"
                                id="title"
                                name="title"
                                class="form-control border-info shadow-sm"
                                style="background-color: #ffffff;"
                                placeholder="질문 제목을 입력하세요"
                                required
                        />
                    </div>

                    <!-- 질문 내용 입력 -->
                    <div class="mb-3">
                        <label for="content" class="form-label fw-semibold text-secondary">질문 내용</label>
                        <textarea
                                id="content"
                                name="content"
                                rows="8"
                                class="form-control border-info shadow-sm"
                                style="background-color: #ffffff;"
                                placeholder="질문 내용을 입력하세요"
                                required
                        ></textarea>
                    </div>

                    <!-- 버튼 영역 -->
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <!-- 취소 버튼 -->
                        <a
                                href="QnABoard.jsp"
                                class="btn btn-outline-secondary px-4 fw-semibold"
                        >
                            취소
                        </a>

                        <!-- 등록 버튼 -->
                        <button
                                type="submit"
                                class="btn text-white fw-semibold px-4"
                                style="background-color: #64A5E6;"
                        >
                            등록
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<!-- ===== JS ===== -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

</body>
</html>