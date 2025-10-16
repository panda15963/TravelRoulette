// ===== 설정 ===== (로컬스토리지 키 정의)
const STORAGE_KEY = 'KANBAN_TASK_DEMO_V1';

// 로컬스토리지에서 모든 작업 불러오기
function loadAll() {
  const raw = localStorage.getItem(STORAGE_KEY);
  if (!raw) return [];
  try { return JSON.parse(raw); } catch { return []; }
}

// 모든 작업을 로컬스토리지에 저장
function saveAll(tasks) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks));
}

// 다음 TASK_ID 계산
function nextId(tasks) {
  return tasks.length ? Math.max(...tasks.map(t => t.TASK_ID)) + 1 : 1;
}

// 초기 시드 데이터 추가 (최초 실행 시)
function ensureSeed() {
  const tasks = loadAll();
  if (tasks.length) return;
  const seed = [
    { TASK_ID: 1, TASK_CONTENT: '새로운 기능 기획', TASK_STATUS: 'todo', TASK_ORDER: 0, PRIORITY: 'High', CREATED_DATE: new Date().toISOString() },
    { TASK_ID: 2, TASK_CONTENT: 'UI 와이어프레임', TASK_STATUS: 'todo', TASK_ORDER: 1, PRIORITY: 'Medium', CREATED_DATE: new Date().toISOString() },
    { TASK_ID: 3, TASK_CONTENT: 'API 명세서 작성', TASK_STATUS: 'inprogress', TASK_ORDER: 0, PRIORITY: 'High', CREATED_DATE: new Date().toISOString() },
    { TASK_ID: 4, TASK_CONTENT: '코드 리뷰', TASK_STATUS: 'done', TASK_ORDER: 0, PRIORITY: 'Low', CREATED_DATE: new Date().toISOString() },
  ];
  saveAll(seed);
}

// 상태별 순서를 정규화 (TASK_ORDER 0~N-1 유지)
function normalizeOrders(tasks) {
  const statuses = ['todo','inprogress','done'];
  let changed = false;
  for (const s of statuses) {
    const col = tasks.filter(t => t.TASK_STATUS === s).sort((a,b) => a.TASK_ORDER - b.TASK_ORDER);
    col.forEach((t, idx) => { if (t.TASK_ORDER !== idx) { t.TASK_ORDER = idx; changed = true; } });
  }
  if (changed) saveAll(tasks);
  return tasks;
}

// 새로운 작업 생성
function createTask({ content, status, due, priority }) {
  const tasks = loadAll();
  const id = nextId(tasks);
  const order = tasks.filter(t => t.TASK_STATUS === status).length;
  const task = {
    TASK_ID: id,
    TASK_CONTENT: content,
    TASK_STATUS: status,
    TASK_ORDER: order,
    DUE_DATE: due || '',
    PRIORITY: priority || 'Medium',
    CREATED_DATE: new Date().toISOString(),
  };
  tasks.push(task);
  saveAll(tasks);
  return task;
}

// 작업 삭제
async function deleteTask(taskId) {
  const confirmed = await confirm('정말로 이 작업을 삭제하시겠습니까?');
  if (!confirmed) return;
  let tasks = loadAll().filter(t => t.TASK_ID !== taskId);
  saveAll(tasks);
  normalizeOrders(loadAll());
  alert('작업이 성공적으로 삭제되었습니다.');
}

// 작업 상태 이동 (컬럼 간 이동)
function moveToStatus(taskId, newStatus) {
  const tasks = loadAll();
  const t = tasks.find(x => x.TASK_ID === taskId);
  if (!t) return;
  const oldStatus = t.TASK_STATUS;
  if (oldStatus === newStatus) return;
  const newOrder = tasks.filter(x => x.TASK_STATUS === newStatus).length;
  t.TASK_STATUS = newStatus;
  t.TASK_ORDER = newOrder;
  saveAll(tasks);
  normalizeOrders(tasks);
}

// 같은 컬럼 내에서 순서 재조정
function reorderWithinStatus(taskId, targetOrder) {
  const tasks = loadAll();
  const t = tasks.find(x => x.TASK_ID === taskId);
  if (!t) return;
  const status = t.TASK_STATUS;
  const same = tasks.filter(x => x.TASK_STATUS === status);
  const maxIdx = same.length - 1;
  const newPos = Math.max(0, Math.min(targetOrder, maxIdx));
  for (const x of same) {
    if (x.TASK_ID !== t.TASK_ID && x.TASK_ORDER >= newPos) {
      x.TASK_ORDER += 1;
    }
  }
  t.TASK_ORDER = newPos;
  saveAll(tasks);
  normalizeOrders(tasks);
}

// 보드 컬럼 구성 정보
const boardEl = document.getElementById('board');
const COLUMNS = [
  { key: 'todo', label: 'To Do' },
  { key: 'inprogress', label: 'In Progress' },
  { key: 'done', label: 'Done' },
];

