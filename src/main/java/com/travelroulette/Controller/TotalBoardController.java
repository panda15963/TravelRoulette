package com.travelroulette.Controller;

import com.travelroulette.Dto.TotalBoard.TotalBoardPageDto;
import com.travelroulette.Service.Board.Total.TotalBoardService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/totalBoard")
public class TotalBoardController extends HttpServlet {
    private final TotalBoardService totalBoardService = new TotalBoardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ page 파라미터 기본값 1
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        // ✅ 페이지 데이터 가져오기
        TotalBoardPageDto pageData = totalBoardService.getPagedPosts(page);

        // ✅ JSP에 전달
        request.setAttribute("pageData", pageData);

        // ✅ 디버깅
        System.out.println("✅ Total posts = " + pageData.getTotalPostCount());
        System.out.println("✅ Current page = " + pageData.getCurrentPage());
        System.out.println("✅ Posts in this page = " + pageData.getPosts().size());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/board/common/mainBoard.jsp");
        dispatcher.forward(request, response);
    }
}