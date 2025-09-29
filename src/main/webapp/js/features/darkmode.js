document.addEventListener("DOMContentLoaded", function () {
    const body = document.getElementById("pageBody");
    const navbar = document.getElementById("mainNavbar");
    const toggleBtn = document.getElementById("modeToggle");
    const toggleBtnSidebar = document.getElementById("modeToggleSidebar");
    const sidebar = document.getElementById("sidebarMenu");
    const aboutSection = document.getElementById("aboutSection");
    const boardSection = document.getElementById("boardSection");
    const introSection = document.getElementById("introSection"); // ✅ 자기소개 섹션

    // 🎨 테마 스타일 정의
    const themeConfig = {
        dark: {
            body: { bg: "#121212", color: "#eee" },
            navbar: ["navbar-dark", "bg-dark"],
            sidebar: { bg: "#212529", color: "#fff", link: "#fff" },
            about: { bg: "#121212", color: "#eee" },
            // ✅ 다크 모드에서 카드 = 흰색 / 텍스트 = 검정
            board: { bg: "#1e1e1e", color: "#eee", cardBg: "#fff", cardColor: "#000", border: "#444", muted: "#555" },
            hr: "3px solid #bbb",
            btn: { text: "☀️", remove: "btn-outline-dark", add: "btn-outline-warning", border: "yellow" }
        },
        light: {
            body: { bg: "#fff", color: "#000" },
            navbar: ["navbar-light", "bg-light"],
            sidebar: { bg: "#fff", color: "#000", link: "#000" },
            about: { bg: "#fff", color: "#000" },
            // ✅ 라이트 모드에서 카드 = 검정 / 텍스트 = 흰색
            board: { bg: "#fff", color: "#000", cardBg: "#000", cardColor: "#fff", border: "#444", muted: "#ccc" },
            hr: "3px solid #666",
            btn: { text: "🌙", remove: "btn-outline-warning", add: "btn-outline-dark", border: "black" }
        }
    };

    function updateButtons(config) {
        [toggleBtn, toggleBtnSidebar].forEach(btn => {
            if (!btn) return;
            btn.textContent = config.text;
            btn.classList.remove(config.remove);
            btn.classList.add(config.add);
            btn.style.borderColor = config.border;
        });
    }

    function updateSection(section, { bg, color }) {
        if (!section) return;
        section.style.backgroundColor = bg;
        section.style.color = color;
    }

    function updateCards(section, { cardBg, cardColor, border, muted }) {
        if (!section) return;
        section.querySelectorAll(".card").forEach(card => {
            card.style.backgroundColor = cardBg;
            card.style.borderColor = border;
            card.style.color = cardColor; // ✅ 카드 안 텍스트 색
        });
        section.querySelectorAll(".card .text-muted").forEach(el => {
            el.style.color = muted;
        });
    }

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

        // Intro Section ✅ 자기소개 카드에도 적용
        if (introSection) {
            updateSection(introSection, config.board);
            updateCards(introSection, config.board);
        }

        // 구분선(hr)
        document.querySelectorAll("hr").forEach(hr => {
            hr.style.borderTop = config.hr;
        });

        // localStorage 저장
        localStorage.setItem("themeMode", mode);
    }

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

    const savedMode = localStorage.getItem("themeMode") || "light";
    applyMode(savedMode);
});