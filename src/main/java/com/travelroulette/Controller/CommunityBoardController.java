package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Service.board.community.CommunityBoardListService;
import com.travelroulette.Service.board.community.CommunityBoardWriteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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

            //서비스 객체 생성 및 실행
            CommunityBoardListService service = new CommunityBoardListService();
            List<PostDto> postList = service.execute(request, response);


            //JSON으로 변환
            /*
            Gson gson = new Gson();
            String jsonPostList = gson.toJson(postList);
            */

            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                            new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                    ).create();

            String jsonPostList = gson.toJson(postList);

            //JSON 데이터로 응답
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(jsonPostList);
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
            //성공했을 때
            responseMap.put("status", "success");
        } else {
            //실패했을 때
            responseMap.put("status", "fail");
            responseMap.put("message", resultMessage);
        }

        String jsonResponse = gson.toJson(responseMap);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
        }

/*
        else if (command.equals("/board/community/write.do")) {
            System.out.println("글쓰기 요청 처리");

            CommunityBoardWriteService service = new CommunityBoardWriteService();
            int result = service.execute(request, response); //(0: 실패, 1: 성공)

            //JSON으로 변환
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (result > 0) {
                //성공했을 때
                out.print("{\"status\":\"success\"}"); //JSON 형식으로 성공 메시지를 보냄
            } else {
                //실패했을 때
                out.print("{\"status\":\"fail\"}");    //JSON 형식으로 실패 메시지를 보냄
            }
            out.flush();


        }
*/



        else if (command.equals("/board/community/detail.do")) {
            //TODO: 나중에 상세보기 기능 구현
            System.out.println("상세보기 요청 처리");
        }



    }



    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }


}
