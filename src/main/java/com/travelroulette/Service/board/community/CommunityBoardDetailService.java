package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDAO;
import com.travelroulette.Dto.Post.PostDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CommunityBoardDetailService {

    public PostDto execute(HttpServletRequest request, HttpServletResponse response) {

        //게시글 번호 가져오기
        String postNumberStr = request.getParameter("postNumber");
        int postNumber = Integer.parseInt(postNumberStr);

        //게시글 데이터 가져오기
        CommunityBoardDAO dao = new CommunityBoardDAO();
        PostDto post = dao.selectOnePost(postNumber);

        return post;
    }
}