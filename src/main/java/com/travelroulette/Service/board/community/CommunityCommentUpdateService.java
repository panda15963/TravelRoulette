package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CommunityCommentUpdateService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        String commentNumberStr = request.getParameter("commentNumber");
        String commentDescription = request.getParameter("commentDescription");

        int commentNumber = Integer.parseInt(commentNumberStr);

        CommunityBoardDao dao = new CommunityBoardDao();
        int result = dao.updateComment(commentNumber, commentDescription);

        return result;
    }
}