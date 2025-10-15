<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 질의응답 상세보기</title>
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

        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <h1 class="h3 fw-bold text-primary mb-4">질의응답 게시판</h1>

            <div class="card border-info shadow-sm mb-4">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span id="post-title" class="fw-bold">게시글 제목</span>
                    <small id="post-date" class="text-muted">작성일자: </small>
                </div>
                <div class="card-body">
                    <p id="post-author" class="text-secondary mb-2">작성자: </p>
                    <hr>
                    <p id="post-content" class="mb-0"></p>
                </div>
            </div>

            <div class="mb-4">
                <h5 class="mb-3">답글</h5>
                <div id="answer-container">
                </div>
            </div>

            <form id="answer-form" class="d-flex align-items-start mt-3" style="display: none;">
                <div class="flex-grow-1">
                    <input type="text" id="answer-title-input" class="form-control border-info mb-2" placeholder="답글 제목을 입력하세요" required>
                    <textarea id="answer-content-input" class="form-control border-info" rows="3" placeholder="답글 내용을 입력하세요" required></textarea>
                </div>
                <button type="submit" class="btn text-white ms-2" style="background-color: #64A5E6;">등록</button>
            </form>

            <div class="mt-4 d-flex justify-content-end gap-2">
                <a href="#" id="edit-button" class="btn btn-outline-primary px-4 fw-semibold" style="display: none;">수정</a>
                <a href="#" id="delete-button" class="btn btn-outline-danger px-4 fw-semibold" style="display: none;">삭제</a>
                <a href="QnABoard.jsp" class="btn btn-outline-secondary px-4 fw-semibold">글 목록</a>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>
