<%@ page contentType = "text/html;charset=UTF-8" language = "java" %>
<html>
<head>
    <title>Sign Up</title>
    <script type=text/javascript>
    	/*
         로그인창 색상 노란색넣은거 시인성용임(박스 확인)
    	
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
<body>
	<div class="signup-container">
        <h2>회원가입</h2>
        <form name="signupForm" action="#" method="post">
            <input type="text" name="userId" id="userId" placeholder="아이디를 입력해주세요." required>
            <input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요." required>
            <input type="email" name="email" id="email" placeholder="이메일 주소를 입력해주세요." required>
            <input type="text" name="name" id="name" placeholder="이름을 입력해주세요." required>
            <input type="text" name="address" id="address" placeholder="주소를 입력해주세요." required>

            <div class="radio-group">
                <input type="radio" id="male" name="gender" value="male">
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
	 
	 
	 	
</body>
</html>
