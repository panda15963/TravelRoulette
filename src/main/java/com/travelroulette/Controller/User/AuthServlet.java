package com.travelroulette.Controller.User;

import com.travelroulette.Dao.User.JdbcUserDAO;
import com.travelroulette.Dto.User.AuthenticatedUser;
import com.travelroulette.Dto.User.UserRegistrationRequest;
import com.travelroulette.Service.User.DefaultUserService;
import com.travelroulette.Service.User.UserService;
import com.travelroulette.Service.User.Exception.AuthenticationException;
import com.travelroulette.Service.User.Exception.DuplicateUserException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AuthServlet extends HttpServlet {
    // @WebServlet은 비활성화 상태
    private final UserService userService = new DefaultUserService(new JdbcUserDAO());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("signup".equals(action)) {
            handleSignUp(request, response);
        } else if ("signin".equals(action)) {
            handleSignIn(request, response);
        } else if ("signout".equals(action)) {
            handleSignOut(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void handleSignUp(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserRegistrationRequest registrationRequest = UserRegistrationRequest.builder()
                .userId(request.getParameter("userId"))
                .rawPassword(request.getParameter("userPassword"))
                .email(request.getParameter("email"))
                .gender(request.getParameter("gender"))
                .build();

        try {
            userService.register(registrationRequest);
            response.sendRedirect(request.getContextPath() + "/pages/signIn.jsp?status=signupSuccess");
        } catch (DuplicateUserException e) {
            String duplicateType;
            switch (e.getMessage()) {
                case "USER_ID":
                    duplicateType = "idDuplicate";
                    break;
                case "EMAIL":
                    duplicateType = "emailDuplicate";
                    break;
                default:
                    duplicateType = "duplicate";
                    break;
            }
            response.sendRedirect(request.getContextPath() + "/pages/signUp.jsp?error=" + duplicateType);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/pages/signUp.jsp?error=validationFail");
        }
    }

    private void handleSignIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId");
        String rawPassword = request.getParameter("userPassword");
        String ajax = request.getParameter("ajax");

        try {
            AuthenticatedUser authenticatedUser = userService.authenticate(userId, rawPassword);
            HttpSession session = request.getSession(true);
            session.setAttribute("authenticatedUser", authenticatedUser);

            // AJAX 요청인 경우 JSON 응답
            if ("true".equals(ajax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":true,\"userId\":\"" + authenticatedUser.getUserId() + "\",\"email\":\"" + authenticatedUser.getEmail() + "\"}");
            } else {
                // 일반 폼 제출인 경우 리다이렉트
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (AuthenticationException e) {
            // AJAX 요청인 경우 JSON 응답
            if ("true".equals(ajax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"아이디 또는 비밀번호가 일치하지 않습니다.\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/signIn.jsp?error=loginFail");
            }
        }
    }

    private void handleSignOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
