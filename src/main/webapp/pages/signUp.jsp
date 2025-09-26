<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet"/>

    <style>
        /* --- 기본 Body 스타일 --- */
        body {
            padding-top: 10rem;
            padding-bottom: 2rem;
            padding-left: 1rem;
            padding-right: 1rem;
        }

        /* --- 회원가입 컨테이너 스타일 --- */
        .signup-container {
            width: 100%;
            max-width: 680px;
            margin: 0 auto;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid #ccc;
            background-color: #fff;
        }

        /* --- 폼 내부 요소 스타일 --- */
        .signup-container h2 { margin-bottom: 20px; text-align: center; }
        .signup-container input[type="text"],
        .signup-container input[type="password"],
        .signup-container input[type="email"] {
            width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ccc;
            border-radius: 6px; box-sizing: border-box; font-size: 16px;
        }
        .signup-container .radio-group { display: flex; justify-content: center; width: 100%; margin-bottom: 15px; }
        .signup-container .radio-group label { margin: 0 10px; }
        .signup-container .terms-checkbox { display: flex; align-items: center; justify-content: center; width: 100%; margin-bottom: 20px; }
        .signup-container .terms-checkbox input { margin-right: 10px; }
        .signup-container button {
            width: 100%; padding: 15px; border: none; border-radius: 6px;
            background-color: skyblue; color: white; font-size: 18px;
            cursor: pointer; transition: background-color 0.3s;
        }
        .signup-container button:hover { background-color: blue; }
        .error-message { color: red; margin-bottom: 15px; font-size: 0.9rem; text-align: center; }

        /* --- 다크 모드 스타일 --- */
        body[data-mode="dark"] {
            background-color: #121212;
            color: #eee;
        }
        body[data-mode="dark"] .signup-container {
            background-color: #1e1e1e; border: 1px solid #444; color: #eee;
        }
        body[data-mode="dark"] .signup-container input[type="text"],
        body[data-mode="dark"] .signup-container input[type="password"],
        body[data-mode="dark"] .signup-container input[type="email"] {
            background-color: #212121; color: #eee; border: 1px solid #555;
        }

        /* --- 반응형 디자인 --- */
        @media (max-width: 768px) {
            body {
                padding-top: 8rem;
            }
            .signup-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body id="pageBody" data-mode="light">

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
    <form name="signupForm">
    <%-- <form name="signupForm" action="${pageContext.request.contextPath}/LoginServlet" method="post"> --%>
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
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>

<script defer src="${pageContext.request.contextPath}/js/signUpAndValidate.js"></script>

</body>
</html>