<script src="../../../js/utils/authManager.js"></script>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    const qnaNumber = urlParams.get('qnaNumber');

    window.onload = function() {
        if (qnaNumber) {
            fetch(`/TravelRoulette/board/qna/detail.do?qnaNumber=\${qnaNumber}`)
                .then(response => response.json())
                .then(data => {
                    console.log("서버로부터 받은 상세 데이터:", data);

                    const post = data.post;
                    const answer = data.answer;

                    document.getElementById('post-title').innerText = post.qnaTitle;
                    document.getElementById('post-date').innerText = '작성일: ' + post.qnaDateWritten;
                    document.getElementById('post-author').innerText = '작성자: ' + post.userId;
                    document.getElementById('post-content').innerText = post.qnaDescription;

                    document.getElementById('edit-button').href = `editForm.jsp?qnaNumber=\${post.qnaNumber}`;

                    const currentUserId = AuthManager.getUserId();
                    const postAuthorId = post.userId;

                    console.log('현재 로그인 ID:', currentUserId, '/ 게시글 작성자 ID:', postAuthorId);

                    if (currentUserId && currentUserId === postAuthorId) {
                        document.getElementById('edit-button').style.display = 'inline-block';
                        document.getElementById('delete-button').style.display = 'inline-block';
                    }

                    const answerContainer = document.getElementById('answer-container');
                    const answerForm = document.getElementById('answer-form');

                    // 답글(depth=1) 페이지인 경우 답글 작성 폼 완전히 숨김
                    if (post.qnaDepth === 1) {
                        if (answerForm) {
                            answerForm.style.display = 'none';
                        }
                    }

                    if (answer) {
                        let answerHtml = '<div class="border rounded p-3 mb-2">' +
                            '<strong>' + answer.userId + '</strong>' +
                            '<h6 class="mt-2" id="answer-title-display">' + answer.qnaTitle + '</h6>' +
                            '<p class="mb-1" id="answer-content-display">' + answer.qnaDescription + '</p>' +
                            '<small class="text-muted">' + answer.qnaDateWritten + '</small>';

                        if (currentUserId && currentUserId === answer.userId) {
                            answerHtml += '<div class="mt-2" id="answer-action-buttons">' +
                                '<a href="#" class="btn btn-sm btn-link text-decoration-none text-muted" id="answer-edit-btn" data-answer-id="' + answer.qnaNumber + '" data-answer-title="' + answer.qnaTitle + '" data-answer-content="' + answer.qnaDescription + '">수정</a>' +
                                '<a href="#" class="btn btn-sm btn-link text-decoration-none text-muted" id="answer-delete-btn" data-answer-id="' + answer.qnaNumber + '">삭제</a>' +
                                '</div>';
                        }

                        answerHtml += '</div>';
                        answerContainer.innerHTML = answerHtml;

                        // 답글이 이미 있으면 답글 작성 폼 완전히 숨김
                        if (answerForm) {
                            answerForm.style.display = 'none';
                            answerForm.style.visibility = 'hidden';
                            answerForm.setAttribute('hidden', 'hidden');
                        }
                    } else {
                        answerContainer.innerHTML = '<p class="text-muted">아직 답글이 없습니다.</p>';

                        // 원글(depth=0)이고 답글이 없고 로그인한 경우에만 답글 작성 폼 표시
                        if (currentUserId && post.qnaDepth === 0) {
                            if (answerForm) {
                                answerForm.style.display = 'flex';
                                answerForm.style.visibility = 'visible';
                                answerForm.removeAttribute('hidden');
                            }
                        } else {
                            if (answerForm) {
                                answerForm.style.display = 'none';
                                answerForm.style.visibility = 'hidden';
                                answerForm.setAttribute('hidden', 'hidden');
                            }
                        }
                    }
                })
                .catch(error => {
                    console.error('게시글 상세 정보 로딩 중 오류 발생:', error);
                    document.getElementById('post-content').innerText = '게시글을 불러오는 데 실패했습니다.';
                });
        }
    };

    document.getElementById('delete-button').addEventListener('click', function(event) {
        event.preventDefault();

        if (confirm('정말 삭제하시겠습니까?')) {
            const formData = new FormData();
            formData.append('qnaNumber', qnaNumber);

            fetch('/TravelRoulette/board/qna/delete.do', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert('게시글이 성공적으로 삭제되었습니다.');
                        location.href = 'QnABoard.jsp';
                    } else {
                        alert('게시글 삭제에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('게시글 삭제 중 오류가 발생했습니다.');
                });
        }
    });

    document.getElementById('answer-form').addEventListener('submit', function(event) {
        event.preventDefault();

        const titleInput = document.getElementById('answer-title-input');
        const contentInput = document.getElementById('answer-content-input');
        const title = titleInput.value;
        const content = contentInput.value;

        if (!title.trim() || !content.trim()) {
            alert('답글 제목과 내용을 모두 입력해주세요.');
            return;
        }

        const formData = new FormData();
        formData.append('qnaRef', qnaNumber);
        formData.append('title', title);
        formData.append('content', content);

        fetch('/TravelRoulette/board/qna/answer/write.do', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    titleInput.value = '';
                    contentInput.value = '';
                    location.reload();
                } else {
                    // 서버에서 보낸 에러 메시지 표시
                    const errorMessage = data.message || '답글 등록에 실패했습니다.';
                    alert(errorMessage);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('답글 등록 중 오류가 발생했습니다.');
            });
    });

    document.getElementById('answer-container').addEventListener('click', function(event) {
        const target = event.target;

        if (target.id === 'answer-delete-btn') {
            event.preventDefault();

            if (confirm('정말 삭제하시겠습니까?')) {
                const answerId = target.dataset.answerId;

                const formData = new FormData();
                formData.append('qnaNumber', answerId);

                fetch('/TravelRoulette/board/qna/answer/delete.do', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            location.reload();
                        } else {
                            alert('답글 삭제에 실패했습니다.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('답글 삭제 중 오류가 발생했습니다.');
                    });
            }
        }

        if (target.id === 'answer-edit-btn') {
            event.preventDefault();

            const answerId = target.dataset.answerId;
            const answerTitle = target.dataset.answerTitle;
            const answerContent = target.dataset.answerContent;

            const titleDisplay = document.getElementById('answer-title-display');
            const contentDisplay = document.getElementById('answer-content-display');
            const actionButtons = document.getElementById('answer-action-buttons');

            titleDisplay.style.display = 'none';
            contentDisplay.style.display = 'none';
            actionButtons.style.display = 'none';

            const editFormHtml =
                '<div id="answer-edit-form" class="mt-2">' +
                '<input type="text" id="answer-title-edit" class="form-control border-info mb-2" value="' + answerTitle + '" required>' +
                '<textarea id="answer-content-edit" class="form-control border-info mb-2" rows="3" required>' + answerContent + '</textarea>' +
                '<div class="text-end">' +
                '<button type="button" class="btn btn-sm btn-secondary" id="answer-edit-cancel">취소</button> ' +
                '<button type="button" class="btn btn-sm btn-info text-white" id="answer-edit-save" data-answer-id="' + answerId + '">저장</button>' +
                '</div>' +
                '</div>';

            actionButtons.insertAdjacentHTML('afterend', editFormHtml);
        }

        if (target.id === 'answer-edit-cancel') {
            const titleDisplay = document.getElementById('answer-title-display');
            const contentDisplay = document.getElementById('answer-content-display');
            const actionButtons = document.getElementById('answer-action-buttons');
            const editForm = document.getElementById('answer-edit-form');

            titleDisplay.style.display = 'block';
            contentDisplay.style.display = 'block';
            actionButtons.style.display = 'block';

            if (editForm) {
                editForm.remove();
            }
        }

        if (target.id === 'answer-edit-save') {
            const answerId = target.dataset.answerId;
            const newTitle = document.getElementById('answer-title-edit').value;
            const newContent = document.getElementById('answer-content-edit').value;

            if (!newTitle.trim() || !newContent.trim()) {
                alert('제목과 내용을 모두 입력해주세요.');
                return;
            }

            const formData = new FormData();
            formData.append('qnaNumber', answerId);
            formData.append('title', newTitle);
            formData.append('content', newContent);

            fetch('/TravelRoulette/board/qna/answer/update.do', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        location.reload();
                    } else {
                        alert('답글 수정에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('답글 수정 중 오류가 발생했습니다.');
                });
        }
    });
</script>

</body>
</html>
