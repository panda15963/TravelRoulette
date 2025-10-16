<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 여행후기 게시판</title>
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

            <!-- 페이지 제목 -->
            <h1 class="h3 fw-bold text-primary mb-4">여행후기 게시판</h1>

            <!-- 게시글 본문 -->
            <div class="card border-info shadow-sm mb-4">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span id="post-title" class="fw-bold">제목 없음</span>
                    <small id="post-date" class="text-muted">작성일자: -</small>
                </div>
                <div class="card-body">
                    <p id="post-author" class="text-secondary mb-2">작성자: -</p>
                    <hr>
                    <p id="post-content" class="mb-0">내용을 불러오는 중입니다...</p>
                </div>
            </div>

            <!-- 댓글 목록 -->
            <div class="mb-4">
                <h5 class="mb-3">댓글</h5>
                <div id="comment-list-container">
                    <%-- JS로 댓글이 로드됨 --%>
                </div>
            </div>

            <!-- 댓글 입력 -->
            <form id="comment-form" class="d-flex align-items-center mt-3">
                <input type="text" id="comment-input" class="form-control border-info" placeholder="댓글을 남겨주세요" required>
                <button type="submit" class="btn text-white ms-2" style="background-color: #64A5E6;">➤</button>
            </form>

            <!-- 버튼 영역 -->
            <div class="mt-4 d-flex justify-content-end gap-2">
                <a href="#" id="edit-button" class="btn btn-outline-primary px-4 fw-semibold" style="display: none;">수정</a>
                <a href="#" id="delete-button" class="btn btn-outline-danger px-4 fw-semibold" style="display: none;">삭제</a>
                <a href="reviewBoard.jsp" class="btn btn-outline-secondary px-4 fw-semibold">후기 목록</a>
            </div>
        </main>
    </div>
</div>

