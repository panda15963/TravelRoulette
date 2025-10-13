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

<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <!-- ===== 오른쪽 본문 ===== -->
        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <!-- 상단 헤더 -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1">질의응답 게시판</h1>
                    <p class="text-muted mb-0">총 <strong>3</strong>개의 질문이 있습니다.</p>
                </div>
            </div>

            <!-- ✅ 검색 + 정렬 + 질문 등록 한 줄 배치 -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <!-- 왼쪽: 검색창 + 정렬 + 버튼 -->
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <label>
                        <input type="text" class="form-control border-info" placeholder="검색어를 입력하세요" style="width: 250px;" />
                    </label>
                    <label>
                        <select class="form-select border-info w-auto">
                            <option>정렬</option>
                            <option>최신순</option>
                            <option>오래된순</option>
                        </select>
                    </label>
                    <button class="btn btn-info text-white fw-semibold">검색</button>
                </div>

                <!-- 오른쪽: 질문 등록 버튼 -->
                <a href="writeForm.jsp" class="btn btn-info text-white fw-semibold shadow-sm">
                    질문 등록
                </a>
            </div>

            <!-- Q&A 게시글 목록 -->
            <div class="card border-info shadow-sm">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-semibold text-primary">질문 목록</span>
                    <small class="text-muted">궁금한 점을 물어보세요!</small>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-hover mb-0">
                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th class="w-10">번호</th>
                                <th>질문 제목</th>
                                <th class="w-25">작성자</th>
                                <th class="w-25">작성일</th>
                            </tr>
                            </thead>

                            <!-- ✅ 제목 클릭 시 postView.jsp로 이동 -->
                            <tbody class="text-center">
                            <tr>
                                <td>3</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        게시글 등록이 안돼요 😢
                                    </a>
                                </td>
                                <td>이서연</td>
                                <td>2025-10-11</td>
                            </tr>

                            <tr>
                                <td>2</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        댓글 기능은 언제 추가되나요?
                                    </a>
                                </td>
                                <td>박준형</td>
                                <td>2025-10-10</td>
                            </tr>

                            <tr>
                                <td>1</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
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
            </div> <!-- /card -->
        </main>
    </div>
</div>

<!-- ===== JS ===== -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

</body>
</html>