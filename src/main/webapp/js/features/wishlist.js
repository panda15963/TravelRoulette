document.addEventListener("DOMContentLoaded", () => {
    const btnAddWish = document.getElementById("btnAddWish");
    const openWishListBtn = document.getElementById("openWishListBtn");
    const countryCodeInput = document.getElementById("countryCodeInput");
    const countryDropdown = document.getElementById("countryDropdown");
    const continentDropdown = document.getElementById("continentDropdown");
    const wishListDisplay = document.getElementById("wishListDisplay");
    const wishListModal = document.getElementById("wishListModal"); // ✅ 모달

    const userId = AuthManager.getUserId();

    console.log(userId);
    // ✅ 프로젝트 경로 자동 인식
    const baseUrl = `${window.location.origin}${
        window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : ''
    }`;

    // ✅ 위시리스트 불러오기
    async function loadWishList() {
        if (!userId) return;
        try {
            const res = await fetch(`${baseUrl}/wishlist?userId=${encodeURIComponent(userId)}`);
            if (!res.ok) throw new Error("위시리스트 불러오기 실패");

            const list = await res.json();
            console.log("📦 위시리스트 데이터:", list);

            wishListDisplay.innerHTML = "";

            if (list.length === 0) {
                wishListDisplay.innerHTML = `
                    <li class="list-group-item text-muted text-center">
                        아직 추가된 나라가 없습니다.
                    </li>`;
                return;
            }

            list.forEach(item => {
                const li = document.createElement("li");
                li.className = "list-group-item d-flex justify-content-between align-items-center";

                li.innerHTML = `
                    <div class="d-flex align-items-center gap-3">
                        <img src="${item.flagURL}" alt="${item.countryName}"
                             width="40" height="28" style="border:1px solid #ccc; border-radius:4px;">
                        <div>
                            <strong>${item.countryName}</strong><br>
                            <small class="text-muted">${item.continentName}</small>
                        </div>
                    </div>
                `;

                const removeBtn = document.createElement("button");
                removeBtn.className = "btn btn-sm btn-outline-danger";
                removeBtn.textContent = "삭제";
                removeBtn.onclick = async () => {
                    await removeFromWishList(item.countryCode, item.countryName);
                    await loadWishList();
                };

                li.appendChild(removeBtn);
                wishListDisplay.appendChild(li);
            });
        } catch (err) {
            console.error("❌ 위시리스트 로드 오류:", err);
        }
    }

    // ✅ 위시리스트에서 나라 삭제
    async function removeFromWishList(countryCode, countryName) {
        try {
            const res = await fetch(`${baseUrl}/wishlist`, {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: `userId=${encodeURIComponent(userId)}&countryCode=${encodeURIComponent(countryCode)}&checkContWishList=false`
            });

            const data = await res.json();
            if (data.status === "success") {
                alert(`🗑️ ${countryName}이(가) 위시리스트에서 삭제되었습니다.`);
            } else {
                alert("❌ 삭제에 실패했습니다. 다시 시도해주세요.");
            }
        } catch (err) {
            console.error("❌ 삭제 오류:", err);
        }
    }

    // 🌍 대륙이 바뀔 때 버튼 초기화
    continentDropdown?.addEventListener("click", () => resetAddWishButton(false));

    // 🇰🇷 나라 선택 시 버튼 초기화 및 활성화
    countryDropdown?.addEventListener("click", () => resetAddWishButton(true));

    // ✅ 버튼 초기화 함수
    function resetAddWishButton(enable = true) {
        btnAddWish.textContent = "⭐ 위시리스트에 추가";
        btnAddWish.style.opacity = "1";
        btnAddWish.disabled = !enable;
    }

    // ⭐ 버튼 클릭 시 위시리스트 추가 요청
    btnAddWish.addEventListener("click", async () => {
        const countryCode = countryCodeInput.value;

        if (!userId) {
            AuthManager.requireLogin();
            return;
        }

        if (!countryCode) {
            alert("먼저 나라를 선택해주세요 🌍");
            return;
        }

        try {
            const res = await fetch(`${baseUrl}/wishlist`, {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: `userId=${encodeURIComponent(userId)}&countryCode=${encodeURIComponent(countryCode)}&checkContWishList=true`
            });

            if (!res.ok) throw new Error("서버 응답 오류");

            const data = await res.json();
            console.log("✅ 서버 응답:", data);

            // ✅ 중복 처리
            if (data.status === "duplicate") {
                alert("⚠️ 이미 위시리스트에 추가된 나라입니다!");
                btnAddWish.textContent = "⭐ 위시리스트에 추가됨";
                btnAddWish.style.opacity = "0.8";
                btnAddWish.disabled = true;
                return;
            }

            // ✅ 정상 추가
            if (data.status === "success") {
                alert("✅ 위시리스트에 추가되었습니다!");
                btnAddWish.textContent = "⭐ 위시리스트에 추가됨";
                btnAddWish.style.opacity = "0.8";
                btnAddWish.disabled = true;
                await loadWishList(); // 즉시 리스트 갱신
            } else {
                alert("❌ 추가에 실패했습니다. 다시 시도해주세요.");
            }

        } catch (err) {
            console.error("❌ 위시리스트 추가 오류:", err);
            alert("⚠️ 서버 연결 중 오류가 발생했습니다.");
        }
    });

    // ✅ 로그인 여부 확인 후 모달 열기
    openWishListBtn?.addEventListener("click", async (event) => {
        if (!userId) {
            event.preventDefault();
            AuthManager.requireLogin();
            return;
        }
        // 모달 클릭 시 즉시 불러오기 대신 show 이벤트로 처리됨
    });

    // ✅ 모달이 실제로 열릴 때 위시리스트 불러오기
    if (wishListModal) {
        wishListModal.addEventListener("show.bs.modal", async () => {
            if (!userId) return;
            await loadWishList();
        });
    }
});