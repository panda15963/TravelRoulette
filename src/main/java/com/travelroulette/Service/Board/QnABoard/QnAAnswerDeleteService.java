package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class QnAAnswerDeleteService {

    public String execute(HttpServletRequest request, HttpServletResponse response) {

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
        int qnaNumber = Integer.parseInt(qnaNumberStr);

        QnAAnswerDao dao = new QnAAnswerDao();

        // ✅ 1. 삭제 전 원본 답글 정보 조회
        QnABoardDto answerToDelete = dao.selectOneAnswer(qnaNumber);

        // ✅ 2. 답글이 존재하지 않거나, 작성자가 현재 사용자와 다른 경우 작업 중단
        if (answerToDelete == null || !answerToDelete.getUserId().equals(authenticatedUser.getUserId())) {
            System.out.println("❌ 답글 삭제 권한 없음: 답글이 없거나 작성자가 다릅니다.");
            return "unauthorized"; // 실패 상태 반환
        }

        // ✅ 3. 권한이 확인된 경우에만 삭제 로직 수행
        int result = dao.deleteAnswer(qnaNumber);

        if (result > 0) {
            System.out.println("✅ QnA 답글 삭제 성공");
            return "success";
        } else {
            System.out.println("❌ QnA 답글 삭제 실패");
            return "fail";
        }
    }
}
