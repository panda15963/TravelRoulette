<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/features/sign/signStyle.css" rel="stylesheet"/>
</head>
<body id="pageBody" class="sign-page-body" data-mode="light">

<%@ include file="/common/navbar.jsp" %>
<%@ include file="/common/sidebar.jsp" %>

<div class="sign-container signup-container">
    <h2>회원가입</h2>

    <%
        String error = request.getParameter("error");
        String errorMessage = "";
        if (error != null) {
            switch (error) {
                case "id_duplicate": errorMessage = "이미 사용 중인 아이디입니다."; break;
                case "email_duplicate": errorMessage = "이미 등록된 이메일입니다."; break;
                case "validation_fail": errorMessage = "입력 형식이 올바르지 않습니다."; break;
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
        이메일<input type="email" name="email" id="email" placeholder="이메일 주소를 입력해주세요." required>
        이름<input type="text" name="name" id="name" placeholder="이름을 입력해주세요." required>
        주소<input type="text" name="address" id="address" placeholder="주소를 입력해주세요." required>

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
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/auth.js"></script>
<script defer src="${pageContext.request.contextPath}/js/features/signUpAndValidate.js"></script>
</body>
</html>