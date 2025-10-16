package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class QnAAnswerUpdateService {

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
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        QnABoardDto updatedAnswer = QnABoardDto.builder()
                .qnaNumber(Integer.parseInt(qnaNumberStr))
                .qnaTitle(title)
                .qnaDescription(content)
                .build();

        QnAAnswerDao dao = new QnAAnswerDao();
        int result = dao.updateAnswer(updatedAnswer);

        if (result > 0) {
            System.out.println("✅ QnA 답글 수정 성공");
            return "success";
        } else {
            System.out.println("❌ QnA 답글 수정 실패");
            return "fail";
        }
    }
}
