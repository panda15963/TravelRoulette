package com.travelroulette.Service.Board.Community;

import com.travelroulette.Dao.CommunityBoardDAO;
import com.travelroulette.Dto.Comment.CommentDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

public class CommunityCommentListService {

    public List<CommentDto> execute(HttpServletRequest request, HttpServletResponse response) {

        //게시글 번호
        String postNumberStr = request.getParameter("postNumber");
        int postNumber = Integer.parseInt(postNumberStr);

        //댓글 목록
        CommunityBoardDAO dao = new CommunityBoardDAO();
        List<CommentDto> commentList = dao.selectAllComments(postNumber);

        return commentList;
    }
}