package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class QnABoardUpdateService {

    public String execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                System.out.println("⚠️ 세션이 없습니다. 로그인 필요.");
                return "login_required";
            }

            AuthenticatedUser authenticatedUser = (AuthenticatedUser) session.getAttribute("authenticatedUser");
            if (authenticatedUser == null) {
                System.out.println("⚠️ 세션에 로그인 정보(authenticatedUser)가 없습니다.");
                return "login_required";
            }

            String qnaNumberStr = request.getParameter("qnaNumber");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            System.out.println("📝 QnA 게시글 수정 요청 - qnaNumber: " + qnaNumberStr + ", title: " + title);

            if (qnaNumberStr == null || qnaNumberStr.trim().isEmpty()) {
                System.out.println("❌ qnaNumber 파라미터가 없습니다.");
                return "missing_qnaNumber";
            }

            if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                System.out.println("❌ 제목 또는 내용이 비어있습니다.");
                return "empty_fields";
            }

            int qnaNumber = Integer.parseInt(qnaNumberStr);

            QnAPostDao dao = new QnAPostDao();

            // ✅ 1. 수정 전 원본 질문 조회
            QnABoardDto postToUpdate = dao.selectOneQnAPost(qnaNumber);

            // ✅ 2. 질문이 존재하지 않거나, 작성자가 현재 사용자와 다른 경우 작업 중단
            if (postToUpdate == null) {
                System.out.println("❌ 질문을 찾을 수 없습니다. qnaNumber: " + qnaNumber);
                return "post_not_found";
            }

            if (!postToUpdate.getUserId().equals(authenticatedUser.getUserId())) {
                System.out.println("❌ 질문 수정 권한 없음: 작성자(" + postToUpdate.getUserId() + ")와 요청자(" + authenticatedUser.getUserId() + ")가 다릅니다.");
                return "unauthorized";
            }

            // ✅ 3. 권한 확인 후 수정 진행
            QnABoardDto updatedPost = QnABoardDto.builder()
                    .qnaNumber(qnaNumber)
                    .qnaTitle(title)
                    .qnaDescription(content)
                    .build();

            int result = dao.updateQnAPost(updatedPost);

            if (result > 0) {
                System.out.println("✅ QnA 게시글 수정 성공 - qnaNumber: " + qnaNumber);
                return "success";
            } else {
                System.out.println("❌ QnA 게시글 수정 실패 - DB 업데이트 실패");
                return "fail";
            }

        } catch (NumberFormatException e) {
            System.out.println("❌ qnaNumber 파라미터 형식 오류: " + request.getParameter("qnaNumber"));
            e.printStackTrace();
            return "invalid_qnaNumber";
        } catch (Exception e) {
            System.out.println("❌ QnA 게시글 수정 중 예외 발생");
            e.printStackTrace();
            return "error: " + e.getMessage();
        }
    }
}
