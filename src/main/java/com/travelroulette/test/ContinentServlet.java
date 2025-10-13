package com.travelroulette.test;

import com.travelroulette.dao.ContinentDAO;
import com.travelroulette.dto.continent.ContinentDto;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/test/continents")
public class ContinentServlet extends HttpServlet {

    private ContinentDAO continentDAO;

    @Override
    public void init() {
        continentDAO = new ContinentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ContinentDto> list = continentDAO.findAll();
        request.setAttribute("continents", list);

        // JSP로 forward (결과 표시)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/continentList.jsp");
        dispatcher.forward(request, response);
    }
}