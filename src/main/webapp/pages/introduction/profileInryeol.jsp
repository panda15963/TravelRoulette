<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<html>
<head>
	<title>Inryeol's Profile</title>
	<link href = "../../css/styles.css" rel = "stylesheet" />
	<!-- Bootstrap CSS -->
	<link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />
	<style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #fff;
      color: #333;
    }

    .container {
      display: flex;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
      gap: 20px; /* 좌우 간격 */
    }

    /* 왼쪽 영역 */
    .left {
      flex: 3;  /* 비율: 30% */
      padding: 20px;
      background-color: #f5f5f5;
      text-align: center;
    }
    .left img {
      width: 200px;
      border-radius: 12px;
    }
    .section {
      margin-top: 20px;
      text-align: left;
    }
    .section h3 {
      border-bottom: 2px solid #ccc;
      padding-bottom: 5px;
      margin-bottom: 10px;
    }

    /* 오른쪽 영역 */
    .right {
      flex: 7;  /* 비율: 70% */
      padding: 20px;
    }
    .block {
      margin-bottom: 30px;
    }
    .block h2 {
      color: #4a4aff;
      margin-bottom: 10px;
      border-bottom: 2px solid #ccc;
    }
    .block ul {
      list-style: none;
      padding: 0;
    }
    .block ul li {
      margin-bottom: 6px;
    }
    .block ul li::before {
      content: "•";
      color: rgb(0, 0, 0);
      font-size: 20px;
      margin-right: 10px;
    }

    .cert-date {
      font-size: 0.9em; /* 글씨 조금 작게 */
      color: #666;      /* 회색 */
      margin-left: 5px; /* 살짝 간격 */
    }

    /* 스킬 아이콘 */
    .skills {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }
    .skill-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      width: 100px;
    }
    .skill-icon {
      width: 40px;
      height: 40px;
      object-fit: contain;
    }

    /* 모달 공통 */
    .modal {
      display: none;
      position: fixed;
      z-index: 999;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
    }
    .modal-content {
      background-color: #fff;
      margin: 5% auto;
      padding: 20px;
      border-radius: 8px;
      width: 70%;
      max-width: 800px;
      text-align: center;
    }
    .close-btn {
      margin-top: 10px;
      padding: 8px 16px;
      background: #333;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
  </style>
</head>
<body id = "pageBody" class = "d-flex flex-column h-100"
      style = "background-color:#fff; color:#000;" data-mode = "light">

<%@ include file = "/common/navbar.jsp" %>
<%@ include file = "/common/sidebar.jsp" %>

<div class="container mt-5 pt-5">
    <!-- 왼쪽 -->
    <div class="left">
      <h1>CAREER</h1>
      <img src="../../images/skill_icon/profile.png" alt="프로필사진">
      <div class="section">
        <h3>개인 정보</h3>
        <p><strong>이름:</strong> 최인렬</p>
        <p><strong>생년월일:</strong> 1999년 10월 27일</p>
        <p><strong>이메일:</strong> zerg4572@naver.com</p>
        <p><strong>번호:</strong> 010-9286-4812</p>
        <p><strong>주소:</strong> 
          <!-- 주소 클릭 시 지도 모달 열기 -->
          <a href="#" onclick="openMapModal()">전라북도 익산시</a>
        </p>
        <p><strong>GitHub:</strong> 
          <a href="https://github.com/ryeol9999" target="_blank">
            <img src="../../images/skill_icon/Github-Dark.svg" alt="GitHub" style="width:18px; vertical-align:middle; margin-right:5px;">
            ryeol9999
          </a>
        </p>
      </div>
    </div>

    <!-- 오른쪽 -->
    <div class="right">
      <div class="block">
        <h2>자기소개</h2>
        <p>
          안녕하세요! 저는 컴퓨터정보통신공학을 전공한 최인렬입니다.<br>
          새로운 기술을 배우는 것을 좋아하며, 꾸준히 성장하는 개발자가 되고 싶습니다.<br>
          성실함과 책임감을 바탕으로 맡은 일에 최선을 다하겠습니다.
        </p>
      </div>
      <div class="block">
        <h2>학력과 교육이력</h2>
        <ul>
          <li>2015~2018 고등학교 졸업</li>
          <li>2018~2024 대학교 졸업 </li>
        </ul>
      </div>

      <div class="block">
        <h2>프로젝트</h2>
        <ul>
          <li>
            <a href="#" onclick="openModal()">AI기반 면접 발표 서비스</a>
          </li>

        </ul>
      </div>

      <div class="block">
        <h2>자격증</h2>
        <ul>
            <li>정보처리기사 <span class="cert-date">(2023.11)</span></li>
            <li>SQLD <span class="cert-date">(2023.10)</span></li>
            <li>ADSP <span class="cert-date">(2024.11)</span></li>
        </ul>
      </div>

      <div class="block">
        <h2>스킬</h2>
        <div class="skills">
          <div class="skill-item">
            <img src="../../images/skill_icon/Java-Light.svg" alt="Java" class="skill-icon">
            <p>Java</p>
          </div>
          <div class="skill-item">
            <img src="../../images/skill_icon/Python-Light.svg" alt="Python" class="skill-icon">
            <p>Python</p>
          </div>
          <div class="skill-item">
            <img src="../../images/skill_icon/MySQL-Light.svg" alt="MySQL" class="skill-icon">
            <p>MySQL</p>
          </div>
          <div class="skill-item">
            <img src="../../images/skill_icon/Git.svg" alt="Git" class="skill-icon">
            <p>Git</p>
          </div>
          <div class="skill-item">
            <img src="../../images/skill_icon/JavaScript.svg" alt="JavaScript" class="skill-icon">
            <p>JavaScript</p>
          </div>
          <div class="skill-item">
            <img src="../../images/skill_icon/HTML.svg" alt="HTML" class="skill-icon">
            <p>HTML</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 지도 모달 -->
  <div id="mapModal" class="modal">
    <div class="modal-content">
      <h3>전라북도 익산시 위치</h3>
      <iframe
        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2283.9848141307357!2d126.95742555867753!3d35.94593515078568!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x35703fbd8caa302f%3A0x5b7dd6d2a92c32b7!2z64Ko7KSR64-ZIOq0keyLoO2UhOuhnOq3uOugiOyKpCDrjZTshLztirjroZw!5e0!3m2!1sko!2skr!4v1759299582637!5m2!1sko!2skr"
        width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy">
      </iframe>
      <br>
      <button class="close-btn" onclick="closeMapModal()">닫기</button>
    </div>
  </div>

  <!-- 기존 프로젝트 모달도 그대로 유지 -->
  <div id="projectModal" class="modal">
    <div class="modal-content">
      <h3>AI기반 면접 발표 서비스</h3>
      <p>발표자의 표정, 목소리, 언어를 분석해 점수를 제공하는 서비스입니다.</p>
      <img src="/pj1.png" alt="프로젝트 미리보기" width="20%">
      <img src="/pj2.png" alt="프로젝트 미리보기" width="20%">
      <a href="https://github.com/kt6-AI09-25/Aivle-09-25" target="_blank">
        <img src="/img/Github-Dark.svg" alt="GitHub 링크" style="width:30px; height:30px; vertical-align:middle;">
      </a><br>
      <button class="close-btn" onclick="closeProjectModal()">닫기</button>
    </div>
  </div>

<!-- 프로필 상세 섹션 -->

<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src = "../../js/darkmode.js"></script>
</body>
<script>
    // 지도 모달
    function openMapModal() {
      document.getElementById("mapModal").style.display = "block";
    }
    function closeMapModal() {
      document.getElementById("mapModal").style.display = "none";
    }

    // 프로젝트 모달
    function openModal() {
      document.getElementById("projectModal").style.display = "block";
    }
    function closeProjectModal() {
      document.getElementById("projectModal").style.display = "none";
    }

    // 배경 클릭시 닫기
    window.onclick = function(event) {
      const mapModal = document.getElementById("mapModal");
      const projectModal = document.getElementById("projectModal");
      if (event.target === mapModal) mapModal.style.display = "none";
      if (event.target === projectModal) projectModal.style.display = "none";
    };
  </script>
</html>