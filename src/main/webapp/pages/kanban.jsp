<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../assets/favicon.ico?v=2" />
    <link href="../css/styles.css" rel="stylesheet"/>
    <link href="../css/features/kanban/kanban.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>

<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>
<header>
    <div class="wrap row">
      <h1>Kanban 보드 <small class="code"></small></h1>
    </div>
  </header>

  <main>
    <section class="board" id="board"></section>

    <form class="new-form" id="newTaskForm">
      <input class="full" type="text" id="content" placeholder="무엇을 할까요? (TASK_CONTENT)" required />
      <select id="status" title="상태">
        <option value="todo">todo</option>
        <option value="inprogress">inprogress</option>
        <option value="done">done</option>
      </select>
      <input type="date" id="due" />
      <select id="priority" title="우선순위">
        <option value="Medium">Medium</option>
        <option value="High">High</option>
        <option value="Low">Low</option>
      </select>
      <button class="primary" type="submit">카드 추가</button>
    </form>
  </main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/features/darkmode.js"></script>
<script src="../js/utils/authManager.js"></script>
<script src="../js/features/kanban_fetch.js"></script>
<script>
    // 칸반 페이지는 로그인 필수
    document.addEventListener('DOMContentLoaded', function() {
        AuthManager.requireLogin();
    });
</script>
</body>
</html>
