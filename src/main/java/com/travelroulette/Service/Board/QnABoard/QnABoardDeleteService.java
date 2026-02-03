package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class QnABoardDeleteService {

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

        QnAPostDao postDao = new QnAPostDao();

        // ✅ 1. 삭제 전 원본 질문 조회
        QnABoardDto postToDelete = postDao.selectOneQnAPost(qnaNumber);

        // ✅ 2. 질문이 존재하지 않거나, 작성자가 현재 사용자와 다른 경우 작업 중단
        if (postToDelete == null || !postToDelete.getUserId().equals(authenticatedUser.getUserId())) {
            System.out.println("❌ 질문 삭제 권한 없음: 질문이 없거나 작성자가 다릅니다.");
            return "unauthorized";
        }

        // ✅ 3. 권한 확인 후 질문과 답글 모두 삭제
        QnAAnswerDao answerDao = new QnAAnswerDao();
        answerDao.deleteAnswersByRef(qnaNumber); // 질문에 달린 답글들 삭제

        int result = postDao.deleteQnAPost(qnaNumber); // 질문 삭제

        if (result > 0) {
            System.out.println("✅ QnA 게시글 삭제 성공");
            return "success";
        } else {
            System.out.println("❌ QnA 게시글 삭제 실패");
            return "fail";
        }
    }
}
