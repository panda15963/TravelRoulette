document.addEventListener("DOMContentLoaded", function () {
    const body = document.getElementById("pageBody");
    const navbar = document.getElementById("mainNavbar");
    const toggleBtn = document.getElementById("modeToggle");           // Navbar 버튼
    const toggleBtnSidebar = document.getElementById("modeToggleSidebar"); // Sidebar 버튼

    // 현재 모드 적용 함수
    function applyMode(mode) {
        body.setAttribute("data-mode", mode);

        if (mode === "dark") {
            // Body
            body.style.backgroundColor = "#121212";
            body.style.color = "#eee";

            // 버튼
            [toggleBtn, toggleBtnSidebar].forEach(btn => {
                if (btn) {
                    btn.textContent = "☀️";
                    btn.classList.remove("btn-outline-dark");
                    btn.classList.add("btn-outline-warning");
                    btn.style.borderColor = "yellow";
                }
            });

            // Navbar
            if (navbar) {
                navbar.classList.remove("navbar-light", "bg-light");
                navbar.classList.add("navbar-dark", "bg-dark");
            }

            // Sidebar
            const sidebar = document.getElementById("sidebarMenu");
            if (sidebar) {
                sidebar.style.backgroundColor = "#212529";
                sidebar.style.color = "#fff";
                sidebar.querySelectorAll(".nav-link").forEach(link => {
                    link.style.color = "#fff";
                });
            }

            // About Section
            const aboutSection = document.getElementById("aboutSection");
            if (aboutSection) {
                aboutSection.style.backgroundColor = "#121212";
                aboutSection.style.color = "#eee";
            }

            // Board Section (다크 모드 → 카드 밝게)
            const boardSection = document.getElementById("boardSection");
            if (boardSection) {
                boardSection.style.backgroundColor = "#1e1e1e";
                boardSection.style.color = "#eee";
                boardSection.querySelectorAll(".card").forEach(card => {
                    card.style.backgroundColor = "#fff";   // 밝은 배경
                    card.style.color = "#000";             // 어두운 글씨
                    card.style.borderColor = "#ddd";
                });
                boardSection.querySelectorAll(".card .text-muted").forEach(el => {
                    el.style.color = "#555";
                });
            }

            // Intro Section (자기소개 페이지용, 다크 모드 → 카드 밝게)
            const introSection = document.getElementById("introSection");
            if (introSection) {
                introSection.style.backgroundColor = "#1e1e1e";
                introSection.style.color = "#eee";
                introSection.querySelectorAll(".card").forEach(card => {
                    card.style.backgroundColor = "#fff";   // 밝은 배경
                    card.style.color = "#000";             // 어두운 글씨
                    card.style.borderColor = "#ddd";
                });
            }

            // 구분선(hr)
            document.querySelectorAll("hr").forEach(hr => {
                hr.style.borderTop = "3px solid #bbb";
            });

        } else {
            // Body
            body.style.backgroundColor = "#fff";
            body.style.color = "#000";

            // 버튼
            [toggleBtn, toggleBtnSidebar].forEach(btn => {
                if (btn) {
                    btn.textContent = "🌙";
                    btn.classList.remove("btn-outline-warning");
                    btn.classList.add("btn-outline-dark");
                    btn.style.borderColor = "black";
                }
            });

            // Navbar
            if (navbar) {
                navbar.classList.remove("navbar-dark", "bg-dark");
                navbar.classList.add("navbar-light", "bg-light");
            }

            // Sidebar
            const sidebar = document.getElementById("sidebarMenu");
            if (sidebar) {
                sidebar.style.backgroundColor = "#fff";
                sidebar.style.color = "#000";
                sidebar.querySelectorAll(".nav-link").forEach(link => {
                    link.style.color = "#000";
                });
            }

            // About Section
            const aboutSection = document.getElementById("aboutSection");
            if (aboutSection) {
                aboutSection.style.backgroundColor = "#fff";
                aboutSection.style.color = "#000";
            }

            // Board Section (라이트 모드 → 카드 어둡게)
            const boardSection = document.getElementById("boardSection");
            if (boardSection) {
                boardSection.style.backgroundColor = "#f8f9fa"; // 연회색
                boardSection.style.color = "#000";
                boardSection.querySelectorAll(".card").forEach(card => {
                    card.style.backgroundColor = "#2a2a2a"; // 어두운 배경
                    card.style.color = "#f1f1f1";           // 밝은 글씨
                    card.style.borderColor = "#444";
                });
                boardSection.querySelectorAll(".card .text-muted").forEach(el => {
                    el.style.color = "#bbb";
                });
            }

            // Intro Section (자기소개 페이지용, 라이트 모드 → 카드 어둡게)
            const introSection = document.getElementById("introSection");
            if (introSection) {
                introSection.style.backgroundColor = "#fff";
                introSection.style.color = "#000";
                introSection.querySelectorAll(".card").forEach(card => {
                    card.style.backgroundColor = "#2a2a2a"; // 어두운 배경
                    card.style.color = "#f1f1f1";           // 밝은 글씨
                    card.style.borderColor = "#444";
                });
            }

            // 구분선(hr)
            document.querySelectorAll("hr").forEach(hr => {
                hr.style.borderTop = "3px solid #666";
            });
        }

        // localStorage 저장
        localStorage.setItem("themeMode", mode);
    }

    // 버튼 바인딩
    function bindToggle(btn) {
        if (!btn) return;
        btn.addEventListener("click", function () {
            const currentMode = body.getAttribute("data-mode");
            const newMode = currentMode === "dark" ? "light" : "dark";
            applyMode(newMode);
        });
    }

    bindToggle(toggleBtn);
    bindToggle(toggleBtnSidebar);

    // 저장된 모드 불러오기
    const savedMode = localStorage.getItem("themeMode") || "light";
    applyMode(savedMode);
});