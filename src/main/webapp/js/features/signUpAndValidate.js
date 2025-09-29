window.onload = function() {

    const loggedInUserJson = sessionStorage.getItem('loggedInUser');

    // 회원가입
    const signupForm = document.forms.signupForm;
    if (signupForm) {
        signupForm.addEventListener('submit', function(event) {
            event.preventDefault(); // 서버로 바로 보내는 것을 일단 막음

            const userId = document.getElementById('userId').value;
            const userPassword = document.getElementById('userPassword').value;
            const passwordChk = document.getElementById('passwordChk').value;
            const email = document.getElementById('email').value;
            const name = document.getElementById('name').value;
            const address = document.getElementById('address').value;
            const gender = signupForm.gender.value;

            if (userPassword !== passwordChk) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }
            if (!email.includes('@') || !email.includes('.')) {
                alert('이메일 주소는 @와 .을 포함하는 유효한 형식이어야 합니다.');
                return;
            }
            if (!address.includes('시')) {
                alert('주소는 "~시"와 같이 "시"를 포함해야 합니다.');
                return;
            }

            // 로컬 스토리지 기존 회원 목록 가져오기
            let userList = JSON.parse(localStorage.getItem('travelRouletteUsers'));
            if (userList == null) {//없다면
                userList = [];
            }

            // 중복 확인
            for (let i = 0; i < userList.length; i++) {
                if (userList[i].userId === userId) {
                    alert('이미 사용 중인 아이디입니다.');
                    return;
                }
                if (userList[i].email === email) {
                    alert('이미 등록된 이메일입니다.');
                    return;
                }
            }

            const newUser = {
                userId: userId,
                password: userPassword,
                email: email,
                name: name,
                address: address,
                gender: gender
            };
            userList.push(newUser);
            localStorage.setItem('travelRouletteUsers', JSON.stringify(userList));

            alert('회원가입 성공!');
            window.location.href = 'signIn.jsp';
        });
    }


    // 로그인
    const signinForm = document.forms.signinForm;
    if (signinForm) {
        signinForm.addEventListener('submit', function(event) {
            event.preventDefault();
            const userId = signinForm.userId.value;
            const userPassword = signinForm.userPassword.value;
            const userList = JSON.parse(localStorage.getItem('travelRouletteUsers'));

            let loginSuccess = false;
            let loggedInUser = null;

            if (userList) {
                for (let i = 0; i < userList.length; i++) {
                    if (userList[i].userId === userId && userList[i].password === userPassword) {
                        loginSuccess = true;
                        loggedInUser = userList[i];
                        break;
                    }
                }
            }

            if (loginSuccess) {
                // 1. 세션 스토리지에 정보 저장
                sessionStorage.setItem('loggedInUser', JSON.stringify(loggedInUser));

                // 2. JSP에 있는 모달 HTML 요소들을 가져오기
                const loginModalElement = document.getElementById('loginSuccessModal');
                const welcomeMessageElement = document.getElementById('modal-welcome-message');
                const confirmButton = document.getElementById('modal-confirm-button');

                // 3. 모달 창에 환영 메시지 채우기
                welcomeMessageElement.textContent = loggedInUser.name + '님 환영합니다.';

                // 4. 부트스트랩 JS를 이용해 모달 인스턴스를 만들고 화면에 보여주기
                const loginModal = new bootstrap.Modal(loginModalElement);
                loginModal.show();

                // 5. 모달의 '확인' 버튼에 클릭 이벤트 추가
                confirmButton.addEventListener('click', function() {
                    // 확인 버튼을 누르면 index.jsp 페이지로 이동
                    window.location.href = CONTEXT_PATH + '/index.jsp';
                });

            } else {
                alert('아이디 또는 비밀번호가 틀렸습니다.');
            }
        });
    }
};