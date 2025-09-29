<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Sign In</title>
	<link href="../css/styles.css" rel="stylesheet" />
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

	<style> 
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;

        }

        .signin-container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            width: 680px;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid black;

        }

        .signin-container h2 {
            margin-bottom: 20px;

        }

        .signin-container input[type="text"],
        .signin-container input[type="password"]
        {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid black;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }
        body[data-mode="dark"] .signin-container input[type="text"],
        body[data-mode="dark"] .signin-container input[type="password"]
        {
            /* 입력 필드 배경색을 어두운 계열로 변경 */
            background-color: #212121;

            /* 글자색을 밝은 색으로 변경 */
            color: #eee;

            /* 테두리를 어두운 배경에서 잘 보이도록 밝은 회색 계열로 변경 */
            border: 1px solid #555;
        }
        body[data-mode="dark"] .signin-container {
            /* 배경색을 어둡게 설정 (body 배경보다 살짝 밝게) */
            background-color: #1e1e1e;

            /* 테두리를 밝은 색으로 설정 */
            border: 1px solid #444;

            /* 제목 및 컨테이너 내부 텍스트 색상을 밝게 설정 */
            color: #eee;
        }

        /* 다크 모드에서 버튼의 색상도 조정할 수 있습니다. */
        body[data-mode="dark"] .signin-container button {
            background-color: #007bff; /* 기본 버튼 색상 */
        }

        body[data-mode="dark"] .signin-container button:hover {
            background-color: #0056b3; /* 호버 색상 */
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
    </style>
	
	
	
</head>
<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<!-- Sign In 내용 -->
<div class="signin-container">
    <h2>로그인</h2>
          
        <% if ("login_fail".equals(request.getParameter("error"))) { %>
            <div class="error-message">아이디 또는 비밀번호가 일치하지 않습니다.</div>
        <% } %>

        <form name="signinForm" action="${pageContext.request.contextPath}/LoginServlet" method="post">
            
            <input type="hidden" name="action" value="signin">
            
            <input type="text" name="userId" placeholder="아이디를 입력해주세요." required>
            <input type="password" name="userPassword" placeholder="비밀번호를 입력해주세요." required>
            
            <button type="submit">로그인</button>
        </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/darkmode.js"></script>
<script defer src="../js/signUpAndValidate.js"></script>
<script type="text/javascript">
    const checkId = document.getElementsByName("userId");
    const checkPw = document.getElementsByName("userPassword");

    if (){

    }else
</script>


</body>
</html>
