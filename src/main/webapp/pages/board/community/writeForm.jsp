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
<%@ include file="/Common/sidebar.jsp" %>
<!-- ===== 메인 콘텐츠 (사이드바 + 본문) ===== -->
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <!-- ===== 오른쪽 본문 ===== -->
        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5 bg-white">
            <div class="container py-4">
                <!-- 제목 -->
                <h1 class="h3 fw-bold text-primary mb-4">자유게시판</h1>

                <!-- 글쓰기 폼 -->
                <!--
                <form action="/Board/Community/savePost.jsp" method="post" class="border-0">
                -->
                <form id="write-form" class="border-0">

                    <!-- 제목 입력 -->
                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold text-secondary">제목</label>
                        <input
                                type="text"
                                id="title"
                                name="title"
                                class="form-control border-info shadow-sm"
                                style="background-color: #ffffff;"
                                placeholder="제목을 입력하세요"
                                required
                        />
                    </div>

                    <!-- 내용 입력 -->
                    <div class="mb-3">
                        <label for="content" class="form-label fw-semibold text-secondary">내용</label>
                        <textarea
                                id="content"
                                name="content"
                                rows="8"
                                class="form-control border-info shadow-sm"
                                style="background-color: #ffffff;"
                                placeholder="내용을 입력하세요"
                                required
                        ></textarea>
                    </div>

                    <!-- 버튼 영역 -->
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <!-- 취소 버튼 -->
                        <a
                                href="communityBoard.jsp"
                                class="btn btn-outline-secondary px-4 fw-semibold"
                        >
                            취소
                        </a>

                        <!-- 등록 버튼 -->
                        <!--
                        <button
                                type="submit"
                                class="btn text-white fw-semibold px-4"
                                style="background-color: #64A5E6;"
                        >
                            등록
                        </button>
                        -->

                        <button type="button"
                                id="submit-button"
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
<script defer src="../../../js/utils/board.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

<script>
    //등록 버튼을 클릭 시 실행될 코드 연결
    document.getElementById('submit-button').addEventListener('click', function() {
        //입력값 가져오기
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;

        if (!title || !content) {
            alert('제목과 내용을 모두 입력해주세요.');
            return; // 함수를 여기서 중단합니다.
        }

        const formData = new FormData();
        formData.append('title', title);
        formData.append('content', content);


        //비동기
        //fetch('/TravelRoulette/Board/Community/write.do', {
        fetch('${pageContext.request.contextPath}/Board/Community/write.do', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    alert('글이 성공적으로 등록되었습니다.');
                    location.href = 'communityBoard.jsp';
                } else {
                    //등록 실패
                    alert('오류 발생: ' + data.message);
                }
            })
            .catch(error => {
                //네트워크 오류 등 문제가 발생하면 실행
                console.error('Error:', error);
                alert('글 등록 중 오류가 발생했습니다.');
            });
    });
</script>


</body>
</html>