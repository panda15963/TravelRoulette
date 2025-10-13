<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 글 수정</title>
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

        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5 bg-white">
            <div class="container py-4">
                <h1 class="h3 fw-bold text-primary mb-4">자유게시판 글 수정</h1>

                <form id="edit-form" class="border-0">

                    <input type="hidden" id="postNumber" name="postNumber">

                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold text-secondary">제목</label>
                        <input type="text" id="title" name="title" class="form-control border-info shadow-sm" required />
                    </div>

                    <div class="mb-3">
                        <label for="content" class="form-label fw-semibold text-secondary">내용</label>
                        <textarea id="content" name="content" rows="8" class="form-control border-info shadow-sm" required></textarea>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="#" onclick="history.back(); return false;" class="btn btn-outline-secondary px-4 fw-semibold">취소</a>

                        <button type="submit" id="submit-button" class="btn text-white fw-semibold px-4" style="background-color: #64A5E6;">수정 완료</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

<script>
    //페이지 로딩 시 기존 글 데이터를 불러오기
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const postNumber = urlParams.get('postNumber');

        if (postNumber) {
            //상세보기에서 사용했던 detail.do 재활용
            fetch(`/TravelRoulette_war/board/community/detail.do?postNumber=\${postNumber}`)
                .then(response => response.json())
                .then(post => {
                    if (post) {
                        document.getElementById('postNumber').value = post.postNumber;
                        document.getElementById('title').value = post.postTitle;
                        document.getElementById('content').value = post.postDescription;
                    }
                });
        }
    };

    //수정 완료 버튼 클릭 시 데이터를 서버로 보내기
    document.getElementById('edit-form').addEventListener('submit', function(event) {
        event.preventDefault(); //새로고침 방지

        const postNumber = document.getElementById('postNumber').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;

        const formData = new FormData();
        formData.append('postNumber', postNumber);
        formData.append('title', title);
        formData.append('content', content);

        fetch('/TravelRoulette_war/board/community/update.do', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    alert('글이 성공적으로 수정되었습니다.');
                    //수정된 글로 다시 돌아감
                    location.href = `postView.jsp?postNumber=\${postNumber}`;
                } else {
                    alert('글 수정 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('글 수정 중 오류가 발생했습니다.');
            });
    });
</script>

</body>
</html>