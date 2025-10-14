// ===== 설정 =====
const boardEl = document.getElementById('board');
const COLUMNS = [
  { key: 'todo', label: 'To Do' },
  { key: 'inprogress', label: 'In Progress' },
  { key: 'done', label: 'Done' },
];

//=====언더바 보정함수======
function normalizeStatus(status) {
  if (!status) return "";
  return status.toLowerCase().replace("_", ""); // "IN_PROGRESS" → "inprogress"
}

/* ===========================
      🧩 서버 통신 함수들
=========================== */

// ✅ 1. 모든 카드 조회
async function loadAll() {
  const res = await fetch("/TravelRoulette/kanban?action=list");
  const data = await res.json();
  if (data.error) console.error(data.error);
  return data.data || [];
}

// ✅ 2. 카드 생성
async function createTask({ content, status, due, priority }) {
  const params = new URLSearchParams({
    description: content,
    status,
    dueDate: due || "",
    priority: priority || "Medium",
  });

  const res = await fetch("/TravelRoulette/kanban?action=create", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: params,
  });

  const data = await res.json();
  if (!data.success) alert("❌ 생성 실패: " + (data.error || ""));
  return data.success;
}

// ✅ 3. 카드 수정
async function updateTask(taskId, status, content, priority, dueDate) {
  const params = new URLSearchParams({
    taskId,
    status,
    description: content,
    priority,
    dueDate: dueDate || "",
  });

  const res = await fetch("/TravelRoulette/kanban?action=update", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: params,
  });

  const data = await res.json();
  if (!data.success) alert("❌ 수정 실패: " + (data.error || ""));
  return data.success;
}

// ✅ 4. 카드 삭제
async function deleteTask(taskId) {
  if (!confirm("정말로 삭제하시겠습니까?")) return false;
  const res = await fetch(`/TravelRoulette/kanban?action=delete&taskId=${taskId}`);
  const data = await res.json();
  if (data.success) {
    alert("✅ 삭제 완료");
    render();
    return true;
  } else {
    alert("❌ 삭제 실패: " + (data.error || ""));
    return false;
  }
}

// ✅ 5. 같은 컬럼 내 순서 재정렬
async function reorderWithinStatus(status) {
  const ids = [...document.querySelectorAll(`[data-status='${status}'] .card`)]
    .map((el) => el.dataset.id);

  const params = new URLSearchParams();
  ids.forEach((id) => params.append("orderedIds[]", id));
  params.append("status", status);

  await fetch("/TravelRoulette/kanban?action=reorder", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: params,
  });
}

// ✅ 6. 카드 이동 (다른 컬럼으로)
async function moveToStatus(taskId, from, to, newOrder) {
  const params = new URLSearchParams({
    taskId,
    from,
    to,
    newOrder,
  });
  await fetch("/TravelRoulette/kanban?action=move", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: params,
  });
}

/* ===========================
        🎨 렌더링 로직
=========================== */
async function render() {
  const tasks = await loadAll();
  console.log("🧾 받은 데이터:", tasks);
  boardEl.innerHTML = "";
  for (const col of COLUMNS) {
    const columnEl = document.createElement("div");
    columnEl.className = "column";
    columnEl.dataset.status = col.key;

    const header = document.createElement("div");
    header.className = "column-header";
    header.innerHTML = `
      <span class="dot ${col.key}"></span>
      <span class="column-title">${col.label}</span>
      <span class="count" id="count-${col.key}"></span>`;
    columnEl.appendChild(header);

    const list = document.createElement("div");
    list.className = "list";
    list.dataset.status = col.key;
    list.addEventListener("dragover", (e) => {
      e.preventDefault();
      list.classList.add("drag-over");
    });
    list.addEventListener("dragleave", () => list.classList.remove("drag-over"));
    list.addEventListener("drop", (e) => onDropList(e, col.key));

    const items = tasks
      .filter(t => normalizeStatus(t.taskStatus) === col.key)
      .sort((a, b) => a.taskOrder - b.taskOrder);

    for (const t of items) list.appendChild(renderCard(t));

    columnEl.appendChild(list);
    boardEl.appendChild(columnEl);
    document.getElementById(`count-${col.key}`).textContent = `${items.length}`;
  }
}

// 카드 렌더링
function renderCard(t) {
  const el = document.createElement("article");
  el.className = "card";
  el.draggable = true;
  el.dataset.id = t.taskId;
  el.addEventListener("dragstart", onDragStart);
  el.addEventListener("dragend", onDragEnd);

  const due = t.dueDate ? new Date(t.dueDate).toLocaleDateString() : "-";
  el.innerHTML = `
    <div class="card-header">
      <span class="task-id">#${t.taskId}</span>
      <span class="priority ${t.priority.toLowerCase()}">${t.priority}</span>
    </div>
    <div class="content">${escapeHtml(t.taskDescription)}</div>
    <div class="meta">
      <span><b>Order</b>: ${t.taskOrder}</span>
      <span><b>마감</b>: ${due}</span>
    </div>
    <div class="card-actions">
      <button onclick="promptEdit(${t.taskId})">수정</button>
      <button onclick="deleteTask(${t.taskId})">삭제</button>
    </div>`;
  return el;
}

