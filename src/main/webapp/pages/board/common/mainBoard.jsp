<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<!-- ===== 메인 콘텐츠 (사이드바 + 본문) ===== -->
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <!-- 상단 헤더 -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1">전체 게시판</h1>
                    <p class="text-muted mb-0">자유게시판과 질의응답 게시판의 모든 글을 한눈에 확인하세요.</p>
                </div>
            </div>

            <!-- 검색 영역 -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <input type="text" class="form-control border-info" placeholder="검색어를 입력하세요" style="width: 250px;" />
                    <select class="form-select border-info w-auto">
                        <option>분류</option>
                        <option>자유게시판</option>
                        <option>질의응답</option>
                    </select>
                    <select class="form-select border-info w-auto">
                        <option>정렬</option>
                        <option>최신순</option>
                        <option>오래된순</option>
                    </select>
                    <button class="btn btn-info text-white fw-semibold">검색</button>
                </div>
            </div>

            <!-- 게시판 목록 -->
            <div class="card border-info shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span class="fw-semibold text-primary">게시글 목록</span>
                    <small class="text-muted">전체 게시글을 한눈에 확인하세요!</small>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-hover mb-0">
                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th class="w-10">번호</th>
                                <th class="w-20">분류</th>
                                <th>제목</th>
                                <th class="w-20">작성자</th>
                                <th class="w-20">작성일</th>
                            </tr>
                            </thead>
                            <tbody class="text-center">

                            <!-- 자유게시판 -->
                            <tr>
                                <td>6</td>
                                <td><span class="badge bg-info text-dark">자유게시판</span></td>
                                <td>
                                    <a href="../community/postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        Bootstrap으로 게시판 완성!
                                    </a>
                                </td>
                                <td>홍길동</td>
                                <td>2025-10-11</td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td><span class="badge bg-info text-dark">자유게시판</span></td>
                                <td>
                                    <a href="../community/postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        여행지 추천해주세요 ✈️
                                    </a>
                                </td>
                                <td>이민호</td>
                                <td>2025-10-10</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td><span class="badge bg-info text-dark">자유게시판</span></td>
                                <td>
                                    <a href="../community/postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        첫 글 올려봅니다!
                                    </a>
                                </td>
                                <td>김하늘</td>
                                <td>2025-10-09</td>
                            </tr>

                            <!-- 질의응답 -->
                            <tr>
                                <td>3</td>
                                <td><span class="badge bg-primary-subtle text-primary">질의응답</span></td>
                                <td>
                                    <a href="../qna/postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        게시글 등록이 안돼요 😢
                                    </a>
                                </td>
                                <td>이서연</td>
                                <td>2025-10-11</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><span class="badge bg-primary-subtle text-primary">질의응답</span></td>
                                <td>
                                    <a href="../qna/postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        댓글 기능은 언제 추가되나요?
                                    </a>
                                </td>
                                <td>박준형</td>
                                <td>2025-10-10</td>
                            </tr>
                            <tr>
                                <td>1</td>
                                <td><span class="badge bg-primary-subtle text-primary">질의응답</span></td>
                                <td>
                                    <a href="../qna/postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        파일 첨부는 어떤 형식이 되나요?
                                    </a>
                                </td>
                                <td>정민호</td>
                                <td>2025-10-09</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- ===== JS ===== -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>
<script src="../../../js/utils/authManager.js"></script>
<script src="../../../js/utils/navbarUI.js"></script>
<script>
    // 게시판 페이지는 로그인 필수
    document.addEventListener('DOMContentLoaded', function() {
        AuthManager.requireLogin();
    });
</script>
</body>
</html>