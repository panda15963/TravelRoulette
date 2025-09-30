<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Karban</title>
    <link href="../css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>

<style>
    /* ===== CSS 부분: 기존 그대로 유지 ===== */
    html, body {
        height: 100%;
        margin: 0;
        font-family: Arial, sans-serif;
        background: #fafafa;
        color: #333;
    }

    #add-column-btn {
        margin: 15px;
        padding: 10px 15px;
        font-size: 15px;
        border: none;
        border-radius: 6px;
        background: #007bff;
        color: white;
        cursor: pointer;
        transition: background 0.3s;
    }

    #add-column-btn:hover {
        background: #0056b3;
    }

    #board {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        padding: 80px 15px 15px;
        box-sizing: border-box;
        height: calc(100vh - 60px);
        overflow-y: auto;
    }

    .column {
        background: #ffffff;
        padding: 12px;
        flex: 1 1 calc(25% - 15px);
        min-width: 260px;
        border-radius: 8px;
        display: flex;
        flex-direction: column;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    #board .column h2 {
        font-size: 18px;
        font-weight: bold;
        margin: 0 0 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #000 !important;
    }

    .delete-column-btn {
        background: none;
        border: none;
        color: #888;
        font-size: 16px;
        cursor: pointer;
        transition: color 0.2s;
    }

    .delete-column-btn:hover {
        color: #e74c3c;
    }

    .card-list {
        min-height: 60px;
        flex-grow: 1;
    }

    .kanban-card {
        background: #fff !important;
        padding: 10px;
        margin: 6px 0;
        border-radius: 6px;
        cursor: grab;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
        color: #000 !important;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        transition: transform 0.15s;
    }

    .kanban-card:hover {
        transform: scale(1.02);
    }

    .kanban-card span {
        color: #000 !important;
        font-size: 14px;
        flex-grow: 1;
    }

    .delete-btn {
        background: none;
        color: #999;
        border: none;
        border-radius: 3px;
        cursor: pointer;
        padding: 2px 6px;
        transition: color 0.2s;
    }

    .delete-btn:hover {
        color: #e74c3c;
    }

    .add-card-btn {
        margin-top: 10px;
        padding: 6px;
        font-size: 13px;
        border: none;
        border-radius: 5px;
        background: #f1f1f1;
        cursor: pointer;
        transition: background 0.3s;
    }

    .add-card-btn:hover {
        background: #e0e0e0;
    }

    @media (max-width: 1200px) {
        .column {
            flex: 1 1 calc(33.333% - 15px);
        }
    }

    @media (max-width: 900px) {
        .column {
            flex: 1 1 calc(50% - 15px);
        }
    }

    @media (max-width: 600px) {
        .column {
            flex: 1 1 calc(100% - 15px);
        }
    }
</style>

<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<div id="board"></div>
<button id="add-column-btn">칼럼 추가</button>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/darkmode.js"></script>

