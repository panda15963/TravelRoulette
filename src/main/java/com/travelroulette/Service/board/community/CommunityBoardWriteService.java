package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Post.PostDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.SQLException;


public class CommunityBoardWriteService {

    public String execute(HttpServletRequest request, HttpServletResponse response) {

        //사용자가 입력한 데이터
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        //임시 작성자
        //Todo: 로그인 기능 구현 후 수정 필요
        String userId = "user1";

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
/*
public class CommunityBoardWriteService {
    public int execute(HttpServletRequest request, HttpServletResponse response) {

        //사용자가 입력한 데이터
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        //임시 작성자
        //Todo: 로그인 기능 구현 후 수정 필요
        String userId = "user43";

        PostDto newPost = PostDto.builder()
                .postTitle(title)
                .postDescription(content)
                .boardNumber(1)
                .userId(userId)
                .build();

        //게시글 저장 요청
        CommunityBoardDao dao = new CommunityBoardDao();
        int result = dao.insertPost(newPost);

        return result;
    }
}

 */