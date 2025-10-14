package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CommunityBoardDeleteService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        //삭제할 게시글 번호
        String postNumberStr = request.getParameter("postNumber");
        int postNumber = Integer.parseInt(postNumberStr);

        //게시글 삭제
        CommunityBoardDao dao = new CommunityBoardDao();
        int result = dao.deletePost(postNumber);

        //성공 여부 반환
        return result;
    }
}