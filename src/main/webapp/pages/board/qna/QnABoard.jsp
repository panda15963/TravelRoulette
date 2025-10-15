<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 질의응답게시판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="../../../assets/favicon.ico?v=2" />
    <link href="../../../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>
<div class="container-fluid flex-grow-1 p-0">
    <div class="row g-0">
        <%@ include file="/Common/boardSidebar.jsp" %>

        <main id="boardSection" class="col-12 col-md-9 col-lg-10 px-4 py-4 mt-5">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1">질의응답 게시판</h1>
                    <p class="text-muted mb-0">총 <strong>0</strong>개의 글</p>
                </div>
            </div>

            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <label>
                        <input id="searchInput" type="text" class="form-control border-info" placeholder="검색어를 입력하세요" style="width: 250px;" />
                    </label>
                    <label>
                        <select id="sortSelect" class="form-select border-info w-auto">
                            <option value="desc">최신순</option>
                            <option value="asc">오래된순</option>
                        </select>
                    </label>
                    <button class="btn btn-info text-white fw-semibold">검색</button>
                </div>

                <c:if test="${not empty sessionScope.authenticatedUser}">
                    <a href="writeForm.jsp" class="btn btn-info text-white fw-semibold shadow-sm">
                        글쓰기
                    </a>
                </c:if>
            </div>

            <div class="card border-info shadow-sm">
                <div class="card-header bg-info-subtle d-flex justify-content-between align-items-center">
                    <span class="fw-semibold text-primary">게시글 목록</span>
                    <small class="text-muted">궁금한 점을 질문해보세요!</small>
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

                            <tbody id="post-list-body" class="text-center">
                            <tr>
                                <td colspan="4" class="text-center">게시글을 불러오는 중...</td>
                            </tr>
                            </tbody>
                        </table>

                        <nav class="d-flex justify-content-center my-3">
                            <ul id="pagination" class="pagination mb-0"></ul>
                        </nav>

                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../../js/features/darkmode.js"></script>

