

(function() {
    'use strict';

    const tbody = document.getElementById('rows'); //목록이 들어갈 <tbody>
    const countEl = document.getElementById('count'); //글 개수
    const qEl = document.getElementById('q'); //검색 입력
    const sortEl = document.getElementById('sort'); //정렬 select
    const clearBtn = document.getElementById('clear'); //지우기 버튼
    const writeBtn = document.getElementById('writeBtn'); //글쓰기 버튼
    const viewDialog = document.getElementById('viewDialog');
    const viewMount = document.getElementById('viewMount');
    const writeDialog = document.getElementById('writeDialog');
    const writeMount = document.getElementById('writeMount');
    const toastEl = document.getElementById('toast');

    if (!tbody) return; //tbody 없으면 중단


    const KEY = 'posts';

    //XSS 방지
    const escapeHtml = (s) => {
        s = String(s == null ? '' : s); //null/undefined 방어
        return s.replace(/[&<>"']/g, (m) => { //특수문자 찾기
            const map = { '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;' };
            return map[m]; //HTML 엔티티로 치환
        });
    };

    //날짜 형식
    const formatDate = (iso) => {
        const d = new Date(iso); //문자열을 DAte객체로
        if(isNaN(d.getTime())) return ''; //잘못된 날짜면 빈 문자열로

        const z = (n) => String(n).padStart(2, '0'); //두 자리 0 채우기

        return d.getFullYear() + '-' + z(d.getMonth()+1) + '-' + z(d.getDate()) + ' ' + z(d.getHours()) + ':' + z(d.getMinutes());
    };

    let toastTid = null;
    const showToast = (msg) => {
        if(!toastEl) {
            alert(msg);
            return;
        }
        toastEl.textContent = msg;
        toastEl.hidden = false; //숨김 해제(보여주기)
        if(toastTid) clearTimeout(toastTid); //이전 타이머 취소
        toastTid = setTimeout(() => {
            toastEl.hidden = true; //숨기기
        }, 1500); //1.5초 후

    };



    //글 목록
    let posts = (function(){
        try{
            const raw = localStorage.getItem('posts');
            return raw ? JSON.parse(raw) : [];
        }catch(e) {
            return [];
        }
    })();

    let query = ''; //검색어
    let sortKey = 'new'; //정렬 기준

    //저장
    const save = () => {
        localStorage.setItem(KEY, JSON.stringify(posts));
    };


    //글 목폭 화면
    const renderList = () => {

        let data= posts.slice();

        //검색(대소문자 무시)
        if(query) {
            const q = query.toLowerCase();
            data = data.filter((p) => {
                const t = (p.title || '').toLowerCase();
                const a = (p.author || '').toLowerCase();
                const c = (p.content || '').toLowerCase();
                return t.includes(q) || a.includes(q) || c.includes(q);
            });


        }

        //정렬
        const cmpMap = {
            new: (a,b) => b.id-a.id,
            old: (a,b) => a.id-b.id,
            //title: (a,b) => a.title.localeCompare(b.title, 'ko'),
            title: (a,b) => a.title.localeCompare(b.title, 'ko', {sensitivity:'base'}) || (b.id - a.id),
            author: (a,b) => a.author.localeCompare(b.author, 'ko', {sensitivity:'base'}) || (b.id - a.id)
        };
        const cmp = cmpMap[sortKey] || cmpMap.new;
        data.sort(cmp);



        //글 개수 갱신
        if (countEl) countEl.textContent = String(data.length);

        //비어있을 때
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="muted">등록된 글이 없습니다.</td></tr>';
            return;
        }

        //최신순 정렬
        //const data = posts.slice().sort((a,b) => b.id - a.id);

        //문자열로 렌더
        let html = '';
        for(let i=0; i<data.length; i++){
            const p = data[i];
            const no = data.length - i; //글 번호
            html += '<tr data-id="' + p.id + '">'
                + '<td>' + no + '</td>'
                + '<td>' + escapeHtml(p.title) + '</td>'
                + '<td>' + escapeHtml(p.author) + '</td>'
                + '<td>' + formatDate(p.createdAt) + '</td>'
                + '<td>'

                + '<button id="viewBtn" type="button" class="btn btn-outline-secondary" data-action="view">보기</button> '
                + '<button id="removeBtn" type="button" class="btn btn-outline-secondary" data-action="remove">삭제</button>'

                + '</td>'
                + '</tr>';
        }
        tbody.innerHTML = html;
    };





    //검색
    if(qEl) {
        qEl.addEventListener('input', (e) => {
            query = (e.target.value || '').trim();
            renderList();

        });
    }

    //정렬
    if(sortEl) {
        sortEl.addEventListener('change', (e) => {
            sortKey = e.target.value;
            renderList();

        });
    }

    //지우기
    if(clearBtn) {
        clearBtn.addEventListener('click', () => {
            if (qEl) qEl.value = '';
            query = '';
            renderList();
        });
    }






    tbody.addEventListener('click', (e) => {
        //어떤 버튼이 눌렸는지 찾기
        let node = e.target;
        let btn = null;
        while(node && node !== tbody) {
            if(node.matches && node.matches('button[data-action]')) {
                btn = node;
                break;
            }
            node = node.parentNode;
        }
        if(!btn) return; //버튼이 아니면 무시

        //클릭한 버튼이 속한 <tr> 찾기
        node = e.target;
        let tr = null;
        while(node && node !== tbody) {
            if(node.tagName && node.tagName.toLowerCase()==='tr'){
                tr = node;
                break;
            }
            node = node.parentNode;
        }
        if(!tr) return;

        //글 식별
        const id = Number(tr.getAttribute('data-id'));
        const item = posts.find((p) => p.id === id);
        if(!item) return;

        const action = btn.getAttribute('data-action');
        //보기: 모달로 보여주기
        if(action==='view') openView(item);
        //삭제
        else if(action === 'remove') {
            const ok = confirm('삭제하시겠습니까?'); //삭제 재확인
            if(ok){
                posts = posts.filter((p) => p.id !== id); //현재 글 제외
                //localStorage.setItem('posts', JSON.stringify(posts)); //저장
                save(); //저장(localStorage에 반영)
                renderList(); //재렌더
                showToast('삭제되었습니다.'); //토스트
            }

        }




    });



    // 보기 모달 열기 함수 (카드 제거, 담백한 레이아웃)
    const openView = (item) => {
        if (!viewDialog || !viewMount) {
            alert(
                '제목: ' + item.title + '\n' +
                '작성자: ' + item.author + '\n' +
                '작성일: ' + formatDate(item.createdAt) + '\n\n' +
                item.content
            );
            return;
        }

        const safeContent = escapeHtml(item.content || '').replace(/\r?\n/g, '<br>');

        const html = `
	    <div class="p-2 p-md-3">
	      <!-- 제목 -->
	      <h4 class="mb-2 fw-semibold">${escapeHtml(item.title || '')}</h4>

	      <!-- 작성자/작성일 -->
	      <div class="text-muted small mb-4 d-flex flex-wrap gap-3">
	        <span>작성자: ${escapeHtml(item.author || '')}</span>
	        <span>작성일: ${formatDate(item.createdAt)}</span>
	      </div>

	      <hr class="my-4">

	      <!-- 본문 -->
	      <div class="fs-6 lh-lg text-break">
	        ${safeContent}
	      </div>
	    </div>
	  `;

        viewMount.innerHTML = html;
        viewDialog.showModal();
    };


    let writeLoaded = false;

    //글쓰기 버튼 클릭 시 모달을 열어 폼 불러오기
    if(writeBtn && writeDialog && writeMount) {
        writeBtn.addEventListener('click', () => {
            if(!writeLoaded) {
                fetch('../../pages/board/postForm.html')
                    .then(function(res) {return res.text();})
                    .then(function(html) {
                        writeMount.innerHTML = html;
                        wireUpPostForm();
                        writeLoaded = true;
                        writeDialog.showModal();

                    })
                    .catch(function(err){
                        console.error(err);
                        alert('불러오기 실패');
                    });

            }else writeDialog.showModal();


        });



    }

    //form 이벤트 연결
    const wireUpPostForm = () => {
        const form = writeMount ? writeMount.querySelector('#postForm') : null;
        const cancelBtn = writeMount ? writeMount.querySelector('#cancelBtn') : null;
        if (!form) return;

        //제출
        form.addEventListener('submit', function(e){
            e.preventDefault();

            //값 읽기
            const title = ((form.title && form.title.value) || '').trim();
            const author = ((form.author && form.author.value) || '').trim();
            const content = ((form.content && form.content.value) || '').trim();

            if(!title || !author || !content) {
                showToast('모든 칸에 입력하세요.');
                return;
            }

            //새 글 객체 생성
            const item = {
                id: Date.now(),
                title: title,
                author: author,
                content: content,
                createdAt: new Date().toISOString()
            };


            posts.unshift(item);

            try {
                save();

            }catch(err) {
                console.error('저장 실패:', err);
                alert('저장 실패');
            }


            renderList();
            showToast('등록되었습니다.');

            form.reset();
            if(writeDialog) writeDialog.close();

        });

        if(cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                if (writeDialog) writeDialog.close();

            });
        }



    };





    //시작
    renderList();


})();