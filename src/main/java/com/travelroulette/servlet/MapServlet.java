package com.travelroulette.servlet;

import com.travelroulette.config.ConfigLoader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/map")
public class MapServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String apiKey = ConfigLoader.get("google.maps.api.key"); // properties에서 불러오기
        req.setAttribute("googleMapsApiKey", apiKey);
        req.getRequestDispatcher("/pages/map.jsp").forward(req, resp);
    }
}