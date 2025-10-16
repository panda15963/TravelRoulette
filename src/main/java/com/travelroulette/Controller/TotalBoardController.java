package com.travelroulette.Controller;

import com.travelroulette.Dto.TotalBoard.TotalBoardDto;
import com.travelroulette.Service.Board.Total.TotalBoardService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/totalBoard")
public class TotalBoardController extends HttpServlet {
    private final TotalBoardService totalBoardService = new TotalBoardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<TotalBoardDto> boardList = totalBoardService.getAllBoards();

        // 디버깅
        System.out.println("✅ boardList size = " + boardList.size());

        request.setAttribute("boardList", boardList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/Board/common/mainBoard.jsp");
        dispatcher.forward(request, response);
    }
}