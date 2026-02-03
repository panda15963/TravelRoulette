<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../../assets/favicon.ico?v=2" />
	<link href = "../../css/styles.css" rel = "stylesheet" />
	<!-- Bootstrap CSS -->
	<link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />

    <style>
        /*
        .playing-card: 개별 카드 외형 정의 클래스
        - 크기(120x170), 중앙 정렬(Flex), 글꼴(bold), 전환 애니메이션 등
        */
        .playing-card {
            width: 120px;
            height: 170px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            transition: all 0.2s ease; /* 마우스오버 등 스타일 변화가 있을 때 부드럽게 전환 */
        }

        /* 카드 내 등급(숫자/알파벳)을 크게 */
        .playing-card .rank {
            font-size: 32px;
        }

        /* 카드 내 무늬(♠ ♥ ♦ ♣) 표시 크기 */
        .playing-card .suit {
            font-size: 20px;
        }

        /* 빨간 무늬(♥, ♦) 강조 색상 */
        .red {
            color: #d43b3b;
        }

        /* 비활성화 상태를 흐리게 보이도록 하는 클래스 */
        .ghost {
            opacity: 0.2;
        }

        /* 버튼 묶음 정렬과 간격 */
        .button-group {
            margin-top: 1rem;
            display: flex;
            justify-content: center;
            gap: 1rem; /* 버튼 사이 여백 */
        }

        /*
        작은 화면(최대 576px)에서 레이아웃 깨짐 방지
        */
        @media ( max-width : 576px) {
            .playing-card {
                width: 90px;
                height: 130px;
            }
            .playing-card .rank {
                font-size: 24px;
            }
            .playing-card .suit {
                font-size: 16px;
            }
        }
    </style>

</head>
<body id = "pageBody" class = "d-flex flex-column h-100"
      style = "background-color:#fff; color:#000;" data-mode = "light">

<%@ include file = "/Common/navbar.jsp" %>
<%@ include file = "/Common/sidebar.jsp" %>

<!-- 프로필 상세 섹션 -->
<!-- 전체 레이아웃 컨테이너 -->
<div class="container my-4">
    <h1 class="mb-3 mt-5" >Red Dog</h1>
    <p class="text-muted">세 장의 카드를 이용한 간단한 카드게임</p>

    <!-- 메인 카드(박스) 영역: 게임판, 버튼, 상태를 담음 -->
    <div class="card p-3">
        <!-- 카드 3장 배치 영역-->
        <div class="d-flex justify-content-center gap-3 flex-wrap mb-3"
             id="cards">
            <!-- 카드 초기 상태: .card + .playing-card + .ghost -->
            <div class="card playing-card ghost" id="c1">
                <div class="rank">?</div>
                <div class="suit">?</div>
            </div>
            <div class="card playing-card ghost" id="c2">
                <div class="rank">?</div>
                <div class="suit">?</div>
            </div>
            <div class="card playing-card ghost" id="c3">
                <div class="rank">?</div>
                <div class="suit">?</div>
            </div>
        </div>

        <!-- 게임 조작 버튼 -->
        <div class="button-group">
            <!-- 새 라운드: 첫 번째/두 번째 카드 뽑기 -->
            <button id="btnNew" class="btn btn-primary">새 라운드</button>
            <!-- 세 번째 카드: 상황에 따라 활성화 -->
            <button id="btnThird" class="btn btn-secondary" disabled>세
                번째 카드</button>
            <!-- 다시 시작: 저장된 상태를 지우고 완전 초기화 -->
            <button id="btnReset" class="btn btn-outline-danger">다시 시작</button>
        </div>

        <!-- 결과 메시지: 매 라운드의 설명, 결과 -->
        <div id="result" class="alert alert-dark mt-3">결과 메시지가 여기에
            표시됩니다.</div>

        <!-- 요약 수치 표시: 남은 카드 수, 라운드 수, 승/패/무 누적 -->
        <div class="row text-center mt-3">
            <div class="col">
                <div class="fw-bold">남은 카드</div>
                <div id="remain">52</div>
            </div>
            <div class="col">
                <div class="fw-bold">라운드</div>
                <div id="rounds">0</div>
            </div>
            <div class="col">
                <div class="fw-bold">승 / 패 / 무승부</div>
                <div id="wlp">0 / 0 / 0</div>
            </div>
        </div>

        <!-- 현재 상태 안내 -->
        <div id="status" class="text-muted mt-2">새 라운드를 눌러 시작하세요.</div>
    </div>

    <!-- 서버의 현재 시간 출력 -->
    <div class="mt-3 text-muted">
        서버 시간:
        <%=new java.util.Date()%></div>
</div>

<!-- 게임 종료 시 표시되는 결과 모달 -->
<div class="modal fade" id="gameModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg rounded-3">
            <div class="modal-body text-center">
                <p class="fs-4 fw-semibold mb-3">게임 결과</p>

                <!-- 최종 점수(승-패) 표시 -->
                <div id="modalResult" class="display-3 fw-bold text-primary py-3"></div>

                <!-- 세부 기록(승, 패, 무승부) 표시 -->
                <p id="modalStats" class="mt-2 text-muted small"></p>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <!-- 모달 닫기 + 새 게임 시작(저장 초기화 후 initGame 호출) -->
                <button type="button" id="modalOk" class="btn btn-primary w-100"
                        data-bs-dismiss="modal">새 게임 시작하기</button>
            </div>
        </div>
    </div>
