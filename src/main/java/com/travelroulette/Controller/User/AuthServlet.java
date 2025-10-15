package com.travelroulette.Controller.User;

import com.google.gson.JsonObject; // Import JsonObject
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

/**
 * 사용자 인증(회원가입, 로그인, 로그아웃) 및 중복 확인 요청을 처리하는 컨트롤러(서블릿).
 */
public class AuthServlet extends HttpServlet {
    // @WebServlet은 비활성화 상태
    private final UserService userService = new DefaultUserService(new JdbcUserDAO());

    /**
     * action 파라미터에 따라 회원가입, 로그인, 로그아웃 등의 처리를 분기합니다.
     */
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
        } else if ("checkUserIdDuplicate".equals(action)) { // New action for user ID duplication check
            handleCheckUserIdDuplicate(request, response);
        } else if ("checkEmailDuplicate".equals(action)) { // New action for email duplication check
            handleCheckEmailDuplicate(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    /**
     * 회원가입 요청을 처리합니다.
     */
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

    /**
     * 로그인 요청을 처리합니다.
     */
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

    /**
     * 로그아웃 요청을 처리합니다.
     */
    private void handleSignOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    // New method to handle user ID duplication check
    /**
     * 아이디 중복 확인 요청을 비동기로 처리합니다.
     */
    private void handleCheckUserIdDuplicate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject result = new JsonObject();

        String userId = request.getParameter("userId");
        if (userId == null || userId.trim().isEmpty()) {
            result.addProperty("isDuplicate", true); // Treat empty as duplicate or invalid
            result.addProperty("message", "아이디를 입력해주세요.");
        } else {
            boolean isDuplicate = userService.existsByUserId(userId);
            result.addProperty("isDuplicate", isDuplicate);
            if (isDuplicate) {
                result.addProperty("message", "이미 사용 중인 아이디입니다.");
            } else {
                result.addProperty("message", "사용 가능한 아이디입니다.");
            }
        }
        response.getWriter().write(result.toString());
    }

    // New method to handle email duplication check
    /**
     * 이메일 중복 확인 요청을 비동기로 처리합니다.
     */
    private void handleCheckEmailDuplicate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject result = new JsonObject();

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            result.addProperty("isDuplicate", true); // Treat empty as duplicate or invalid
            result.addProperty("message", "이메일을 입력해주세요.");
        }
        else {
            boolean isDuplicate = userService.existsByEmail(email);
            result.addProperty("isDuplicate", isDuplicate);
            if (isDuplicate) {
                result.addProperty("message", "이미 사용 중인 이메일입니다.");
            } else {
                result.addProperty("message", "사용 가능한 이메일입니다.");
            }
        }
        response.getWriter().write(result.toString());
    }
}
