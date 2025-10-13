package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Post.PostDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CommunityBoardUpdateService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        String postNumberStr = request.getParameter("postNumber");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        PostDto updatedPost = PostDto.builder()
                .postNumber(Integer.parseInt(postNumberStr))
                .postTitle(title)
                .postDescription(content)
                .build();

        //updatePost 메소드를 호출
        CommunityBoardDao dao = new CommunityBoardDao();
        int result = dao.updatePost(updatedPost); // DAO에게 수정할 데이터가 담긴 DTO 전달!

        //성공 여부 반환
        return result;
    }
}