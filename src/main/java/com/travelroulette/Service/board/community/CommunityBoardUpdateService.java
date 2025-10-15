package com.travelroulette.Service.board.community;

import com.travelroulette.Dao.CommunityBoardDao;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Dto.User.AuthenticatedUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CommunityBoardUpdateService {

    public int execute(HttpServletRequest request, HttpServletResponse response) {

        //현재 요청의 세션 가져오기(로그인 확인)
        HttpSession session = request.getSession();
        AuthenticatedUser authenticatedUser = (AuthenticatedUser) session.getAttribute("authenticatedUser");

        //로그인하지 않은 경우
        if (authenticatedUser == null) {
            return 0; //0: 실패
        }
        String currentUserId = authenticatedUser.getUserId();


        String postNumberStr = request.getParameter("postNumber");
        int postNumber = Integer.parseInt(postNumberStr);
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        CommunityBoardDao dao = new CommunityBoardDao();

        //수정하려는 게시글
        PostDto originalPost = dao.selectOnePost(postNumber);

        if (originalPost == null || !originalPost.getUserId().equals(currentUserId)) {
            System.out.println("게시글 수정 권한 없음");
            return 0; //실패
        }

        PostDto updatedPost = PostDto.builder()
                .postNumber(Integer.parseInt(postNumberStr))
                .postTitle(title)
                .postDescription(content)
                .build();


        int result = dao.updatePost(updatedPost);

        //성공 여부 반환
        return result;
    }
}