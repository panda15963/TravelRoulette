package com.travelroulette.Service.board.community;

import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Dao.CommunityBoardDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

public class CommunityBoardListService {
    public List<PostDto> execute(HttpServletRequest request, HttpServletResponse response) {

        int boardNumber = 1;

        CommunityBoardDao dao = new CommunityBoardDao();

        //게시글 목록 가져오기
        List<PostDto> postList = dao.selectAllPosts(boardNumber);

        //게시글 목록 반환
        return postList;
    }


}
