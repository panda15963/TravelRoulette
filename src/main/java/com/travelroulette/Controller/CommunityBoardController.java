package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.travelroulette.Dto.Board.BoardPageDto;
import com.travelroulette.Dto.Comment.CommentDto;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Service.Board.Community.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;


import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

//@WebServlet("/board/community/*")
@MultipartConfig
public class CommunityBoardController extends HttpServlet {

    public CommunityBoardController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //요청 URI에서 명령어 추출
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = requestURI.substring(contextPath.length());

        System.out.println("요청 URI: " + requestURI);
        System.out.println("요청 Command: " + command);

        //작업 분기
        if (command.equals("/board/community/list.do")) {
            System.out.println("커뮤니티 게시판 목록 요청 처리");

            //정렬 파라미터
            String sortParam = request.getParameter("sort");
            String sort = "asc".equalsIgnoreCase(sortParam) ? "asc" : "desc";

            CommunityBoardListService service = new CommunityBoardListService();
            BoardPageDto pageDto = service.execute(request, response);

            //JSON 변환
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                            new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                    ).create();
            String jsonResponse = gson.toJson(pageDto);

            //JSON 응답
            response.setContentType("application/json; charset=UTF-8"); // 한 줄로 정리
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();
        }



        else if (command.equals("/board/community/write.do")) {
            System.out.println("글쓰기 요청 처리");

            CommunityBoardWriteService service = new CommunityBoardWriteService();
            String resultMessage = service.execute(request, response);

            //JSON으로 변환
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            Gson gson = new Gson();
            java.util.Map<String, String> responseMap = new java.util.HashMap<>();

            if (resultMessage.equals("success")) {
                //성공
                responseMap.put("status", "success");
            } else {
                //실패
                responseMap.put("status", "fail");
                responseMap.put("message", resultMessage);
            }

            String jsonResponse = gson.toJson(responseMap);
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();
        }

        else if (command.equals("/board/community/detail.do")) {
            System.out.println("상세보기 요청 처리");

            CommunityBoardDetailService service = new CommunityBoardDetailService();
            PostDto post = service.execute(request, response);

            //JSON 문자열로 변환
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                            new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                    ).create();
            String jsonPost = gson.toJson(post);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonPost);
            out.flush();
        }

        else if (command.equals("/board/community/update.do")) {
            System.out.println("글 수정 요청 처리");

            //글 수정 서비스 객체 생성 및 실행
            CommunityBoardUpdateService service = new CommunityBoardUpdateService();
            int result = service.execute(request, response);

            //JSON 형태
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (result > 0) {
                //성공
                out.print("{\"status\":\"success\"}");
            } else {
                //실패
                out.print("{\"status\":\"fail\"}");
            }
            out.flush();
        }


        else if (command.equals("/board/community/delete.do")) {
            System.out.println("글 삭제 요청 처리");

            CommunityBoardDeleteService service = new CommunityBoardDeleteService();
            int result = service.execute(request, response);

            //JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (result > 0) {
                //성공
                out.print("{\"status\":\"success\"}");
            } else {
                //실패
                out.print("{\"status\":\"fail\"}");
            }
            out.flush();
        }

        else if (command.equals("/board/community/comments.do")) {
            System.out.println("댓글 목록 요청 처리(비동기)");

            CommunityCommentListService service = new CommunityCommentListService();
            List<CommentDto> commentList = service.execute(request, response);

            //JSON
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                            new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                    ).create();
            String jsonResponse = gson.toJson(commentList);

            //응답
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();
        }


        else if (command.equals("/board/community/comment/write.do")) {
            System.out.println("댓글 쓰기 요청 처리");

            CommunityCommentWriteService service = new CommunityCommentWriteService();
            int result = service.execute(request, response);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (result > 0) {
                //성공
                out.print("{\"status\":\"success\"}");
            } else {
                //실패
                out.print("{\"status\":\"fail\"}");
            }
            out.flush();
        }


        else if (command.equals("/board/community/comment/update.do")) {
            System.out.println("댓글 수정 요청 처리(비동기)");

            CommunityCommentUpdateService service = new CommunityCommentUpdateService();
            int result = service.execute(request, response);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (result > 0) {
                //성공
                out.print("{\"status\":\"success\"}");
            } else {
                //실패
                out.print("{\"status\":\"fail\"}");
            }
            out.flush();
        }


        else if (command.equals("/board/community/comment/delete.do")) {
            System.out.println("댓글 삭제 요청 처리(비동기)");

            CommunityCommentDeleteService service = new CommunityCommentDeleteService();
            int result = service.execute(request, response);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (result > 0) {
                //성공
                out.print("{\"status\":\"success\"}");
            } else {
                //실패
                out.print("{\"status\":\"fail\"}");
            }
            out.flush();
        }











    }



    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }


}
