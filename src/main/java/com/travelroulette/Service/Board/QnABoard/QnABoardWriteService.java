package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class QnABoardWriteService {

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

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            System.out.println("⚠️ 제목 또는 내용이 비어 있습니다.");
            return "invalid_input";
        }

        QnABoardDto newPost = QnABoardDto.builder()
                .qnaTitle(title)
                .qnaDescription(content)
                .userId(userId)
                .build();

        QnAPostDao dao = new QnAPostDao();
        try {
            dao.insertQnAPost(newPost);
            System.out.println("✅ QnA 게시글 등록 성공 (" + title + ")");
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ QnA 게시글 등록 중 DB 오류 발생: " + e.getMessage());
            return "db_error";
        }
    }
}