// 보드 전체 렌더링
function render() {
  const tasks = normalizeOrders(loadAll());
  boardEl.innerHTML = '';
  for (const col of COLUMNS) {
    const columnEl = document.createElement('div');
    columnEl.className = 'column';
    columnEl.dataset.status = col.key;
    const header = document.createElement('div');
    header.className = 'column-header';
    header.innerHTML = `<span class="dot ${col.key}"></span><span class="column-title">${col.label}</span><span class="count" id="count-${col.key}"></span>`;
    columnEl.appendChild(header);
    const list = document.createElement('div');
    list.className = 'list';
    list.dataset.status = col.key;
    list.addEventListener('dragover', (e) => { e.preventDefault(); list.classList.add('drag-over'); });
    list.addEventListener('dragleave', () => list.classList.remove('drag-over'));
    list.addEventListener('drop', (e) => onDropList(e, col.key));
    const items = tasks.filter(t => t.TASK_STATUS === col.key).sort((a,b) => a.TASK_ORDER - b.TASK_ORDER);
    for (const t of items) list.appendChild(renderCard(t));
    columnEl.appendChild(list);
    boardEl.appendChild(columnEl);
    document.getElementById(`count-${col.key}`).textContent = `${items.length}`;
  }
}

// 개별 카드 렌더링
function renderCard(t) {
  const el = document.createElement('article');
  el.className = 'card';
  el.draggable = true;
  el.dataset.id = t.TASK_ID;
  el.addEventListener('dragstart', onDragStart);
  el.addEventListener('dragend', onDragEnd);
  const due = t.DUE_DATE ? new Date(t.DUE_DATE).toLocaleDateString() : '-';
  el.innerHTML = `<div class="card-header"><span class="task-id">#${t.TASK_ID}</span><span class="priority ${t.PRIORITY || 'Medium'}">${t.PRIORITY || 'Medium'}</span></div><div class="content">${escapeHtml(t.TASK_CONTENT)}</div><div class="meta"><span><b>Order</b>: ${t.TASK_ORDER}</span><span><b>마감</b>: ${due}</span></div><div class="card-actions"><button onclick="promptEdit(${t.TASK_ID})">수정</button><button onclick="deleteTask(${t.TASK_ID}); render();">삭제</button></div>`;
  return el;
}

// HTML 안전 문자 변환
function escapeHtml(str='') {
  return str.replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[m]));
}

// 드래그 시작 시 호출
let dragTaskId = null;
function onDragStart(e) {
  dragTaskId = Number(e.currentTarget.dataset.id);
  e.dataTransfer.setData('text/plain', String(dragTaskId));
  e.dataTransfer.effectAllowed = 'move';
}

// 드래그 종료 시 보드 갱신
function onDragEnd() {
  dragTaskId = null;
  document.querySelectorAll('.list').forEach(l => l.classList.remove('drag-over'));
  render();
}

// 카드가 컬럼에 드롭될 때 동작
function onDropList(e, targetStatus) {
  e.preventDefault();
  const id = Number(e.dataTransfer.getData('text/plain')) || dragTaskId;
  if (!id) return;
  const tasks = loadAll();
  const t = tasks.find(x => x.TASK_ID === id);
  const isSame = t && t.TASK_STATUS === targetStatus;
  if (!t) return;
  if (!isSame) moveToStatus(id, targetStatus);
  else {
    const tail = tasks.filter(x => x.TASK_STATUS === targetStatus).length - 1;
    reorderWithinStatus(id, tail);
  }
  render();
}

// 드래그 중 카드 위에 마우스 올렸을 때 동작
 document.addEventListener('dragover', (e) => {
  const card = e.target.closest('.card');
  if (!card || dragTaskId == null) return;
  e.preventDefault();
});

// 카드 위로 드롭 시 위치 조정
 document.addEventListener('drop', (e) => {
  const overCard = e.target.closest('.card');
  if (!overCard || dragTaskId == null) return;
  e.preventDefault();
  const targetId = Number(overCard.dataset.id);
  if (targetId === dragTaskId) return;
  const tasks = loadAll();
  const target = tasks.find(x => x.TASK_ID === targetId);
  const dragged = tasks.find(x => x.TASK_ID === dragTaskId);
  if (!target || !dragged) return;
  const sameStatus = target.TASK_STATUS === dragged.TASK_STATUS;
  const newStatus = target.TASK_STATUS;
  if (!sameStatus) moveToStatus(dragged.TASK_ID, newStatus);
  reorderWithinStatus(dragged.TASK_ID, target.TASK_ORDER);
  render();
});

// 새 작업 추가 폼 처리
 document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('newTaskForm');
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const content = document.getElementById('content').value.trim();
    const status = document.getElementById('status').value;
    const due = document.getElementById('due').value ? new Date(document.getElementById('due').value).toISOString() : '';
    const priority = document.getElementById('priority').value;
    if (!content) return;
    createTask({ content, status, due, priority });
    e.target.reset();
    render();
  });

  ensureSeed();
  render();
});

// 카드 수정 기능
function promptEdit(taskId) {
  const tasks = loadAll();
  const t = tasks.find(x => x.TASK_ID === taskId);
  if (!t) return;
  const content = prompt('내용을 수정하세요 (TASK_CONTENT):', t.TASK_CONTENT);
  if (content == null) return;
  const due = prompt('마감일 (YYYY-MM-DD):', t.DUE_DATE ? t.DUE_DATE.slice(0,10) : '');
  if (due == null) return;
  const priority = prompt('우선순위 (High|Medium|Low):', t.PRIORITY || 'Medium');
  if (priority == null) return;

  t.TASK_CONTENT = content.trim();
  t.DUE_DATE = due ? new Date(due).toISOString() : '';
  t.PRIORITY = (/^(High|Medium|Low)$/i.test(priority) ? priority[0].toUpperCase()+priority.slice(1).toLowerCase() : 'Medium');
  saveAll(tasks);
  render();
}
