package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class QnAAnswerWriteService {

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

        String userId = authenticatedUser.getUserId();
        if (userId == null || userId.isEmpty()) {
            System.out.println("⚠️ userId가 비어 있습니다.");
            return "login_required";
        }

        String qnaRefStr = request.getParameter("qnaRef");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            System.out.println("⚠️ 제목 또는 내용이 비어 있습니다.");
            return "invalid_input";
        }

        int qnaRef = Integer.parseInt(qnaRefStr);

        // 답글 중복 체크 - 이미 답글이 있는지 확인
        QnAAnswerDao dao = new QnAAnswerDao();
        if (dao.hasAnswer(qnaRef)) {
            System.out.println("⚠️ 이미 답글이 존재합니다. qnaRef: " + qnaRef);
            return "already_exists";
        }

        QnABoardDto newAnswer = QnABoardDto.builder()
                .qnaTitle(title)
                .qnaDescription(content)
                .qnaRef(qnaRef)
                .userId(userId)
                .build();

        int result = dao.insertAnswer(newAnswer);

        if (result > 0) {
            System.out.println("✅ QnA 답글 등록 성공");
            return "success";
        } else {
            System.out.println("❌ QnA 답글 등록 실패");
            return "fail";
        }
    }
}

