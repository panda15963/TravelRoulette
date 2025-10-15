package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.QnABoard.QnABoardPageDto;
import com.travelroulette.Service.QnABoard.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/board/qna/*")
@MultipartConfig
public class QnABoardController extends HttpServlet {

    public QnABoardController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = requestURI.substring(contextPath.length());

        System.out.println("요청 URI: " + requestURI);
        System.out.println("요청 Command: " + command);

        if (command.equals("/board/qna/list.do")) {
            System.out.println("QnA 게시판 목록 요청 처리");
            handleList(request, response);
        }
        else if (command.equals("/board/qna/write.do")) {
            System.out.println("QnA 게시글 작성 요청 처리");
            handleWrite(request, response);
        }
        else if (command.equals("/board/qna/detail.do")) {
            System.out.println("QnA 게시글 상세보기 요청 처리");
            handleDetail(request, response);
        }
        else if (command.equals("/board/qna/update.do")) {
            System.out.println("QnA 게시글 수정 요청 처리");
            handleUpdate(request, response);
        }
        else if (command.equals("/board/qna/delete.do")) {
            System.out.println("QnA 게시글 삭제 요청 처리");
            handleDelete(request, response);
        }
        else if (command.equals("/board/qna/answer/write.do")) {
            System.out.println("QnA 답글 작성 요청 처리");
            handleAnswerWrite(request, response);
        }
        else if (command.equals("/board/qna/answer/update.do")) {
            System.out.println("QnA 답글 수정 요청 처리");
            handleAnswerUpdate(request, response);
        }
        else if (command.equals("/board/qna/answer/delete.do")) {
            System.out.println("QnA 답글 삭제 요청 처리");
            handleAnswerDelete(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnABoardListService service = new QnABoardListService();
        QnABoardPageDto pageDto = service.execute(request, response);

        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                        new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                ).create();
        String jsonResponse = gson.toJson(pageDto);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private void handleWrite(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnABoardWriteService service = new QnABoardWriteService();
        String resultMessage = service.execute(request, response);

        response.setContentType("application/json; charset=UTF-8");
        Gson gson = new Gson();
        java.util.Map<String, String> responseMap = new java.util.HashMap<>();

        if (resultMessage.equals("success")) {
            responseMap.put("status", "success");
        } else {
            responseMap.put("status", "fail");
            responseMap.put("message", resultMessage);
        }

        String jsonResponse = gson.toJson(responseMap);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnABoardDetailService service = new QnABoardDetailService();
        com.travelroulette.Dto.QnABoard.QnABoardDetailDto detailDto = service.execute(request, response);

        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                        new com.google.gson.JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                ).create();
        String jsonResponse = gson.toJson(detailDto);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnABoardUpdateService service = new QnABoardUpdateService();
        String resultMessage = service.execute(request, response);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (resultMessage.equals("success")) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"fail\"}");
        }
        out.flush();
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnABoardDeleteService service = new QnABoardDeleteService();
        String resultMessage = service.execute(request, response);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (resultMessage.equals("success")) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"fail\"}");
        }
        out.flush();
    }

    private void handleAnswerWrite(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnAAnswerWriteService service = new QnAAnswerWriteService();
        String resultMessage = service.execute(request, response);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (resultMessage.equals("success")) {
            out.print("{\"status\":\"success\"}");
        } else if (resultMessage.equals("already_exists")) {
            out.print("{\"status\":\"fail\", \"message\":\"이미 답글이 존재합니다. 하나의 질문에는 하나의 답글만 작성할 수 있습니다.\"}");
        } else {
            out.print("{\"status\":\"fail\", \"message\":\"" + resultMessage + "\"}");
        }
        out.flush();
    }

    private void handleAnswerUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnAAnswerUpdateService service = new QnAAnswerUpdateService();
        String resultMessage = service.execute(request, response);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (resultMessage.equals("success")) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"fail\"}");
        }
        out.flush();
    }

    private void handleAnswerDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        QnAAnswerDeleteService service = new QnAAnswerDeleteService();
        String resultMessage = service.execute(request, response);

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (resultMessage.equals("success")) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"fail\"}");
        }
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
