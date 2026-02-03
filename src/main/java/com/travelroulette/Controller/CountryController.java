package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.travelroulette.Dto.Country.CountryDto;
import com.travelroulette.Service.CountryService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/countries")
public class CountryController extends HttpServlet {

    private final CountryService service = new CountryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json; charset=UTF-8");
        Gson gson = new Gson();

        try {
            // 🌍 continentNumber 파라미터 받기
            String continentNumStr = req.getParameter("continentNumber");
            if (continentNumStr == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"continentNumber parameter is required\"}");
                return;
            }

            int continentNumber = Integer.parseInt(continentNumStr);

            List<CountryDto> list = service.getCountriesByContinent(continentNumber);
            String json = gson.toJson(list);
            resp.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"서버 내부 오류\"}");
        }
    }
}