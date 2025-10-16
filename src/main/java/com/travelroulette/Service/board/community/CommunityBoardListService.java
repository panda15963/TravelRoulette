package com.travelroulette.Service.Board.Community;

import com.travelroulette.Dao.CommunityBoardDAO;
import com.travelroulette.Dto.Board.BoardPageDto;
import com.travelroulette.Dto.Post.PostDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

public class CommunityBoardListService {

    public BoardPageDto execute(HttpServletRequest request, HttpServletResponse response) {

        int boardNumber = 1; //자유게시판 번호

        int currentPage = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize    = parseIntOrDefault(request.getParameter("pageSize"), 10);
        int pageBlockSize = 5; //화면 하단에 보여줄 페이지 번호 개수
        String sortParam = request.getParameter("sort");
        boolean asc = "asc".equalsIgnoreCase(sortParam);

        String searchKeyword = request.getParameter("searchKeyword");//검색어

        CommunityBoardDAO dao = new CommunityBoardDAO();

        int totalPostCount = dao.getPostCount(boardNumber, searchKeyword); //전체 게시글 수
        List<PostDto> posts = dao.selectAllPosts(boardNumber, currentPage, pageSize, asc, searchKeyword); //정렬 적용된 목록

        //페이지네이션 계산
        int totalPages = (int) Math.ceil((double) totalPostCount / pageSize); //전체 페이지 수

        int startPage = ((currentPage - 1) / pageBlockSize) * pageBlockSize + 1;
        int endPage = startPage + pageBlockSize - 1;
        if (endPage > totalPages) {
            endPage = totalPages;
        }

        //이전, 다음 버튼 표시 여부
        boolean hasPrev = startPage > 1;
        boolean hasNext = endPage < totalPages;


        return new BoardPageDto(
                totalPostCount,
                totalPages,
                currentPage,
                posts,
                startPage,
                endPage,
                hasPrev,
                hasNext,
                searchKeyword
        );
    }

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
//package com.travelroulette.Service.board.community;
//
//import com.travelroulette.Dao.CommunityBoardDAO;
//import com.travelroulette.Dto.Board.BoardPageDto;
//import com.travelroulette.Dto.Post.PostDto;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.util.List;
//
//public class CommunityBoardListService {
//
//    public BoardPageDto execute(HttpServletRequest request, HttpServletResponse response) {
//
//        int boardNumber = 1; //자유게시판 번호
//
//        //페이지네이션
//        int currentPage = parseIntOrDefault(request.getParameter("page"), 1);
//        int pageSize    = parseIntOrDefault(request.getParameter("pageSize"), 10);
//        int pageBlockSize = 5; //화면 하단에 보여줄 페이지 번호 개수
//
//        //정렬
//        String sortParam = request.getParameter("sort");
//        boolean asc = "asc".equalsIgnoreCase(sortParam);
//
//        CommunityBoardDAO dao = new CommunityBoardDAO();
//
//        int totalPostCount = dao.getPostCount(boardNumber); //전체 게시글 수
//        //정렬 적용된 목록 조회
//        List<PostDto> posts = dao.selectAllPosts(boardNumber, currentPage, pageSize, asc);
//
//        int totalPages = (int) Math.ceil((double) totalPostCount / pageSize); //전체 페이지 수
//
//        //페이지 번호 블록의 시작과 끝 계산
//        int startPage = ((currentPage - 1) / pageBlockSize) * pageBlockSize + 1;
//        int endPage = startPage + pageBlockSize - 1;
//        if (endPage > totalPages) {
//            endPage = totalPages;
//        }
//
//        //이전, 다음 버튼 표시 여부
//        boolean hasPrev = startPage > 1;
//        boolean hasNext = endPage < totalPages;
//
//        return new BoardPageDto(
//                totalPostCount,
//                totalPages,
//                currentPage,
//                posts,
//                startPage,
//                endPage,
//                hasPrev,
//                hasNext
//        );
//    }
//
//    private int parseIntOrDefault(String s, int def) {
//        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
//    }
//}
