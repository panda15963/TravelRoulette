<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 자유게시판</title>
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

            <!-- 상단 헤더 영역 -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1">자유 게시판</h1>
                    <p class="text-muted mb-0">총 <strong>3</strong>개의 글</p>
                </div>
            </div>

            <!-- ✅ 검색 + 정렬 + 글쓰기 한 줄 배치 -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <!-- 왼쪽: 검색창 + 정렬 -->
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

                <!-- 오른쪽: 글쓰기 버튼 -->
                <a href="writeForm.jsp" class="btn btn-info text-white fw-semibold shadow-sm">
                    글쓰기
                </a>
            </div>

            <!-- 게시판 목록 -->
            <div class="card border-info shadow-sm">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-semibold text-primary">게시글 목록</span>
                    <small class="text-muted">자유롭게 의견을 나눠보세요!</small>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle table-hover mb-0">
                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th class="w-10">번호</th>
                                <th>제목</th>
                                <th class="w-25">작성자</th>
                                <th class="w-25">작성일</th>
                            </tr>
                            </thead>

                            <!-- ✅ tbody: 제목 클릭 시 상세 페이지로 이동 -->
                            <tbody id="post-list-body" class="text-center">
                            <tr>
                                <td>3</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        Bootstrap 클래스만으로 디자인!
                                    </a>
                                </td>
                                <td>홍길동</td>
                                <td>2025-10-11</td>
                            </tr>

                            <tr>
                                <td>2</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        Travel Roulette 색상 없이도 예쁘네요
                                    </a>
                                </td>
                                <td>김민수</td>
                                <td>2025-10-10</td>
                            </tr>

                            <tr>
                                <td>1</td>
                                <td>
                                    <a href="postView.jsp" class="text-decoration-none text-dark fw-semibold">
                                        순수 Bootstrap 버전 테스트
                                    </a>
                                </td>
                                <td>이영희</td>
                                <td>2025-10-09</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> <!-- /card -->
        </main>
    </div> <!-- /row -->
</div> <!-- /container-fluid -->

<!-- ===== JS ===== -->
<script defer src="../../../js/utils/board.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

<script>
    //웹페이지가 모두 로드된 이후 실행
    window.onload = function() {
        //게시글 목록 데이터를 요청(fetch로 비동기 통신)
        fetch('/TravelRoulette_war/board/community/list.do')
            .then(response => {
                //JSON 데이터만 추출
                return response.json();
            })
            .then(data => {
                //화면 그리기
                console.log("서버로부터 받은 데이터:", data); //F12 확인용

                const tbody = document.getElementById('post-list-body');
                tbody.innerHTML = '';

                let html = ''; //테이블에 추가할 HTML 코드

                //게시글 배열을 순회
                data.forEach(post => {
                    html += '<tr>' +
                        '<td>' + post.postNumber + '</td>' +
                        '<td class="text-center"><a href="postView.jsp?postNumber=' + post.postNumber + '" class="text-decoration-none text-dark">' + post.postTitle + '</a></td>' +
                        '<td>' + post.userId + '</td>' +
                        '<td>' + post.postDateWritten + '</td>' +
                        '</tr>';
                });

                //tbody에 삽입
                tbody.innerHTML = html;
            })
            .catch(error => {
                console.error('게시글 목록 로딩 중 오류 발생:', error);
                const tbody = document.getElementById('post-list-body');
                tbody.innerHTML = '<tr><td colspan="5">게시글을 불러오는 데 실패했습니다.</td></tr>';
            });
    };
</script>

</body>
</html>