package com.travelroulette.test;

import com.travelroulette.Utils.ConnectionPoolHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.Connection;

@WebServlet("/dbtest")
public class DBTestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = ConnectionPoolHelper.getConnection()) {
            resp.setContentType("text/plain");
            resp.getWriter().println("Connection OK: " + (conn != null && !conn.isClosed()));
        } catch (Exception e) {
            resp.setContentType("text/plain");
            resp.getWriter().println("Connection failed: " + e.getMessage());
            e.printStackTrace(resp.getWriter());
        }
    }
}