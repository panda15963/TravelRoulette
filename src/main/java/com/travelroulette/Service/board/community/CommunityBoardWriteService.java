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



        //임시 작성자
        //String userId = "user1";



        //현재 요청의 세션 가져오기(로그인 확인)
        HttpSession session = request.getSession();
        AuthenticatedUser authenticatedUser = (AuthenticatedUser)session.getAttribute("authenticatedUser") ;
        String userId = authenticatedUser.getUserId();

        //만약 세션에 userId가 없다면 종료
        if (userId == null || userId.isEmpty()) {
            return "login_required";
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        PostDto newPost = PostDto.builder()
                .postTitle(title)
                .postDescription(content)
                .boardNumber(1)
                .userId(userId)
                .build();

        //게시글 저장 요청
        CommunityBoardDao dao = new CommunityBoardDao();

        try {
            dao.insertPost(newPost);
            return "success";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }
}