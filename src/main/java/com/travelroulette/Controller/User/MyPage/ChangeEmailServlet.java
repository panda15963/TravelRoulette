package com.travelroulette.Controller.User.MyPage;

import com.google.gson.JsonObject;
import com.travelroulette.Dao.User.JdbcUserDAO;
import com.travelroulette.Dao.User.MyPage.MyPageDao;
import com.travelroulette.Dto.User.AuthenticatedUser;
import com.travelroulette.Service.User.MyPage.DefaultMyPageService;
import com.travelroulette.Service.User.Exception.DuplicateUserException;
import com.travelroulette.Service.User.MyPage.MyPageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 마이페이지에서 이메일 변경 요청을 비동기(AJAX)로 처리하는 컨트롤러(서블릿).
 */
@WebServlet("/mypage/change-email")
public class ChangeEmailServlet extends HttpServlet {

    private MyPageService myPageService;

    @Override
    public void init() throws ServletException {
        myPageService = new DefaultMyPageService(new MyPageDao(), new JdbcUserDAO());
    }

    /**
     * 이메일 변경 POST 요청을 받아 처리합니다.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        JsonObject result = new JsonObject();

        AuthenticatedUser authUser = (AuthenticatedUser) req.getSession().getAttribute("authenticatedUser");
        if (authUser == null) {
            result.addProperty("success", false);

            result.addProperty("message", "로그인이 필요합니다.");
            resp.getWriter().write(result.toString());
            return;
        }

        String newEmail = req.getParameter("newEmail");

        try {
            boolean success = myPageService.updateEmail(authUser.getUserId(), newEmail);

            if (success) {
                // Create a new AuthenticatedUser with the updated email and replace in session
                AuthenticatedUser updatedAuthUser = AuthenticatedUser.builder()
                        .userId(authUser.getUserId())
                        .email(newEmail)
                        .gender(authUser.getGender())
                        .build();
                req.getSession().setAttribute("authenticatedUser", updatedAuthUser);

                result.addProperty("success", true);
                result.addProperty("message", "이메일이 성공적으로 변경되었습니다!");
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "이메일 변경에 실패했습니다.");
            }
        } catch (IllegalArgumentException e) {
            result.addProperty("success", false);
            result.addProperty("message", e.getMessage());
        } catch (DuplicateUserException e) {
            result.addProperty("success", false);
            result.addProperty("message", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "서버 오류가 발생했습니다.");
        }

        resp.getWriter().write(result.toString());
    }
}
