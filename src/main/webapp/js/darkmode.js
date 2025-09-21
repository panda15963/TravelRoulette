document.addEventListener("DOMContentLoaded", function () {
    const body = document.getElementById("pageBody");
    const navbar = document.getElementById("mainNavbar");
    const toggleBtn = document.getElementById("modeToggle");
    const toggleBtnSidebar = document.getElementById("modeToggleSidebar");
    const sidebar = document.getElementById("sidebarMenu");
    const aboutSection = document.getElementById("aboutSection");
    const boardSection = document.getElementById("boardSection");

    // 🎨 테마 스타일 정의
    const themeConfig = {
        dark: {
            body: { bg: "#121212", color: "#eee" },
            navbar: ["navbar-dark", "bg-dark"],
            sidebar: { bg: "#212529", color: "#fff", link: "#fff" },
            about: { bg: "#121212", color: "#eee" },
            board: { bg: "#1e1e1e", color: "#eee", cardBg: "#2a2a2a", border: "#444", muted: "#bbb" },
            hr: "3px solid #bbb",
            btn: { text: "☀️", remove: "btn-outline-dark", add: "btn-outline-warning", border: "yellow" }
        },
        light: {
            body: { bg: "#fff", color: "#000" },
            navbar: ["navbar-light", "bg-light"],
            sidebar: { bg: "#fff", color: "#000", link: "#000" },
            about: { bg: "#fff", color: "#000" },
            board: { bg: "#f8f9fa", color: "#000", cardBg: "#fff", border: "#ddd", muted: "#6c757d" },
            hr: "3px solid #666",
            btn: { text: "🌙", remove: "btn-outline-warning", add: "btn-outline-dark", border: "black" }
        }
    };

    // 공통: 버튼 스타일 업데이트
    function updateButtons(config) {
        [toggleBtn, toggleBtnSidebar].forEach(btn => {
            if (!btn) return;
            btn.textContent = config.text;
            btn.classList.remove(config.remove);
            btn.classList.add(config.add);
            btn.style.borderColor = config.border;
        });
    }

    // 공통: 섹션 색상 업데이트
    function updateSection(section, { bg, color }) {
        if (!section) return;
        section.style.backgroundColor = bg;
        section.style.color = color;
    }

    // 공통: 카드 스타일 업데이트
    function updateCards(section, { cardBg, border, muted }) {
        if (!section) return;
        section.querySelectorAll(".card").forEach(card => {
            card.style.backgroundColor = cardBg;
            card.style.borderColor = border;
        });
        section.querySelectorAll(".card .text-muted").forEach(el => {
            el.style.color = muted;
        });
    }

    // 현재 모드 적용
    function applyMode(mode) {
        const config = themeConfig[mode];
        body.setAttribute("data-mode", mode);

        // Body
        body.style.backgroundColor = config.body.bg;
        body.style.color = config.body.color;

        // 버튼
        updateButtons(config.btn);

        // Navbar
        if (navbar) {
            navbar.classList.remove(...themeConfig.dark.navbar, ...themeConfig.light.navbar);
            navbar.classList.add(...config.navbar);
        }

        // Sidebar
        if (sidebar) {
            sidebar.style.backgroundColor = config.sidebar.bg;
            sidebar.style.color = config.sidebar.color;
            sidebar.querySelectorAll(".nav-link").forEach(link => {
                link.style.color = config.sidebar.link;
            });
        }

        // About Section
        updateSection(aboutSection, config.about);

        // Board Section
        if (boardSection) {
            updateSection(boardSection, config.board);
            updateCards(boardSection, config.board);
        }

        // 구분선(hr)
        document.querySelectorAll("hr").forEach(hr => {
            hr.style.borderTop = config.hr;
        });

        // localStorage 저장
        localStorage.setItem("themeMode", mode);
    }

    // 버튼 바인딩
    function bindToggle(btn) {
        if (!btn) return;
        btn.addEventListener("click", () => {
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