<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!-- Board Preview Section -->
<section id = "boardSection" class = "py-5">
	<div class = "container px-5 my-5">
		<div class = "text-center mb-5">
			<h2 class = "fw-bolder">최신 게시판</h2>
			<p class = "lead fw-normal">상위 몇 개의 게시글을 미리 보여줍니다.</p>
		</div>
		<div class = "row gx-5">
			<div class = "col-lg-4 mb-5">
				<div class = "card h-100 shadow border-0">
					<div class = "card-body p-4">
						<h5 class = "card-title mb-3">첫 번째 게시글 제목</h5>
						<p class = "card-text mb-0">게시글 내용 요약...</p>
					</div>
					<div class = "card-footer bg-transparent border-top-0">
						<small class = "text-muted">작성자 · 작성일</small>
					</div>
				</div>
			</div>
			<div class = "col-lg-4 mb-5">
				<div class = "card h-100 shadow border-0">
					<div class = "card-body p-4">
						<h5 class = "card-title mb-3">두 번째 게시글 제목</h5>
						<p class = "card-text mb-0">게시글 내용 요약...</p>
					</div>
					<div class = "card-footer bg-transparent border-top-0">
						<small class = "text-muted">작성자 · 작성일</small>
					</div>
				</div>
			</div>
			<div class = "col-lg-4 mb-5">
				<div class = "card h-100 shadow border-0">
					<div class = "card-body p-4">
						<h5 class = "card-title mb-3">세 번째 게시글 제목</h5>
						<p class = "card-text mb-0">게시글 내용 요약...</p>
					</div>
					<div class = "card-footer bg-transparent border-top-0">
						<small class = "text-muted">작성자 · 작성일</small>
					</div>
				</div>
			</div>
		</div>
		<div class = "text-center">
			<a href = "${pageContext.request.contextPath}/pages/board/board.jsp" class = "btn btn-primary">
				게시판 더 보기
			</a>
		</div>
	</div>
</section>