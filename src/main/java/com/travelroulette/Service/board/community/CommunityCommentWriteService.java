package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Comment.CommentDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CommunityCommentWriteService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        String commentDescription = request.getParameter("commentDescription");
        String postNumberStr = request.getParameter("postNumber");


        //현재 요청의 세션 가져오기(로그인 확인)
        HttpSession session = request.getSession();
        AuthenticatedUser authenticatedUser = (AuthenticatedUser)session.getAttribute("authenticatedUser") ;
        String userId = authenticatedUser.getUserId();

        //만약 세션에 userId가 없다면 종료
        if (userId == null || userId.isEmpty()) {
            return 0;
        }


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