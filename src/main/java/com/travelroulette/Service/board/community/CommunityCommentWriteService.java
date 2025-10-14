package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Comment.CommentDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CommunityCommentWriteService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        String commentDescription = request.getParameter("commentDescription");
        String postNumberStr = request.getParameter("postNumber");

        //임시 작성자
        //TODO: 로그인된 사용자 아이디 가져오기
        String userId = "user1";

        CommentDto newComment = CommentDto.builder()
                .commentDescription(commentDescription)
                .userId(userId)
                .postNumber(Integer.parseInt(postNumberStr))
                .build();

        CommunityBoardDao dao = new CommunityBoardDao();
        int result = dao.insertComment(newComment);

        return result;
    }
}