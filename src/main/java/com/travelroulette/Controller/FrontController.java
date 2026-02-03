package com.travelroulette.Controller;

import com.travelroulette.Controller.User.AuthServlet;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * /auth 경로의 요청을 받아 적절한 서블릿으로 분기하는 Front Controller.
 */
@WebServlet(name = "FrontController", urlPatterns = "/auth")
public class FrontController extends HttpServlet {
    private final
    AuthServlet authServlet = new AuthServlet();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        authServlet.init(config);
    }

    /**
     * 요청 경로를 확인하여 /auth 요청을 AuthServlet으로 위임합니다.
     */
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
