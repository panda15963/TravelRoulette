package com.travelroulette.Controller;

import com.travelroulette.Controller.User.AuthServlet;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AuthController", urlPatterns = "/auth")
public class AuthController extends HttpServlet {
    private final AuthServlet authServlet = new AuthServlet();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        authServlet.init(config);
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/auth".equals(servletPath)) {
            authServlet.service(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    public void destroy() {
        authServlet.destroy();
        super.destroy();
    }
}
