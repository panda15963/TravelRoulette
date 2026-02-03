package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.travelroulette.Dao.WishListDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/wishlist")
public class WishListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WishListDAO dao = new WishListDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String userId = request.getParameter("userId");
        String countryCode = request.getParameter("countryCode");
        boolean check = Boolean.parseBoolean(request.getParameter("checkContWishList"));

        System.out.println("📩 [WishListController] userId = " + userId);
        System.out.println("📩 [WishListController] countryCode = " + countryCode);
        System.out.println("📩 [WishListController] checkContWishList = " + check);

        // ✅ DAO 실행 결과값 받기 (문자열로 반환하도록 수정)
        String result = dao.updateWishList(userId, countryCode, check);

        switch (result) {
            case "success":
                response.getWriter().write("{\"status\":\"success\"}");
                System.out.println("✅ 위시리스트 추가 성공");
                break;
            case "duplicate":
                response.getWriter().write("{\"status\":\"duplicate\"}");
                System.out.println("⚠️ 이미 위시리스트에 존재");
                break;
            default:
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"fail\"}");
                System.out.println("❌ 위시리스트 저장 실패");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String userId = request.getParameter("userId");
        List<Map<String, String>> list = dao.getWishList(userId);

        String json = new Gson().toJson(list);
        response.getWriter().write(json);
    }
}