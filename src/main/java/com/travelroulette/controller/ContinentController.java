package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.travelroulette.Dto.Continent.ContinentDto;
import com.travelroulette.Service.ContinentService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/continent")
public class ContinentController extends HttpServlet {

    private final ContinentService service = new ContinentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json; charset=UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

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