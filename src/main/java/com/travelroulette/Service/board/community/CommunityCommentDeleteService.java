package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CommunityCommentDeleteService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        String commentNumberStr = request.getParameter("commentNumber");
        int commentNumber = Integer.parseInt(commentNumberStr);

        CommunityBoardDao dao = new CommunityBoardDao();
        int result = dao.deleteComment(commentNumber);

        return result;
    }
}