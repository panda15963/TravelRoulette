package com.travelroulette.controller;

import com.google.gson.Gson;
import com.travelroulette.dto.continent.ContinentDto;
import com.travelroulette.service.ContinentService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ContinentController extends HttpServlet {

    private final ContinentService service = new ContinentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");
        Gson gson = new Gson();

        try {
            List<ContinentDto> list = service.getAllContinents();
            String json = gson.toJson(list);
            resp.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"서버 내부 오류\"}");
        }
    }
}