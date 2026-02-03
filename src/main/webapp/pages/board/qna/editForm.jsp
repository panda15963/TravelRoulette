<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 질의응답 수정</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="../../../assets/favicon.ico?v=2" />
    <link href="../../../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5 bg-white">
            <div class="container py-4">
                <h1 class="h3 fw-bold text-primary mb-4">질의응답 게시글 수정</h1>

                <form id="edit-form" class="border-0">

                    <input type="hidden" id="qnaNumber" name="qnaNumber">

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
    window.onload = function() {
        console.log('📍 window.location.href:', window.location.href);
        console.log('📍 window.location.search:', window.location.search);

        const urlParams = new URLSearchParams(window.location.search);
        const qnaNumber = urlParams.get('qnaNumber');

        console.log('📍 Extracted qnaNumber:', qnaNumber);
        console.log('📍 qnaNumber type:', typeof qnaNumber);
        console.log('📍 qnaNumber is null?', qnaNumber === null);
        console.log('📍 qnaNumber is empty string?', qnaNumber === '');

        if (!qnaNumber) {
            alert('잘못된 접근입니다. 게시글 번호가 없습니다.');
            history.back();
            return;
        }

        console.log('Loading post data for qnaNumber:', qnaNumber);

        const fetchUrl = '/TravelRoulette/Board/qna/detail.do?qnaNumber=' + qnaNumber;
        console.log('📍 Fetch URL:', fetchUrl);

        fetch(fetchUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Received data:', data);
                if (data && data.post) {
                    const post = data.post;
                    document.getElementById('qnaNumber').value = post.qnaNumber;
                    document.getElementById('title').value = post.qnaTitle;
                    document.getElementById('content').value = post.qnaDescription;
                } else {
                    alert('게시글을 찾을 수 없습니다.');
                    history.back();
                }
            })
            .catch(error => {
                console.error('Error loading post:', error);
                alert('게시글을 불러오는 중 오류가 발생했습니다.');
                history.back();
            });
    };

    document.getElementById('edit-form').addEventListener('submit', function(event) {
        event.preventDefault();

        const qnaNumber = document.getElementById('qnaNumber').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;

        if (!qnaNumber) {
            alert('게시글 번호가 없습니다.');
            return;
        }

        if (!title.trim() || !content.trim()) {
            alert('제목과 내용을 입력해주세요.');
            return;
        }

        console.log('Updating post:', { qnaNumber, title, content });

        const formData = new FormData();
        formData.append('qnaNumber', qnaNumber);
        formData.append('title', title);
        formData.append('content', content);

        fetch('/TravelRoulette/Board/qna/update.do', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Update response:', data);
                if (data.status === 'success') {
                    alert('게시글이 성공적으로 수정되었습니다.');
                    location.href = 'postView.jsp?qnaNumber=' + qnaNumber;
                } else {
                    alert('수정 실패: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('Error updating post:', error);
                alert('수정 중 오류가 발생했습니다. 콘솔을 확인해주세요.');
            });
    });
</script>

</body>
</html>
