<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Board</title>
	<link href="../css/styles.css" rel="stylesheet" />
	<!-- Bootstrap CSS (필요하다면 추가) -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            margin: 24px;
            font-family: system-ui, -apple-system, "Noto Sans KR", sans-serif;
            line-height: 1.5
        }

        .wrap {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            gap: 16px
        }

        input, textarea, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 8px
        }

        button {
            padding: 8px 12px;
            border: 0;
            border-radius: 8px;
            background: #2563eb;
            color: #fff;
            cursor: pointer
        }

        button.ghost {
            background: #f2f2f2;
            color: #333
        }

        table {
            width: 100%;
            border-collapse: collapse
        }

        th, td {
            padding: 8px;
            border-bottom: 1px solid #eee;
            text-align: left
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px
        }

        .controls {
            display: flex;
            gap: 8px;
            align-items: center
        }

        .sr-only {
            position: absolute;
            left: -10000px;
            top: auto;
            width: 1px;
            height: 1px;
            overflow: hidden
        }

        .muted {
            color: #666;
            font-size: 12px
        }

        dialog {
            border: 0;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, .15);
            max-width: 640px;
            width: min(640px, 92vw)
        }

        dialog::backdrop {
            background: rgba(0, 0, 0, .35)
        }

        .toast {
            position: fixed;
            right: 20px;
            bottom: 20px;
            background: #111;
            color: #fff;
            padding: 10px 14px;
            border-radius: 10px;
            opacity: .95
        }

        .view-meta {
            display: grid;
            grid-template-columns: 90px 1fr;
            gap: 6px 12px;
            margin: 8px 0 12px
        }

        .view-meta div {
            padding: 6px 8px;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 8px
        }

        .view-content {
            white-space: pre-wrap;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 12px;
            background: #fff
        }

        @media ( max-width :640px) {
            table thead {
                display: none
            }
            table, tbody, tr, td {
                display: block;
                width: 100%
            }
            tbody tr {
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 8px;
                margin-bottom: 8px
            }
            td[data-label]::before {
                content: attr(data-label) " : ";
                font-weight: 600;
                color: #666;
                margin-right: 6px
            }
            .toolbar {
                flex-direction: column;
                align-items: stretch
            }
            .view-meta {
                grid-template-columns: 1fr
            }
        }
    </style>

</head>
<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<!-- 여기에 Board 관련 내용 작성 -->

<main class="wrap pt-5">
    <h1>간단 게시판</h1>

    <!-- 툴바 -->
    <section class="toolbar" aria-label="검색 및 정렬" id="toolbar">
        <div>
            <strong id="count">0</strong>개의 글
        </div>
        <div class="controls">
            <input id="q" placeholder="검색(제목/작성자/내용)" aria-label="검색어" /> <select
                id="sort" aria-label="정렬">
            <option value="new">최신순</option>
            <option value="old">오래된순</option>
            <option value="title">제목순</option>
            <option value="author">작성자순</option>
        </select>
            <button id="clear" class="ghost" type="button">지우기</button>
            <button id="writeBtn" type="button">글쓰기</button>
        </div>
    </section>

    <!-- 목록 -->
    <section aria-labelledby="list-title" id="listSection">
        <h2 id="list-title" class="sr-only">게시글 목록</h2>
        <table id="list">
            <thead>
            <tr>
                <th style="width: 80px">번호</th>
                <th>제목</th>
                <th style="width: 140px">작성자</th>
                <th style="width: 200px">작성일</th>
                <th style="width: 160px">작업</th>
            </tr>
            </thead>
            <tbody id="rows">
            <!-- JS로 렌더링 -->
            </tbody>
        </table>
    </section>

    <!-- 글쓰기 모달 -->
    <dialog id="writeDialog" aria-labelledby="writeDialogTitle">
        <h3 id="writeDialogTitle">새 글</h3>
        <div id="writeMount">
            <!-- postForm.html -->
        </div>
    </dialog>

    <!-- 보기 모달 -->
    <dialog id="viewDialog" aria-labelledby="viewDialogTitle">
        <h3 id="viewDialogTitle">게시글</h3>
        <div id="viewMount">
            <!-- JS로 내용 채움 -->
        </div>
        <form method="dialog" style="margin-top: 12px; text-align: right">
            <button class="ghost" value="close">닫기</button>
        </form>
    </dialog>

    <!-- 알림 -->
    <div id="toast" class="toast" role="status" aria-live="polite" hidden></div>
</main>

<!-- JS 연결 -->
<script defer src="../js/board.js"></script>

<!-- Bootstrap JS (필요하다면 추가) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/features/darkmode.js"></script>
</body>
</html>