<script>
    let boardData = JSON.parse(localStorage.getItem("boardData")) || {
        "To Do": ["HTML 구현하기", "CSS 디자인하기"],
        "In Progress": ["자바스크립트 구현하기"],
        "Done": ["기획서 작성하기"]
    };

    let draggedCard = null;

    function renderBoard() {
        const board = document.getElementById("board");
        board.innerHTML = "";

        for (let columnName in boardData) {
            const column = document.createElement("div");
            column.className = "column";
            column.dataset.column = columnName;

            // ==== 여기 수정 (칼럼 제목 innerHTML → textContent) ====
            const h2 = document.createElement("h2");

            const titleSpan = document.createElement("span");
            titleSpan.textContent = columnName; // ⭐ 제목 안전하게 표시

            const colDelBtn = document.createElement("button");
            colDelBtn.className = "delete-column-btn";
            colDelBtn.textContent = "X";
            colDelBtn.dataset.column = columnName; // ⭐ 버튼에도 column 정보 저장

            h2.appendChild(titleSpan);
            h2.appendChild(colDelBtn);

            const cardList = document.createElement("div");
            cardList.className = "card-list";

            const addBtn = document.createElement("button");
            addBtn.className = "add-card-btn";
            addBtn.textContent = "카드 추가";

            column.appendChild(h2);
            column.appendChild(cardList);
            column.appendChild(addBtn);

            board.appendChild(column);
            // ============================================

            // === 카드 렌더링 (이미 textContent로 수정된 부분) ===
            boardData[columnName].forEach((cardText, index) => {
                const card = document.createElement("div");
                card.className = "kanban-card";
                card.draggable = true;
                card.dataset.index = index;
                card.dataset.column = columnName;

                // ==== 여기 수정 (innerHTML → textContent) ====
                const span = document.createElement("span");
                span.textContent = cardText; // ⭐ 카드 텍스트 안전하게 표시

                const delBtn = document.createElement("button");
                delBtn.className = "delete-btn";
                delBtn.textContent = "X";

                delBtn.addEventListener("click", e => {
                    e.stopPropagation();
                    boardData[columnName].splice(index, 1);
                    saveBoard();
                    renderBoard();
                });

                card.appendChild(span);
                card.appendChild(delBtn);
                cardList.appendChild(card);
                // ============================================
            });
        }

        addDragEvents();
        addColumnEvents();
        addCardEditEvents();
    }

    function addDragEvents() {
        document.querySelectorAll(".kanban-card").forEach(card => {
            card.addEventListener("dragstart", e => {
                draggedCard = card;
            });
        });

        document.querySelectorAll(".card-list").forEach(list => {
            list.addEventListener("dragover", e => e.preventDefault());
            list.addEventListener("drop", e => {
                const column = list.closest(".column").dataset.column;
                const fromColumn = draggedCard.dataset.column;
                const cardIndex = draggedCard.dataset.index;

                boardData[column].push(boardData[fromColumn][cardIndex]);
                boardData[fromColumn].splice(cardIndex, 1);

                saveBoard();
                renderBoard();
            });
        });
    }

    function addColumnEvents() {
        document.querySelectorAll(".add-card-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const column = btn.closest(".column").dataset.column;
                const cardText = prompt("새 카드 제목을 입력하세요");
                if (cardText) {
                    boardData[column].push(cardText);
                    saveBoard();
                    renderBoard();
                }
            });
        });

        document.querySelectorAll(".delete-column-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const column = btn.dataset.column; // ⭐ 버튼에서 직접 column 값 가져오기
                if (confirm(`칼럼 "${column}"을 삭제하시겠습니까?`)) {
                    Reflect.deleteProperty(boardData, column); // ✅ delete 대신 Reflect 사용
                    saveBoard();
                    renderBoard();
                }
            });
        });
    }

    function addCardEditEvents() {
        document.querySelectorAll(".kanban-card span").forEach(span => {
            span.addEventListener("click", e => {
                e.stopPropagation();
                const card = span.parentElement;
                const columnName = card.dataset.column;
                const index = card.dataset.index;

                const input = document.createElement("input");
                input.type = "text";
                input.value = span.textContent;
                input.style.width = "80%";

                span.replaceWith(input);
                input.focus();

                function saveEdit() {
                    const newText = input.value.trim();
                    if (newText) {
                        boardData[columnName][index] = newText;
                        saveBoard();
                        renderBoard();
                    } else {
                        renderBoard();
                    }
                }

                input.addEventListener("blur", saveEdit);
                input.addEventListener("keydown", e => {
                    if (e.key === "Enter") saveEdit();
                });
            });
        });
    }

    document.getElementById("add-column-btn").addEventListener("click", () => {
        const columnName = prompt("새 칼럼 이름을 입력하세요");
        if (columnName && !boardData[columnName]) {
            boardData[columnName] = [];
            saveBoard();
            renderBoard();
        } else {
            alert("이미 존재하는 칼럼이거나 이름이 비어있습니다.");
        }
    });

    function saveBoard() {
        localStorage.setItem("boardData", JSON.stringify(boardData));
    }

    renderBoard();
</script>
</body>
</html>
