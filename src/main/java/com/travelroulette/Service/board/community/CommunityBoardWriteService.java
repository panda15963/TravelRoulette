package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.SQLException;

public class CommunityBoardWriteService {

    public String execute(HttpServletRequest request, HttpServletResponse response) {

        // ✅ 현재 요청의 세션 가져오기 (false = 없으면 새로 만들지 않음)
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("⚠️ 세션이 없습니다. 로그인 필요.");
            return "login_required";
        }

        // ✅ 로그인 정보 확인
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

        // ✅ 제목과 내용 가져오기
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            System.out.println("⚠️ 제목 또는 내용이 비어 있습니다.");
            return "invalid_input";
        }

        // ✅ PostDto 생성
        PostDto newPost = PostDto.builder()
                .postTitle(title)
                .postDescription(content)
                .boardNumber(1)
                .userId(userId)
                .build();

        // ✅ 게시글 저장
        CommunityBoardDao dao = new CommunityBoardDao();
        try {
            dao.insertPost(newPost);
            System.out.println("✅ 게시글 등록 성공 (" + title + ")");
            return "success";
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ 게시글 등록 중 DB 오류 발생: " + e.getMessage());
            return "db_error";
        }
    }
}