package com.travelroulette.Controller.User.MyPage; // Updated package

import com.google.gson.JsonObject;
import com.travelroulette.Dao.User.JdbcUserDAO; // Import JdbcUserDAO
import com.travelroulette.Dao.User.MyPage.MyPageDao; // Import MyPageDao from new package
import com.travelroulette.Dto.User.AuthenticatedUser;
import com.travelroulette.Service.User.MyPage.DefaultMyPageService; // Import DefaultMyPageService from new package
import com.travelroulette.Service.User.Exception.AuthenticationException;
import com.travelroulette.Service.User.MyPage.MyPageService; // Import MyPageService from new package
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * ✅ ChangePasswordServlet (비동기 버전)
 * - currentPassword / newPassword / confirmPassword 입력받아 JSON 응답
 * - JSP 새로고침 없이 fetch()로 호출 가능
 */
/**
 * 마이페이지에서 비밀번호 변경 요청을 비동기(AJAX)로 처리하는 컨트롤러(서블릿).
 */
@WebServlet("/mypage/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private MyPageService myPageService;

    @Override
    public void init() throws ServletException {
        // Correctly instantiate DefaultMyPageService with both DAOs
        myPageService = new DefaultMyPageService(new MyPageDao(), new JdbcUserDAO());
    }

    /**
     * 비밀번호 변경 POST 요청을 받아 처리합니다.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        JsonObject result = new JsonObject();

        // ✅ 로그인 상태 확인
        AuthenticatedUser authUser = (AuthenticatedUser) req.getSession().getAttribute("authenticatedUser");
        if (authUser == null) {
            result.addProperty("success", false);
            result.addProperty("message", "로그인이 필요합니다.");
            resp.getWriter().write(result.toString());
            return;
        }

        // ✅ 요청 파라미터 받기
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            // ✅ 비밀번호 변경 서비스 호출
            boolean success = myPageService.changePassword(
                    authUser.getUserId(),
                    currentPassword,
                    newPassword,
                    confirmPassword
            );

            if (success) {
                result.addProperty("success", true);
                result.addProperty("message", "비밀번호가 성공적으로 변경되었습니다!");
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "비밀번호 변경에 실패했습니다.");
            }

        } catch (AuthenticationException e) {
            // 비밀번호 검증 실패 (현재 비번 틀림, 새 비번 불일치 등)
            result.addProperty("success", false);
            result.addProperty("message", e.getMessage());
        } catch (Exception e) {
            // 그 외 예외 처리
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "서버 오류가 발생했습니다.");
        }

        // ✅ JSON 결과 전송
        resp.getWriter().write(result.toString());
    }
}
