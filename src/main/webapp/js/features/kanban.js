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