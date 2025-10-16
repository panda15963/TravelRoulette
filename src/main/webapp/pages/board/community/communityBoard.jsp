<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki | 자유게시판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/x-icon" href="../../../assets/favicon.ico?v=2" />
    <link href="../../../css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />


    <style>
        .table-fixed { table-layout: fixed; width: 100%; }
        .col-num   { width: 80px; min-width: 70px; }
        .col-title { width: auto; }
        .col-author, .col-date { width: 25%; }

        thead th:first-child, tbody td:first-child {
            font-variant-numeric: tabular-nums;
        }

        tbody td:nth-child(2) {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>

</head>

<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>
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
                        <table class="table align-middle table-hover mb-0 table-fixed">
                            <colgroup>
                                <col class="col-num">
                                <col class="col-title">
                                <col class="col-author">
                                <col class="col-date">
                            </colgroup>

                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                            </tr>
                            </thead>

                        <!-- <table class="table align-middle table-hover mb-0">
                            <thead class="table-info text-primary text-center">
                            <tr>
                                <th class="w-10">번호</th>
                                <th>제목</th>
                                <th class="w-25">작성자</th>
                                <th class="w-25">작성일</th>
                            </tr>
                            </thead>
                            -->

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


                        <!-- 페이지네이션 -->
                        <nav class="d-flex justify-content-center my-3">
                            <ul id="pagination" class="pagination mb-0"></ul>
                        </nav>

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
        //검색어가 있을 때만 URL에 추가
        if (state.searchKeyword && state.searchKeyword.trim() !== '') {
            sp.set('searchKeyword', state.searchKeyword);
        }
        history.pushState(null, '', location.pathname + '?' + sp.toString());
    }

    //게시글 목록 불러오기
    function loadList() {

        const url = '${pageContext.request.contextPath}/Board/Community/list.do?page=' + state.page
            + '&pageSize=' + state.pageSize
            + '&sort=' + state.sort
            + (state.searchKeyword ? '&searchKeyword=' + encodeURIComponent(state.searchKeyword) : '');
/*
        if (state.searchKeyword && state.searchKeyword.trim() !== '') {
            //뭔가 오류 뜨길래 인코딩 문제인가 싶어서 일단 넣어본 코드
            url += '&searchKeyword=' + encodeURIComponent(state.searchKeyword);
        }
*/
        fetch(url)
            .then(function(res){ return res.json(); })
            .then(function(data){
                const strong = document.querySelector('#boardSection p.text-muted strong');
                if (strong) strong.textContent = data.totalPostCount || 0;

                renderTable(Array.isArray(data.posts) ? data.posts : []);

                // 버튼 비활성화 처리
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

    //게시글 테이블
    function renderTable(list) {
        const tbody = document.getElementById('post-list-body');
        if (!tbody) return;

        if (!list.length) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center">검색 결과가 없습니다.</td></tr>'; // 문구 약간 수정
            return;
        }

        let html = '';
        for (let i = 0; i < list.length; i++) {
            const post = list[i];
            const num = post.postNumber || '';
            const title = post.postTitle || '(제목 없음)';
            const user = post.userId || '-';
            const date = post.postDateWritten ? post.postDateWritten.substring(0, 10) : ''; // 날짜 형식 처리 추가

            html += '<tr data-id="' + num + '">' +
                '<td class="text-center">' + num + '</td>' +
                '<td class="text-start">' +
                '<a href="postView.jsp?postNumber=' + num + '" class="text-decoration-none text-dark fw-semibold">' +
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
                location.href = 'postView.jsp?postNumber=' + id;
            });
        }
    }

    //페이지네이션
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
        html += li('«', 1, c === 1, false); // '처음' 버튼
        html += li('‹', hasPrevBlock ? s - 1 : c, !hasPrevBlock, false); // '이전 블록' 버튼

        for (let p = s; p <= e; p++) {
            html += li(String(p), p, false, p === c);
        }

        html += li('›', hasNextBlock ? e + 1 : c, !hasNextBlock, false); // '다음 블록' 버튼
        html += li('»', t, c === t, false); // '마지막' 버튼

        ul.innerHTML = html;

        const links = ul.querySelectorAll('a[data-page]');
        for (let k = 0; k < links.length; k++) {
            links[k].addEventListener('click', function(e) {
                e.preventDefault();

                if (this.parentElement.classList.contains('disabled')) return; // 비활성화된 버튼은 클릭 방지

                const next = Number(this.getAttribute('data-page'));
                if (!next || next === c) return;
                state.page = next;
                setUrlQuery();
                loadList();
            });
        }
    }

    //초기 로드 및 이벤트 리스너 설정
    window.onload = function() {
        const searchInput = document.getElementById('searchInput');
        const searchButton = document.querySelector('button.btn-info'); // '검색' 버튼
        const sortSelect = document.getElementById('sortSelect');

        if (searchInput) {
            searchInput.value = state.searchKeyword;
        }

        loadList();

        //정렬
        if (sortSelect) {
            sortSelect.value = state.sort;
            sortSelect.addEventListener('change', function() {
                state.sort = this.value;
                state.page = 1; //정렬 변경 시 1페이지로
                setUrlQuery();
                loadList();
            });
        }

        //검색
        if (searchButton && searchInput) {
            searchButton.addEventListener('click', function() {
                state.searchKeyword = searchInput.value;
                state.page = 1; //검색 시 1페이지로
                setUrlQuery();
                loadList();
            });

            //검색창 엔터 키
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