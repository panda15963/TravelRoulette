package com.travelroulette.Service.Board.Community;

import com.travelroulette.Dao.CommunityBoardDAO;
import com.travelroulette.Dto.Comment.CommentDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CommunityCommentDeleteService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        //현재 요청의 세션 가져오기(로그인 확인)
        HttpSession session = request.getSession();
        AuthenticatedUser authenticatedUser = (AuthenticatedUser) session.getAttribute("authenticatedUser");

        if (authenticatedUser == null) {
            return 0; //실패
        }
        String currentUserId = authenticatedUser.getUserId();

        String commentNumberStr = request.getParameter("commentNumber");
        int commentNumber = Integer.parseInt(commentNumberStr);

        CommunityBoardDAO dao = new CommunityBoardDAO();

        //권한 확인
        CommentDto originalComment = dao.selectOneComment(commentNumber);

        if (originalComment == null || !originalComment.getUserId().equals(currentUserId)) {
            System.out.println("댓글 삭제 권한 없음");
            return 0;
        }
        
        int result = dao.deleteComment(commentNumber);

        return result;
    }
}