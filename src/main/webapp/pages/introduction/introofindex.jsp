<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<!DOCTYPE html>
<html lang = "en">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel = "icon" type = "image/x-icon" href = "../../assets/favicon.ico?v=2" />
    <link href = "../../css/styles.css" rel = "stylesheet" />
    <!-- Bootstrap CSS -->
    <link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel = "stylesheet" />
</head>
<body id = "pageBody" class = "d-flex flex-column h-100" data-mode = "light">

<%@ include file = "/Common/navbar.jsp" %>
<%@ include file = "/Common/sidebar.jsp" %>

<!-- 자기소개 카드 섹션 -->
<main id="introSection" class = "flex-shrink-0 pt-5">
    <div class = "container my-5">
        <div class = "text-center mb-5">
            <h2 class = "fw-bold">자기소개</h2>
        </div>

        <div class = "row gx-5">
            <!-- 첫 번째 카드 -->
            <div class = "col-lg-4 mb-5">
                <div class = "card h-100 shadow border-0 text-center">
                    <div class = "card-body p-4">
                        <h5 class = "card-title mb-2">최민석</h5>
                    </div>
                    <div class = "card-footer bg-transparent border-top-0">
                        <a href = "profileMinseok.jsp" class = "btn btn-outline-primary btn-sm">자세히 보기</a>
                    </div>
                </div>
            </div>

            <!-- 두 번째 카드 -->
            <div class = "col-lg-4 mb-5">
                <div class = "card h-100 shadow border-0 text-center">
                    <div class = "card-body p-4">
                        <h5 class = "card-title mb-2">양도희</h5>
                    </div>
                    <div class = "card-footer bg-transparent border-top-0">
                        <a href = "profileDohee.jsp" class = "btn btn-outline-primary btn-sm">자세히 보기</a>
                    </div>
                </div>
            </div>

            <!-- 세 번째 카드 -->
            <div class = "col-lg-4 mb-5">
                <div class = "card h-100 shadow border-0 text-center">
                    <div class = "card-body p-4">
                        <h5 class = "card-title mb-2">구건모</h5>
                    </div>
                    <div class = "card-footer bg-transparent border-top-0">
                        <a href = "profileGunmo.jsp" class = "btn btn-outline-primary btn-sm">자세히 보기</a>
                    </div>
                </div>
            </div>

            <!-- 네 번째 카드 -->
            <div class = "col-lg-4 mb-5">
                <div class = "card h-100 shadow border-0 text-center">
                    <div class = "card-body p-4">
                        <h5 class = "card-title mb-2">나기현</h5>
                    </div>
                    <div class = "card-footer bg-transparent border-top-0">
                        <a href = "profileGihyeon.jsp" class = "btn btn-outline-primary btn-sm">자세히 보기</a>
                    </div>
                </div>
            </div>

            <!-- 다섯 번째 카드 -->
            <div class = "col-lg-4 mb-5">
                <div class = "card h-100 shadow border-0 text-center">
                    <div class = "card-body p-4">
                        <h5 class = "card-title mb-2">최인렬</h5>
                    </div>
                    <div class = "card-footer bg-transparent border-top-0">
                        <a href = "profileInryeol.jsp" class = "btn btn-outline-primary btn-sm">자세히 보기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Bootstrap JS -->
<script src = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src = "../../js/features/darkmode.js"></script>
</body>
</html>
