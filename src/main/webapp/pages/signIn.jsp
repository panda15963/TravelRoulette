<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign In</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet" />

    <style>
        /* --- 기본 Body 스타일 --- */
        body {
            /* 네비게이션 바가 fixed-top 이므로, 컨텐츠가 겹치지 않게 body 위쪽에 충분한 공간을 확보합니다. */
            padding-top: 10rem;
            padding-bottom: 2rem; /* 스크롤 시 하단 여백 */
            padding-left: 1rem;   /* 좌우 여백 */
            padding-right: 1rem;  /* 좌우 여백 */
        }

        /* --- 로그인 컨테이너 스타일 --- */
        .signin-container {
            width: 100%;
            max-width: 500px;
            /* [핵심] margin의 좌우 값을 auto로 주어 컨테이너를 항상 수평 중앙에 위치시킵니다. */
            margin: 0 auto;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid #ccc;
            background-color: #fff;
        }

        /* --- 폼 내부 요소 스타일 --- */
        .signin-container h2 {
            margin-bottom: 20px;
            text-align: center;
        }

        .signin-container input[type="text"],
        .signin-container input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .signin-container button {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 6px;
            background-color: skyblue;
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .signin-container button:hover {
            background-color: blue;
        }

        .error-message {
            color: red;
            margin-bottom: 15px;
            font-size: 0.9rem;
            text-align: center;
        }
        
        /* --- 다크 모드 스타일 --- */
        body[data-mode="dark"] {
            background-color: #121212;
            color: #eee;
        }
        
        body[data-mode="dark"] .signin-container {
            background-color: #1e1e1e;
            border: 1px solid #444;
            color: #eee;
        }

        body[data-mode="dark"] .signin-container input[type="text"],
        body[data-mode="dark"] .signin-container input[type="password"] {
            background-color: #212121;
            color: #eee;
            border: 1px solid #555;
        }

        /* --- [핵심] 반응형 디자인 --- */
        @media (max-width: 768px) {
            body {
                padding-top: 8rem;
            }
            .signin-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body id="pageBody" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<!-- Sign In 내용 -->
<div class="signin-container">
    <h2>로그인</h2>
          
        <% if ("login_fail".equals(request.getParameter("error"))) { %>
            <div class="error-message">아이디 또는 비밀번호가 일치하지 않습니다.</div>
        <% } %>
			<form name="signinForm">
<%--         <form name="signinForm" action="${pageContext.request.contextPath}/LoginServlet" method="post">
 --%>            
            <input type="hidden" name="action" value="signin">
            
            <input type="text" name="userId" placeholder="아이디를 입력해주세요." required>
            <input type="password" name="userPassword" placeholder="비밀번호를 입력해주세요." required>
            
            <button type="submit">로그인</button>
        </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>

<script defer src="${pageContext.request.contextPath}/js/signUpAndValidate.js"></script>

</body>
</html>
