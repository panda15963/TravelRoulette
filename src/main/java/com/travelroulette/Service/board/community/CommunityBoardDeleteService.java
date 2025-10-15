package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CommunityBoardDeleteService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        //현재 요청의 세션 가져오기(로그인 확인)
        HttpSession session = request.getSession();
        AuthenticatedUser authenticatedUser = (AuthenticatedUser) session.getAttribute("authenticatedUser");

        //로그인하지 않은 경우
        if (authenticatedUser == null) {
            return 0; //실패
        }
        String currentUserId = authenticatedUser.getUserId();

        //삭제할 게시글 번호
        String postNumberStr = request.getParameter("postNumber");
        int postNumber = Integer.parseInt(postNumberStr);

        CommunityBoardDao dao = new CommunityBoardDao();

        //삭제하려는 게시글
        PostDto originalPost = dao.selectOnePost(postNumber);

        if (originalPost == null || !originalPost.getUserId().equals(currentUserId)) {
            System.out.println("게시글 삭제 권한 없음");
            return 0; //실패
        }

        //게시글 삭제
        try {
            //해당 게시글의 댓글 삭제
            dao.deleteCommentsByPostNumber(postNumber);

            //게시글을 삭제
            int result = dao.deletePost(postNumber);

            return result; //성공 여부 반환

        } catch (Exception e) {
            e.printStackTrace();
            return 0;//실패
        }

    }
}