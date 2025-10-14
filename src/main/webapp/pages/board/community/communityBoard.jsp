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

    // (1) sort 추가 (기본: 최신순 desc)
    const state = {
        page: parseInt(getParam('page', '1'), 10) || 1,
        size: parseInt(getParam('size', '10'), 10) || 10,
        sort: (getParam('sort', 'desc') === 'asc' ? 'asc' : 'desc')
    };

    function setUrlQuery(page, size, sort) {
        const sp = new URLSearchParams(location.search);
        sp.set('page', String(page));
        sp.set('size', String(size));
        if (sort) sp.set('sort', String(sort));
        history.pushState(null, '', location.pathname + '?' + sp.toString());
    }

    // 게시글 목록 불러오기
    function loadList() {
        // (2) fetch URL에 sort 추가
        const url = '/TravelRoulette_war/board/community/list.do?page=' + state.page +
            '&pageSize=' + state.size +
            '&sort=' + state.sort;

        fetch(url)
            .then(function(res){ return res.json(); })
            .then(function(data){
                const strong = document.querySelector('#boardSection p.text-muted strong');
                if (strong) strong.textContent = data.totalPostCount || 0;

                renderTable(Array.isArray(data.posts) ? data.posts : []);

                renderPagination({
                    currentPage: data.currentPage || state.page,
                    totalPages: data.totalPages || 1,
                    startPage: data.startPage || 1,
                    endPage: data.endPage || (data.totalPages || 1)
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

    // 게시글 테이블
    function renderTable(list) {
        const tbody = document.getElementById('post-list-body');
        if (!tbody) return;

        if (!list.length) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center">게시글이 없습니다.</td></tr>';
            return;
        }

        let html = '';
        for (let i = 0; i < list.length; i++) {
            const post = list[i];
            const num = post.postNumber || '';
            const title = post.postTitle || '(제목 없음)';
            const user = post.userId || '-';
            const date = post.postDateWritten || '';

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

    // 페이지네이션
    function renderPagination(opts) {
        const ul = document.getElementById('pagination');
        if (!ul) return;

        const c = Number(opts.currentPage) || 1;
        const t = Number(opts.totalPages) || 1;
        const s = Number(opts.startPage) || 1;
        const e = Number(opts.endPage) || t;

        function li(label, page, disabled, active) {
            const cls = 'page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '');
            return '<li class="' + cls + '"><a class="page-link" href="#" data-page="' + page + '">' + label + '</a></li>';
        }

        let html = '';
        html += li('« 처음', 1, c === 1, false);
        html += li('‹ 이전', Math.max(1, c - 1), c === 1, false);

        for (let p = s; p <= e; p++) {
            html += li(String(p), p, false, p === c);
        }

        html += li('다음 ›', Math.min(t, c + 1), c === t, false);
        html += li('마지막 »', t, c === t, false);

        ul.innerHTML = html;

        const links = ul.querySelectorAll('a[data-page]');
        for (let k = 0; k < links.length; k++) {
            links[k].addEventListener('click', function(e) {
                e.preventDefault();
                const next = Number(this.getAttribute('data-page'));
                if (!next || next === c || next < 1 || next > t) return;
                state.page = next;
                setUrlQuery(state.page, state.size, state.sort);
                loadList();
            });
        }
    }

    // 초기 로드 + (3) 정렬 드롭박스 이벤트 연결
    window.onload = function() {
        loadList();

        const sortSelect = document.getElementById('sortSelect'); // <select id="sortSelect"> 필요
        if (sortSelect) {
            // 현재 state.sort 반영
            if (sortSelect.value !== state.sort) sortSelect.value = state.sort;

            sortSelect.addEventListener('change', function() {
                state.sort = this.value;
                state.page = 1;
                setUrlQuery(state.page, state.size, state.sort);
                loadList();
            });
        }
    };
</script>




<%--<script>--%>
<%--    //웹페이지가 모두 로드된 이후 실행--%>
<%--    window.onload = function() {--%>
<%--        //게시글 목록 데이터를 요청(fetch로 비동기 통신)--%>
<%--        fetch('/TravelRoulette_war/board/community/list.do')--%>
<%--            .then(response => {--%>
<%--                //JSON 데이터만 추출--%>
<%--                return response.json();--%>
<%--            })--%>
<%--            .then(data => {--%>
<%--                //화면 그리기--%>
<%--                console.log("서버로부터 받은 데이터:", data); //F12 확인용--%>

<%--                const tbody = document.getElementById('post-list-body');--%>
<%--                tbody.innerHTML = '';--%>

<%--                let html = ''; //테이블에 추가할 HTML 코드--%>

<%--                //게시글 배열을 순회--%>
<%--                data.forEach(post => {--%>
<%--                    html += '<tr>' +--%>
<%--                        '<td>' + post.postNumber + '</td>' +--%>
<%--                        '<td class="text-center"><a href="postView.jsp?postNumber=' + post.postNumber + '" class="text-decoration-none text-dark">' + post.postTitle + '</a></td>' +--%>
<%--                        '<td>' + post.userId + '</td>' +--%>
<%--                        '<td>' + post.postDateWritten + '</td>' +--%>
<%--                        '</tr>';--%>
<%--                });--%>

<%--                //tbody에 삽입--%>
<%--                tbody.innerHTML = html;--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--                console.error('게시글 목록 로딩 중 오류 발생:', error);--%>
<%--                const tbody = document.getElementById('post-list-body');--%>
<%--                tbody.innerHTML = '<tr><td colspan="5">게시글을 불러오는 데 실패했습니다.</td></tr>';--%>
<%--            });--%>
<%--    };--%>
<%--</script>--%>

</body>
</html>