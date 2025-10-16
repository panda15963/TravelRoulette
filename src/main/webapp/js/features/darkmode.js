document.addEventListener("DOMContentLoaded", function () {
    const body = document.getElementById("pageBody") || document.body;
    const navbar = document.getElementById("mainNavbar");
    const toggleBtn = document.getElementById("modeToggle");
    const toggleBtnSidebar = document.getElementById("modeToggleSidebar");
    const sidebar = document.getElementById("sidebarMenu");
    const aboutSection = document.getElementById("aboutSection");
    const boardSection = document.getElementById("boardSection");
    const introSection = document.getElementById("introSection");
    const header = document.querySelector("header");

    // 🎨 테마 스타일 정의
    const themeConfig = {
        dark: {
            body: { bg: "#121212", color: "#eaeaea" },
            navbar: ["navbar-dark", "bg-dark"],
            sidebar: {
                bg: "#212529",
                color: "#f8f9fa",
                link: "#f8f9fa",
                border: "#343a40",
                activeBg: "#333",
                activeColor: "#fff"
            },
            about: { bg: "#121212", color: "#eaeaea" },
            board: {
                bg: "#1e1e1e",
                color: "#eaeaea",
                cardBg: "#2a2a2a",
                cardHeaderBg: "#333",
                cardColor: "#f1f1f1",
                border: "#555",
                muted: "#888",
                tableHeaderBg: "#2a2a2a",
                tableHeaderColor: "#f8f9fa",
                badgeBg: "#444",
                badgeColor: "#f5f5f5"
            },
            header: { bg: "#f8f9fa", color: "#212529" },
            hr: "2px solid #64A5E6",
            btn: { text: "☀️", remove: "btn-outline-dark", add: "btn-outline-warning", border: "yellow" }
        },
        light: {
            body: { bg: "#ffffff", color: "#000" },
            navbar: ["navbar-light", "bg-light"],
            // ✅ 밝을 때만 사이드바 하늘색 배경
            sidebar: {
                bg: "#eaf5ff",
                color: "#000",
                link: "#000",
                border: "#dee2e6",
                activeBg: "#d4ecff",
                activeColor: "#0b5ed7"
            },
            about: { bg: "#ffffff", color: "#000" },
            board: {
                bg: "#ffffff",
                color: "#000",
                cardBg: "#ffffff",
                cardHeaderBg: "#e9f6ff",
                cardColor: "#000",
                border: "#ddd",
                muted: "#666",
                tableHeaderBg: "#e9f6ff",
                tableHeaderColor: "#007bff",
                badgeBg: "#dff4ff",
                badgeColor: "#0b5ed7"
            },
            header: { bg: "#212529", color: "#ffffff" },
            hr: "2px solid #64A5E6",
            btn: { text: "🌙", remove: "btn-outline-warning", add: "btn-outline-dark", border: "black" }
        }
    };

    // 🔘 버튼 업데이트
    function updateButtons(config) {
        [toggleBtn, toggleBtnSidebar].forEach(btn => {
            if (!btn) return;
            btn.textContent = config.text;
            btn.classList.remove(config.remove);
            btn.classList.add(config.add);
            btn.style.borderColor = config.border;
        });
    }

    // 🔘 일반 섹션 색상 업데이트
    function updateSection(section, { bg, color }) {
        if (!section) return;
        section.style.setProperty("background-color", bg, "important");
        section.style.setProperty("color", color, "important");
    }

    // 🔘 게시판 내부 요소 업데이트
    function updateBoardElements(section, cfg) {
        if (!section) return;

        // 카드
        section.querySelectorAll(".card").forEach(card => {
            card.style.setProperty("background-color", cfg.cardBg, "important");
            card.style.setProperty("border-color", cfg.border, "important");
            card.style.setProperty("color", cfg.cardColor, "important");
        });

        // 카드 헤더
        section.querySelectorAll(".card-header").forEach(header => {
            header.style.setProperty("background-color", cfg.cardHeaderBg, "important");
            header.style.setProperty("color", cfg.cardColor, "important");
        });

        // 테이블
        section.querySelectorAll(".table").forEach(table => {
            table.style.setProperty("background-color", cfg.cardBg, "important");
            table.style.setProperty("color", cfg.cardColor, "important");
        });

        // 테이블 헤더
        section.querySelectorAll(".table thead").forEach(thead => {
            thead.style.setProperty("background-color", cfg.tableHeaderBg, "important");
            thead.style.setProperty("color", cfg.tableHeaderColor, "important");
        });

        // 배지
        section.querySelectorAll(".badge").forEach(badge => {
            badge.style.setProperty("background-color", cfg.badgeBg, "important");
            badge.style.setProperty("color", cfg.badgeColor, "important");
        });

        // muted 텍스트
        section.querySelectorAll(".text-muted").forEach(text => {
            text.style.setProperty("color", cfg.muted, "important");
        });
    }

    // 🔘 사이드바 업데이트
    function updateSidebar(cfg) {
        if (!sidebar) return;
        sidebar.style.setProperty("background-color", cfg.bg, "important");
        sidebar.style.setProperty("color", cfg.color, "important");
        sidebar.style.setProperty("border-color", cfg.border, "important");

        sidebar.querySelectorAll(".nav-link").forEach(link => {
            link.style.setProperty("color", cfg.link, "important");
            // ✅ active 항목에 맞춰 색상 강조
            if (link.classList.contains("active")) {
                link.style.setProperty("background-color", cfg.activeBg, "important");
                link.style.setProperty("color", cfg.activeColor, "important");
                link.style.setProperty("font-weight", "bold", "important");
            }
        });
    }

    // 🔘 모드 적용 함수
    function applyMode(mode) {
        const config = themeConfig[mode];
        body.setAttribute("data-mode", mode);

        // Body
        body.style.setProperty("background-color", config.body.bg, "important");
        body.style.setProperty("color", config.body.color, "important");

        // 버튼
        updateButtons(config.btn);

        // Navbar
        if (navbar) {
            navbar.classList.remove(...themeConfig.dark.navbar, ...themeConfig.light.navbar);
            navbar.classList.add(...config.navbar);
        }

        // Sidebar
        updateSidebar(config.sidebar);

        // About Section
        updateSection(aboutSection, config.about);

        // Board Section
        if (boardSection) {
            updateSection(boardSection, config.board);
            updateBoardElements(boardSection, config.board);
        }

        // Intro Section
        if (introSection) {
            updateSection(introSection, config.board);
            updateBoardElements(introSection, config.board);
        }

        // Header
        if (header) {
            updateSection(header, config.header);
        }

        // 구분선(hr)
        document.querySelectorAll("hr").forEach(hr => {
            hr.style.setProperty("border-top", config.hr, "important");
        });

        // 저장
        localStorage.setItem("themeMode", mode);
    }

    // 🔘 버튼 이벤트 연결
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

    // 🔘 저장된 모드 불러오기
    const savedMode = localStorage.getItem("themeMode") || "light";
    applyMode(savedMode);
});