<script>
    function getParam(name, defVal) {
        const sp = new URLSearchParams(location.search);
        const v = sp.get(name);
        return v !== null ? v : defVal;
    }

    const state = {
        page: parseInt(getParam('page', '1'), 10) || 1,
        size: parseInt(getParam('pageSize', '10'), 10) || 10,
        sort: (getParam('sort', 'desc') === 'asc' ? 'asc' : 'desc'),
        searchKeyword: getParam('searchKeyword', '')
    };

    function setUrlQuery() {
        const sp = new URLSearchParams();
        sp.set('page', String(state.page));
        sp.set('pageSize', String(state.size));
        sp.set('sort', state.sort);
        if (state.searchKeyword && state.searchKeyword.trim() !== '') {
            sp.set('searchKeyword', state.searchKeyword);
        }
        history.pushState(null, '', location.pathname + '?' + sp.toString());
    }

    function loadList() {
        let url = '/TravelRoulette/board/qna/list.do?page=' + state.page +
            '&pageSize=' + state.size +
            '&sort=' + state.sort;
        if (state.searchKeyword && state.searchKeyword.trim() !== '') {
            url += '&searchKeyword=' + encodeURIComponent(state.searchKeyword);
        }

        fetch(url)
            .then(function(res){ return res.json(); })
            .then(function(data){
                const strong = document.querySelector('#boardSection p.text-muted strong');
                if (strong) strong.textContent = data.totalPostCount || 0;

                renderTable(Array.isArray(data.posts) ? data.posts : []);

                renderPagination({
                    currentPage: data.currentPage,
                    totalPages: data.totalPages,
                    startPage: data.startPage,
                    endPage: data.endPage,
                    hasPrev: data.hasPrev,
                    hasNext: data.hasNext
                });
            })
            .catch(function(err){
                console.error('게시글 목록 로딩 중 오류:', err);
                const tbody = document.getElementById('post-list-body');
                if (tbody)
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center">게시글을 불러오는 데 실패했습니다.</td></tr>';
                renderPagination({ currentPage: 1, totalPages: 1, startPage: 1, endPage: 1 });
            });
    }

    function renderTable(list) {
        const tbody = document.getElementById('post-list-body');
        if (!tbody) return;

        if (!list.length) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center">검색 결과가 없습니다.</td></tr>';
            return;
        }

        let html = '';
        for (let i = 0; i < list.length; i++) {
            const post = list[i];
            const num = post.qnaNumber || '';
            let title = post.qnaTitle || '(제목 없음)';
            const user = post.userId || '-';
            const date = post.qnaDateWritten ? post.qnaDateWritten.substring(0, 10) : '';
            const depth = post.qnaDepth || 0;

            // 답글인 경우 들여쓰기와 특수문자 추가
            if (depth === 1) {
                title = '&nbsp;&nbsp;&nbsp;&nbsp;ㄴ ' + title;
            }

            // 답글인 경우 원글 번호 사용 (qnaRef 사용)
            const linkNum = depth === 1 ? post.qnaRef : num;

            html += '<tr data-id="' + linkNum + '">' +
                '<td class="text-center">' + num + '</td>' +
                '<td class="text-start">' +
                '<a href="postView.jsp?qnaNumber=' + linkNum + '" class="text-decoration-none text-dark fw-semibold">' +
                title +
                '</a>' +
                '</td>' +
                '<td class="text-center">' + user + '</td>' +
                '<td class="text-center">' + date + '</td>' +
                '</tr>';
        }
        tbody.innerHTML = html;

        const trs = tbody.querySelectorAll('tr[data-id]');
        for (let j = 0; j < trs.length; j++) {
            trs[j].addEventListener('click', function(e) {
                if (e.target.tagName.toLowerCase() === 'a') return;
                const id = this.getAttribute('data-id');
                location.href = 'postView.jsp?qnaNumber=' + id;
            });
        }
    }

    function renderPagination(opts) {
        const ul = document.getElementById('pagination');
        if (!ul) return;

        const c = Number(opts.currentPage) || 1;
        const t = Number(opts.totalPages) || 1;
        const s = Number(opts.startPage) || 1;
        const e = Number(opts.endPage) || t;

        const hasPrevBlock = opts.hasPrev;
        const hasNextBlock = opts.hasNext;

        function li(label, page, disabled, active) {
            const cls = 'page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '');
            return '<li class="' + cls + '"><a class="page-link" href="#" data-page="' + page + '">' + label + '</a></li>';
        }

        let html = '';
        html += li('«', 1, c === 1, false);
        html += li('‹', hasPrevBlock ? s - 1 : c, !hasPrevBlock, false);

        for (let p = s; p <= e; p++) {
            html += li(String(p), p, false, p === c);
        }

        html += li('›', hasNextBlock ? e + 1 : c, !hasNextBlock, false);
        html += li('»', t, c === t, false);

        ul.innerHTML = html;

        const links = ul.querySelectorAll('a[data-page]');
        for (let k = 0; k < links.length; k++) {
            links[k].addEventListener('click', function(e) {
                e.preventDefault();

                if (this.parentElement.classList.contains('disabled')) return;

                const next = Number(this.getAttribute('data-page'));
                if (!next || next === c) return;
                state.page = next;
                setUrlQuery();
                loadList();
            });
        }
    }

    window.onload = function() {
        const searchInput = document.getElementById('searchInput');
        const searchButton = document.querySelector('button.btn-info');
        const sortSelect = document.getElementById('sortSelect');

        if (searchInput) {
            searchInput.value = state.searchKeyword;
        }

        loadList();

        if (sortSelect) {
            sortSelect.value = state.sort;
            sortSelect.addEventListener('change', function() {
                state.sort = this.value;
                state.page = 1;
                setUrlQuery();
                loadList();
            });
        }

        if (searchButton && searchInput) {
            searchButton.addEventListener('click', function() {
                state.searchKeyword = searchInput.value;
                state.page = 1;
                setUrlQuery();
                loadList();
            });

            searchInput.addEventListener('keyup', function(event) {
                if (event.key === 'Enter') {
                    searchButton.click();
                }
            });
        }
    };
</script>

</body>
</html>
