<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- ⭐ 위시리스트 모달 -->
<div class="modal fade" id="wishListModal" tabindex="-1" aria-labelledby="wishListModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="wishListModalLabel">⭐ 내 위시리스트</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <ul id="wishListDisplay" class="list-group"></ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>