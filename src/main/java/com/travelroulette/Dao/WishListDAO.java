package com.travelroulette.Dao;

import com.travelroulette.Utils.ConnectionPoolHelper;
import java.sql.*;
import java.util.*;

public class WishListDAO {

    // ✅ 위시리스트 상태 업데이트 (추가 / 제거)
    public String updateWishList(String userId, String countryCode, boolean check) {
        try (Connection conn = ConnectionPoolHelper.getConnection()) {

            if (check) {
                // ✅ 추가 (중복 시 무시)
                String sql = "INSERT IGNORE INTO list_of_countries (userId, countryCode, checkContWishList) VALUES (?, ?, 1)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, userId);
                    ps.setString(2, countryCode);
                    int rows = ps.executeUpdate();
                    return (rows > 0) ? "success" : "duplicate";
                }

            } else {
                // ✅ 삭제 (완전히 제거)
                String sql = "DELETE FROM list_of_countries WHERE userId = ? AND countryCode = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, userId);
                    ps.setString(2, countryCode);
                    int rows = ps.executeUpdate();
                    return (rows > 0) ? "success" : "fail";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    // ✅ 위시리스트 목록 조회
    public List<Map<String, String>> getWishList(String userId) {
        List<Map<String, String>> list = new ArrayList<>();

        String sql = """
            SELECT c.countryCode,
                   c.countryNameKor AS countryName,
                   t.continentNameKor AS continentName,
                   c.flagURL
            FROM list_of_countries lc
            JOIN country c ON lc.countryCode = c.countryCode
            JOIN continent t ON c.continentNumber = t.continentNumber
            WHERE lc.userId = ? AND lc.checkContWishList = 1
        """;

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("countryCode", rs.getString("countryCode"));
                    item.put("countryName", rs.getString("countryName"));
                    item.put("continentName", rs.getString("continentName"));
                    item.put("flagURL", rs.getString("flagURL"));
                    list.add(item);
                }
            }

            System.out.println("📤 [WishListDAO] " + userId + "의 위시리스트 조회 완료 (" + list.size() + "개)");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}