<!-- ===== JS ===== -->
<script defer src="../../../js/utils/board.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>
<script src="../../../js/utils/authManager.js"></script>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    const postNumber = urlParams.get('postNumber');

    // 댓글 목록 불러오기
    function loadComments(pNum) {
        const currentUserId = AuthManager.getUserId();

        fetch('${pageContext.request.contextPath}/Board/Review/comments.do?postNumber=' + pNum)
            .then(response => response.json())
            .then(comments => {
                const container = document.getElementById('comment-list-container');
                container.innerHTML = '';

                if (comments && comments.length > 0) {
                    let html = '';
                    comments.forEach(comment => {
                        let actionsHtml = '';
                        if (currentUserId && currentUserId === comment.userId) {
                            actionsHtml =
                                '<div class="comment-actions">' +
                                '<a href="#" class="btn btn-sm btn-link text-muted" data-action="edit" data-comment-id="' + comment.commentNumber + '">수정</a>' +
                                '<a href="#" class="btn btn-sm btn-link text-muted" data-action="delete" data-comment-id="' + comment.commentNumber + '">삭제</a>' +
                                '</div>';
                        }

                        html +=
                            '<div class="border rounded p-3 mb-2">' +
                            '<div class="d-flex justify-content-between align-items-center">' +
                            '<strong>' + comment.userId + '</strong>' +
                            actionsHtml +
                            '</div>' +
                            '<p class="mb-1">' + comment.commentDescription + '</p>' +
                            '<small class="text-muted">' + comment.dateWritten + '</small>' +
                            '</div>';
                    });
                    container.innerHTML = html;
                } else {
                    container.innerHTML = '<p class="text-muted">아직 댓글이 없습니다.</p>';
                }
            })
            .catch(error => {
                console.error('댓글 로딩 중 오류:', error);
                document.getElementById('comment-list-container').innerHTML = '<p class="text-danger">댓글을 불러오는 데 실패했습니다.</p>';
            });
    }

    // 후기 상세 불러오기
    window.onload = function() {
        if (postNumber) {
            fetch('${pageContext.request.contextPath}/Board/Review/detail.do?postNumber=' + postNumber)
                .then(response => response.json())
                .then(post => {
                    document.getElementById('post-title').innerText = post.postTitle;
                    document.getElementById('post-date').innerText = '작성일: ' + post.postDateWritten;
                    document.getElementById('post-author').innerText = '작성자: ' + post.userId;
                    document.getElementById('post-content').innerText = post.postDescription;

                    document.getElementById('edit-button').href = 'editForm.jsp?postNumber=' + post.postNumber;

                    const currentUserId = AuthManager.getUserId();
                    if (currentUserId && currentUserId === post.userId) {
                        document.getElementById('edit-button').style.display = 'inline-block';
                        document.getElementById('delete-button').style.display = 'inline-block';
                    }

                    loadComments(postNumber);
                })
                .catch(error => {
                    console.error('후기 상세 로딩 오류:', error);
                    document.getElementById('post-content').innerText = '후기를 불러오는 데 실패했습니다.';
                });
        }
    };

    // 후기 삭제
    document.getElementById('delete-button').addEventListener('click', function(event) {
        event.preventDefault();
        if (confirm('정말 삭제하시겠습니까?')) {
            const formData = new FormData();
            formData.append('postNumber', postNumber);

            fetch('${pageContext.request.contextPath}/Board/Review/delete.do', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert('후기가 성공적으로 삭제되었습니다.');
                        location.href = 'reviewBoard.jsp';
                    } else {
                        alert('후기 삭제에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('후기 삭제 중 오류가 발생했습니다.');
                });
        }
    });

    // 댓글 등록
    document.getElementById('comment-form').addEventListener('submit', function(event) {
        event.preventDefault();
        const commentInput = document.getElementById('comment-input');
        const commentDescription = commentInput.value.trim();

        if (!commentDescription) {
            alert('댓글 내용을 입력해주세요.');
            return;
        }

        const formData = new FormData();
        formData.append('postNumber', postNumber);
        formData.append('commentDescription', commentDescription);

        fetch('${pageContext.request.contextPath}/Board/Review/comment/write.do', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    commentInput.value = '';
                    loadComments(postNumber);
                } else {
                    alert('댓글 등록에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('댓글 등록 중 오류가 발생했습니다.');
            });
    });

    // 댓글 수정/삭제
    document.getElementById('comment-list-container').addEventListener('click', function(event) {
        const target = event.target;
        const action = target.dataset.action;
        if (!action) return;

        const commentDiv = target.closest('.border');
        if (!commentDiv) return;

        // 수정
        if (action === 'edit') {
            event.preventDefault();
            const commentId = target.dataset.commentId;
            const contentP = commentDiv.querySelector('p.mb-1');
            const actionsDiv = commentDiv.querySelector('.comment-actions');
            const originalText = contentP.innerText;

            contentP.style.display = 'none';
            actionsDiv.style.display = 'none';

            const editFormHtml =
                '<div class="edit-form">' +
                '<textarea class="form-control mb-2">' + originalText + '</textarea>' +
                '<div class="text-end">' +
                '<button type="button" class="btn btn-sm btn-secondary" data-action="cancel">취소</button>' +
                '<button type="button" class="btn btn-sm btn-info text-white" data-action="save" data-comment-id="' + commentId + '">저장</button>' +
                '</div>' +
                '</div>';
            contentP.insertAdjacentHTML('afterend', editFormHtml);
        }

        // 수정 취소
        if (action === 'cancel') {
            const contentP = commentDiv.querySelector('p.mb-1');
            const actionsDiv = commentDiv.querySelector('.comment-actions');
            const editForm = commentDiv.querySelector('.edit-form');
            contentP.style.display = 'block';
            actionsDiv.style.display = 'block';
            if (editForm) editForm.remove();
        }

        // 저장
        if (action === 'save') {
            const commentId = target.dataset.commentId;
            const newDescription = commentDiv.querySelector('.edit-form textarea').value;

            const formData = new FormData();
            formData.append('commentNumber', commentId);
            formData.append('commentDescription', newDescription);

            fetch('${pageContext.request.contextPath}/Board/Review/comment/update.do', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        loadComments(postNumber);
                    } else {
                        alert('댓글 수정에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('댓글 수정 중 오류가 발생했습니다.');
                });
        }

        // 삭제
        if (action === 'delete') {
            event.preventDefault();
            if (confirm('정말 삭제하시겠습니까?')) {
                const commentId = target.dataset.commentId;
                const formData = new FormData();
                formData.append('commentNumber', commentId);

                fetch('${pageContext.request.contextPath}/Board/Review/comment/delete.do', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            loadComments(postNumber);
                        } else {
                            alert('댓글 삭제에 실패했습니다.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('댓글 삭제 중 오류가 발생했습니다.');
                    });
            }
        }
    });
</script>

</body>
</html>