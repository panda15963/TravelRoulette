<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign Up</title>
    <link href="../css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <script type="text/javascript">
        /*
         로그인창 색상 노란색 넣은거 시인성용임(박스 확인)
        임시 css 스크립
        */
   window.onload()   
    
    const form = document.querySelector('form[name="signupForm"]');

    가입 버튼 클릭 등실행될 함수
    form.addEventListener('submit', function(event) {
        // 비밀번호와 비밀번호 확인 input 요소
        const password = document.getElementById('userPassword');
        const passwordCheck = document.getElementById('passwordChk');

        // 두 비밀번호의 값이 일치하지 않는 경우
        if (password.value !== passwordCheck.value) {
            
            alert('비밀번호가 일치하지 않습니다. 다시 확인해주세요.');
    
            event.preventDefault();
            
            // 비밀번호 필드를 비우기
            password.value = '';
            passwordCheck.value = '';

            // 비밀번호 필드에 커서
            password.focus();
        }
    });

    </script>

    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f0f0f0;
        }

        .signup-container {
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

        .signup-container h2 {
            margin-bottom: 20px;
            color: black;
        }

        .signup-container input[type="text"],
        .signup-container input[type="password"],
        .signup-container input[type="email"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid black;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .signup-container .radio-group {
            display: flex;
            justify-content: center;
            padding-left:10px;
            width: 100%;
            margin-bottom: 15px;
        }

        .signup-container .radio-group label {
            margin-right: 20px;
        }

        .signup-container .terms-checkbox {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            margin-bottom: 20px;
        }

        .signup-container .terms-checkbox input {
            margin-right: 10px;
        }

        .signup-container button {
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

        .signup-container button:hover {
            background-color: blue;
        }
    </style>
</head>
<body id="pageBody" class="d-flex flex-column h-100"
      style="background-color:#fff; color:#000;" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<!-- Sign Up Form -->
<div class="signup-container">
    <h2>회원가입</h2>
    
        <%-- 서버로부터 받은 에러 메시지 표시 --%>
    <% 
        String error = request.getParameter("error");
        String errorMessage = "";
        if (error != null) {
            switch (error) {
                case "id_duplicate":
                    errorMessage = "이미 사용 중인 아이디입니다.";
                    break;
                case "email_duplicate":
                    errorMessage = "이미 등록된 이메일입니다.";
                    break;
                case "validation_fail":
                    errorMessage = "입력 형식이 올바르지 않습니다.";
                    break;
            }
        }
    %>
    <% if (!errorMessage.isEmpty()) { %>
        <div class="error-message"><%= errorMessage %></div>
    <% } %>
    
    <form name="signupForm" action="${pageContext.request.contextPath}/LoginServlet" method="post">
    	<input type="hidden" name="action" value="signup">
        ID<input type="text" name="userId" id="userId" placeholder="아이디를 입력해주세요." required>
        비밀번호<input type="password" name="userPassword" id="userPassword" placeholder="비밀번호를 입력해주세요." required>
        비밀번호 확인<input type="password" name="passwordChk" id="passwordChk" placeholder="비밀번호를 입력해주세요." required>
        이메일<input type="email" name="email" id="email" placeholder="이메일 주소를 입력해주세요. ~ @ ~ . ~ 형식이어야합니다." required>
        이름<input type="text" name="name" id="name" placeholder="이름을 입력해주세요." required>
        주소<input type="text" name="address" id="address" placeholder="주소를 입력해주세요. ~시여야합니다." required>

        <div class="radio-group">
            <input type="radio" id="male" name="gender" value="male" checked>
            <label for="male">남성</label>
            <input type="radio" id="female" name="gender" value="female">
            <label for="female">여성</label>
        </div>

        <div class="terms-checkbox">
            <input type="checkbox" name="terms" id="terms" required>
            <label for="terms">회원가입에 동의하십니까?</label>
        </div>

        <button type="submit">가입</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../js/darkmode.js"></script>
</body>
</html>
