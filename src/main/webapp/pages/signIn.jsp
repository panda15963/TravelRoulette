<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Sign In</title>
	<link href="../css/styles.css" rel="stylesheet" />
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script type="text/javascript">
        /*
         로그인창 색상 노란색 넣은거 시인성용임(박스 확인)
        임시css 스크립트 공간
        */
    </script>
	
	<style> 
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f0f0f0;
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
            background-color: yellow;
        }

        .signin-container h2 {
            margin-bottom: 20px;
            color: black;
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
    <form name="signinForm" action="#" method="post">
        <input type="text" name="userId" id="userId" placeholder="아이디를 입력해주세요." required>
        <input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요." required>
        
        <button type="submit">로그인</button>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/darkmode.js"></script>
</body>
</html>