</div>




<script>

    /* 카드 구성 */

    //가능한 랭크(등급)와 수트(무늬) 정의
    const ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];
    const suits = ['♠','♥','♦','♣'];

    //랭크 문자를 숫자 값으로 매핑
    //'2' -> 2, ... , 'A' -> 14
    const valueOf = r => ranks.indexOf(r) + 2;

    //하트와 다이아를 빨간색으로 표시하기 위한 함수
    const isRed   = s => (s === '♥' || s === '♦');

    //덱 생성(52장)
    function buildDeck() {
        const d = [];
        //카드 객체 생성
        for(const s of suits) for(const r of ranks) d.push({
            rank:r,
            value:valueOf(r),
            suit:s
        });
        return d;
    }

    //카드 셔플
    function shuffle(a) {
        for(let i=a.length-1; i>0; i--) {
            const j = Math.floor(Math.random()*(i+1));
            [a[i],a[j]] = [a[j],a[i]];

        }
        return a;
    }



    /* 게임 상태 변수들 */

    let deck; //카드 슬롯
    let first //첫 번째 카드
    let second; //두 번째 카드
    let third; //세 번쨰 카드
    let rounds; //총 라운드 수
    let wins; //승리 수
    let losses; //패배 수
    let pushes; //무승부 수
    let canDrawThird; //세 번째 카드 뽑기 가능 여부
    let pairMode; //페어 규칙 모드
    let gameOver; //게임 종료 여부

    //상태 및 결과 메시지 반영
    const setStatus = msg => { document.querySelector('#status').textContent = msg; };
    const setResult = msg => { document.querySelector('#result').textContent = msg; };

    //단일 카드 박스를 주어진 데이터로 그리기
    const paintCard=(id,card) => {
        const el = document.getElementById(id),
            r = el.querySelector('.rank'),
            s = el.querySelector('.suit');
        if(card){
            el.classList.remove('ghost'); //실제 카드가 생기면 비활성화 효과 제거
            r.textContent = card.rank;
            s.textContent = card.suit;
            s.classList.toggle('red',isRed(card.suit)); //빨간 무늬면 .red 클래스 적용
        }
        else{
            el.classList.add('ghost'); //카드가 없으면 비활성화
            r.textContent = '?'; //숨김 상태 표시
            s.textContent = '?';
            s.classList.remove('red'); //색상 초기화
        }
    };

    //화면 전체 요약 정보를 현재 상태 값으로 갱신
    const refreshUI = () => {
        //3개의 카드 칸을 현재 first/second/third 값으로
        paintCard('c1',first);
        paintCard('c2',second);
        paintCard('c3',third);

        //남은 카드 수, 라운드 수, 승/패/무 표시
        document.querySelector('#remain').textContent = deck.length;
        document.querySelector('#rounds').textContent = rounds;
        document.querySelector('#wlp').textContent = wins + " / " + losses + " / " + pushes;

        //세 번째 카드 버튼은 조건이 충족될 때만 활성화
        document.querySelector('#btnThird').disabled = !canDrawThird||gameOver;

        //게임 종료 시 새 라운드 버튼 비활성화
        document.querySelector('#btnNew').disabled = gameOver;
    };

    //현재 진행 중인 게임 상태를 브라우저 localStorage에 저장
    const saveState = () => {
        const state = {deck,first,second,third,rounds,wins,losses,pushes,canDrawThird,pairMode,gameOver};
        localStorage.setItem("redDogState", JSON.stringify(state));
    };

    //저장된 상태가 있으면 불러오고, 없으면 초기화
    const loadState = () => {
        const saved = localStorage.getItem("redDogState");
        if(saved) {
            try {
                const s=JSON.parse(saved);
                //저장된 값들을 현재 변수에 복원
                deck=s.deck;
                first=s.first;
                second=s.second;
                third=s.third;
                rounds=s.rounds;
                wins=s.wins;
                losses=s.losses;
                pushes=s.pushes;
                canDrawThird=s.canDrawThird;
                pairMode=s.pairMode;
                gameOver=s.gameOver;
                refreshUI();
                setStatus(gameOver ? "게임이 종료된 상태입니다." : "저장된 게임을 불러왔습니다.");
            }catch(e) {
                //초기화
                initGame();
            }
        }else {
            initGame();
        }
    };

    //새 게임(새 덱)으로 완전 초기화
    function initGame() {
        deck = shuffle(buildDeck()); //52장 셔플
        //화면의 3장 슬롯 비움
        first = null;
        second = null;
        third = null;

        //통계 및 플래그 초기값 설정
        rounds = 0;
        wins = 0;
        losses = 0;
        pushes = 0;
        canDrawThird = false;
        pairMode = false;
        gameOver = false;

        setStatus('새 라운드를 눌러 시작하세요.');
        setResult('게임이 초기화됐습니다.');

        refreshUI();
        saveState();
    }

    //다음 행동을 위해 덱에 카드가 충분한지 확인
    //부족하면 게임을 종료하고 모달 보여주기
    const checkDeck = (n=3) => {
        if(deck.length<n) {
            gameOver = true;
            const score = wins-losses; //점수 계산: 승 수 - 패 수

            //모달의 결과 및 통계 텍스트 채우기
            document.getElementById("modalResult").textContent = "최종점수: " + score + "점";
            document.getElementById("modalStats").textContent = "승:" + wins + ", 패:" + losses + ", 무승부:" + pushes;

            //모달 생성 및 보여주기
            const modal = new bootstrap.Modal(document.getElementById("gameModal"));
            modal.show();

            refreshUI();
            saveState();
            return false; //진행 불가
        }
        return true; //진행 가능
    };

    //새 라운드를 시작: 첫 번째, 두 번째 카드를 뽑고 상황에 따라 처리
    function newRound(){
        if(gameOver) return; //종료된 상태면 무시
        if(!checkDeck(3)) return; //3장 미만이면 종료 모달 표시 후 중단

        // 첫 번째, 두 번째 카드를 덱에서 꺼내기
        first = deck.pop();
        second = deck.pop();
        third = null; //세 번째 카드는 아직모름

        //초기 플래그 설정
        canDrawThird = false;
        pairMode = false;

        //페어(같은 랭크)인 경우
        if(first.value === second.value) {
            pairMode = true; //페어 규칙 발동
            canDrawThird = true; //세 번째 카드를 반드시 확인해야 결과가 나옴
            setStatus('페어! 세 번째 카드를 확인하세요.');
            setResult("초기 카드: " + first.rank + first.suit + ", " + second.rank + second.suit + " (페어)");
        }else if(Math.abs(first.value-second.value) === 1) {
            //연속(값 차가 1)인 경우: 사이 값이 존재하지 않으므로 무승부 확정
            rounds++; //라운드 수 증가
            pushes++; //무승부
            setStatus('연속 → 무승부!');
            setResult("초기 카드: " + first.rank + first.suit + ", " + second.rank + second.suit + " → 무승부");
        }else {
            //일반적인 경우: 세 번째 카드를 뽑아 사이에 들어오는지로 승패 결정
            canDrawThird = true; //세 번쨰 카드 버튼 활성화
            setStatus('세 번째 카드를 뽑으세요.');
            setResult("초기 카드: " + first.rank + first.suit + ", " + second.rank + second.suit);
        }

        refreshUI();
        saveState();
    }

    //세 번째 카드를 뽑아 최종 승/패/무를 결정
    function drawThird() {
        if(!canDrawThird||gameOver) return; //뽑을 수 없는 상태면 중단

        third = deck.pop(); //세 번째 카드 오픈
        rounds++; //라운드 수 증가

        if(pairMode) {
            //페어 상태에서 세 번째 카드가 같은 랭크면 트리플(승리), 아니면 무승부
            if(third.rank === first.rank) {
                wins++;
                setStatus('트리플! 승리!');
                setResult("세 번째 카드: " + third.rank + third.suit + " → 트리플");
            }else {
                pushes++;
                setStatus('트리플 실패 → 무승부');
                setResult("세 번째 카드: " + third.rank + third.suit + " → 무승부");
            }
        }else {
            //세 번째 카드가 첫/둘 사이 값이면 승리, 아니면 패배
            const lo = Math.min(first.value,second.value);
            const hi = Math.max(first.value,second.value);

            if(third.value>lo && third.value<hi){
                wins++;
                setStatus('승리!');
                setResult("세 번째 카드: " + third.rank + third.suit + " → 사이");
            }
            else {
                losses++;
                setStatus('패배…');
                setResult("세 번째 카드: " + third.rank + third.suit + " → 범위 밖");
            }
        }

        canDrawThird = false; //같은 라운드에서 더 이상 카드를 뽑지 않도록 제한
        refreshUI();
        saveState();
        checkDeck(); //다음 라운드를 진행할 수 있는지 확인(부족하면 종료 모달)



    }


    /* 이벤트 바인딩: 버튼/모달 동작 연결 */

    document.querySelector('#btnNew').addEventListener('click', newRound);
    document.querySelector('#btnThird').addEventListener('click', drawThird);

    //다시 시작: 저장 상태를 비우고 완전 초기화
    document.querySelector('#btnReset').addEventListener('click', () => {
        localStorage.removeItem("redDogState");
        initGame();
    });

    //모달 확인 버튼: 모달을 닫으면서 새 게임 시작
    document.querySelector('#modalOk').addEventListener('click', () => {
        localStorage.removeItem("redDogState");
        initGame();
    });

    //페이지 로드하면 저장된 게임 불러오기
    window.addEventListener("load", loadState);
</script>

<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src = "../../js/features/darkmode.js"></script>
</body>
</html>