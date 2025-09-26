
window.onload = function() {
    
    const loggedInUserJson = sessionStorage.getItem('loggedInUser');
  
// 회원가입 페이지에서 가입 버튼을 눌렀을 때
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

        // 로컬 스토리지에서 기존 회원 목록 가져오기
        let userList = JSON.parse(localStorage.getItem('travelRouletteUsers'));
        if (userList == null) { // 회원 목록이 없으면 새로 만들기
            userList = [];
        }

        // 아이디나 이메일이 중복되는지 확인
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

        // 새 회원 정보 만들기
        const newUser = {
            userId: userId,
            password: userPassword,
            email: email,
            name: name,
            address: address,
            gender: gender
        };

        // 회원 목록에 새 회원 추가
        userList.push(newUser);
        // 로컬 스토리지에 저장
        localStorage.setItem('travelRouletteUsers', JSON.stringify(userList));

        alert('회원가입 성공!');
        window.location.href = 'signIn.jsp';
    });
}


// 로그인 페이지에서 로그인 버튼을 눌렀을 때
const signinForm = document.forms.signinForm;
if (signinForm) {
    signinForm.addEventListener('submit', function(event) {
        event.preventDefault(); // 서버로 바로 보내는 것을 일단 막음

        const userId = signinForm.userId.value;
        const userPassword = signinForm.userPassword.value;
        
        // 로컬 스토리지에서 회원 목록 가져오기
        const userList = JSON.parse(localStorage.getItem('travelRouletteUsers'));

        let loginSuccess = false;
        let loggedInUser = null;

        if (userList) {
            // 회원 목록에서 아이디와 비밀번호가 일치하는 사람 찾기
            for (let i = 0; i < userList.length; i++) {
                if (userList[i].userId === userId && userList[i].password === userPassword) {
                    loginSuccess = true;
                    loggedInUser = userList[i];
                    break;
                }
            }
        }
        
        if (loginSuccess) {
            // 로그인 성공 시, 세션 스토리지에 정보 저장
            sessionStorage.setItem('loggedInUser', JSON.stringify(loggedInUser));
            alert(loggedInUser.name + '님 환영합니다.');
            window.location.href = CONTEXT_PATH + '/index.jsp'; 
        } else {
            alert('아이디 또는 비밀번호가 틀렸습니다.');
        }
    });
}}