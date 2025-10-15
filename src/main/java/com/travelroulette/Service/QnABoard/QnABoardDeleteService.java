package com.travelroulette.Service.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dao.QnABoard.QnAPostDao;
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

        QnAAnswerDao answerDao = new QnAAnswerDao();
        answerDao.deleteAnswersByRef(qnaNumber);

        QnAPostDao postDao = new QnAPostDao();
        int result = postDao.deleteQnAPost(qnaNumber);

        if (result > 0) {
            System.out.println("✅ QnA 게시글 삭제 성공");
            return "success";
        } else {
            System.out.println("❌ QnA 게시글 삭제 실패");
            return "fail";
        }
    }
}
