<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Board Preview Section -->
<section id="boardSection" class="py-5">
    <div class="container px-5 my-5">
        <div class="text-center mb-5">
            <h2 class="fw-bolder">최신 게시판</h2>
            <p class="lead fw-normal">상위 몇 개의 게시글을 미리 보여줍니다.</p>
        </div>

        <!-- 카드들이 들어갈 공간 -->
        <div class="row gx-5" id="boardPreview">
            <p class="text-center text-muted">게시글을 불러오는 중입니다...</p>
        </div>

        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/pages/board/common/mainBoard.jsp" class="btn btn-primary">
                게시판 더 보기
            </a>
        </div>
    </div>
</section>

<!-- ===== JS: mainBoard.jsp에서 최신 글 3개 불러오기 ===== -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetch("${pageContext.request.contextPath}/pages/board/common/mainBoard.jsp")
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");

                // mainBoard.jsp의 tbody 내 모든 tr 선택
                const rows = doc.querySelectorAll("tbody tr");
                const container = document.getElementById("boardPreview");
                container.innerHTML = ""; // 초기 안내 문구 제거

                if (rows.length === 0) {
                    container.innerHTML = `<p class="text-center text-muted">게시글이 없습니다.</p>`;
                    return;
                }

                // 상위 3개의 게시글만 카드로 표시
                rows.forEach((row, index) => {
                    if (index < 3) {
                        const category = row.querySelector("td:nth-child(2)")?.innerText.trim() || "";
                        const title = row.querySelector("td:nth-child(3) a")?.innerText.trim() || "제목 없음";
                        const link = row.querySelector("td:nth-child(3) a")?.getAttribute("href") || "#";
                        const author = row.querySelector("td:nth-child(4)")?.innerText.trim() || "작성자 없음";
                        const date = row.querySelector("td:nth-child(5)")?.innerText.trim() || "-";

                        container.innerHTML += `
                        <div class="col-lg-4 mb-5">
                            <div class="card h-100 shadow border-0">
                                <div class="card-body p-4">
                                    <span class="badge bg-info text-dark mb-2">${category}</span>
                                    <h5 class="card-title mb-3">
                                        <a href="${link}" class="text-decoration-none text-dark fw-semibold">${title}</a>
                                    </h5>
                                    <p class="card-text mb-0 text-muted">게시글 내용 요약...</p>
                                </div>
                                <div class="card-footer bg-transparent border-top-0">
                                    <small class="text-muted">${author} · ${date}</small>
                                </div>
                            </div>
                        </div>
                    `;
                    }
                });
            })
            .catch(error => {
                console.error(error);
                document.getElementById("boardPreview").innerHTML =
                    `<p class="text-center text-danger">게시글을 불러오는 중 오류가 발생했습니다.</p>`;
            });
    });
</script>