function escapeHtml(str = "") {
  return str.replace(/[&<>"']/g, (m) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;",
  }[m]));
}

/* ===========================
      🧱 드래그 관련 이벤트
=========================== */
let dragTaskId = null;
let dragFromStatus = null;

function onDragStart(e) {
  dragTaskId = Number(e.currentTarget.dataset.id);
  dragFromStatus = e.currentTarget.closest(".list").dataset.status;
  e.dataTransfer.setData("text/plain", String(dragTaskId));
  e.dataTransfer.effectAllowed = "move";
}

function onDragEnd() {
  dragTaskId = null;
  dragFromStatus = null;
  document.querySelectorAll(".list").forEach((l) => l.classList.remove("drag-over"));
  render();
}

async function onDropList(e, targetStatus) {
  e.preventDefault();
  const id = Number(e.dataTransfer.getData("text/plain")) || dragTaskId;
  if (!id) return;

  const cards = [...document.querySelectorAll(`[data-status='${targetStatus}'] .card`)];
  const newOrder = cards.length;

  if (dragFromStatus !== targetStatus) {
    await moveToStatus(id, dragFromStatus, targetStatus, newOrder);
  } else {
    await reorderWithinStatus(targetStatus);
  }
  render();
}

/* ===========================
        ➕ 신규 카드 추가
=========================== */
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("newTaskForm");
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const content = document.getElementById("content").value.trim();
    const status = document.getElementById("status").value;
    const due = document.getElementById("due").value
      ? new Date(document.getElementById("due").value).toISOString().replace("Z", "")
      : "";
    const priority = document.getElementById("priority").value;

    if (!content) return;
    await createTask({ content, status, due, priority });
    e.target.reset();
    render();
  });

  render();
});

/* ===========================
        ✍️ 카드 수정 (모달)
=========================== */
async function promptEdit(taskId) {
  const tasks = await loadAll();
  const t = tasks.find(x => x.taskId === taskId);
  if (!t) return alert("해당 카드를 찾을 수 없습니다.");

  const existingModal = document.getElementById("editModal");
  if (existingModal) existingModal.remove();

  const modalHtml = `
    <div id="editModal" class="edit-modal">
      <div class="edit-modal-content">
        <h3>카드 수정 (#${t.taskId})</h3>

        <label>내용</label>
        <textarea id="editContent" rows="3">${t.taskDescription}</textarea>

        <label>상태</label>
        <select id="editStatus">
          <option value="todo" ${normalizeStatus(t.taskStatus) === "todo" ? "selected" : ""}>To Do</option>
          <option value="inprogress" ${normalizeStatus(t.taskStatus) === "inprogress" ? "selected" : ""}>In Progress</option>
          <option value="done" ${normalizeStatus(t.taskStatus) === "done" ? "selected" : ""}>Done</option>
        </select>

        <label>우선순위</label>
        <select id="editPriority">
          <option value="High" ${t.priority.toLowerCase() === "high" ? "selected" : ""}>High</option>
          <option value="Medium" ${t.priority.toLowerCase() === "medium" ? "selected" : ""}>Medium</option>
          <option value="Low" ${t.priority.toLowerCase() === "low" ? "selected" : ""}>Low</option>
        </select>

        <label>마감일</label>
        <input type="date" id="editDue" value="${t.dueDate ? new Date(t.dueDate).toISOString().slice(0,10) : ""}" />

        <div class="edit-buttons">
          <button id="saveEdit" class="btn-primary">저장</button>
          <button id="cancelEdit" class="btn-secondary">취소</button>
        </div>
      </div>
    </div>
  `;
  document.body.insertAdjacentHTML("beforeend", modalHtml);

  document.getElementById("cancelEdit").addEventListener("click", () => {
    document.getElementById("editModal").remove();
  });

  document.getElementById("saveEdit").addEventListener("click", async () => {
    const newDesc = document.getElementById("editContent").value.trim();
    const newStatus = document.getElementById("editStatus").value;
    const newPriority = document.getElementById("editPriority").value;
    const newDue = document.getElementById("editDue").value
      ? new Date(document.getElementById("editDue").value).toISOString().replace("Z", "")
      : "";

    if (!newDesc) {
      alert("내용을 입력해주세요!");
      return;
    }

    await updateTask(taskId, newStatus, newDesc, newPriority, newDue);
    document.getElementById("editModal").remove();
    render();
  });
}
