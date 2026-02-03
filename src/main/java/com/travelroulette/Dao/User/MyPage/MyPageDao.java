package com.travelroulette.Dao.User.MyPage;

import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Utils.ConnectionPoolHelper;

import java.sql.*;

/**
 * ✅ MyPageDao
 * - 마이페이지(회원정보 조회 및 수정) 전용 DAO
 * - JdbcUserDao와 분리하여 역할 명확화
 */
public class MyPageDao {

    /**
     * ✅ 1️⃣ 회원정보 조회
     * @param userId 사용자 ID
     * @return UserDto (비밀번호 포함 — 비밀번호 검증용)
     */
    public UserDto findByUserId(String userId) {
        String sql = "SELECT userId, pwd, email, gender, salt, hashIterations FROM User WHERE userId = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return UserDto.builder()
                        .userId(rs.getString("userId"))
                        .pwd(rs.getString("pwd"))
                        .email(rs.getString("email"))
                        .gender(rs.getString("gender"))
                        .salt(rs.getString("salt"))
                        .hashIterations(rs.getInt("hashIterations"))
                        .build();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ 2️⃣ 이메일 변경
     * @param userId 사용자 ID
     * @param newEmail 새 이메일
     * @return 변경 성공 여부
     */
    public boolean updateEmail(String userId, String newEmail) {
        String sql = "UPDATE User SET email = ? WHERE userId = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newEmail);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ 3️⃣ 비밀번호 변경
     * (Service 계층에서 이미 해시 처리 완료)
     * @param userId 사용자 ID
     * @param hashedPwd 해시된 비밀번호
     * @param salt 새 솔트
     * @param iterations 반복 횟수
     * @return 변경 성공 여부
     */
    public boolean updatePassword(String userId, String hashedPwd, String salt, int iterations) {
        String sql = "UPDATE User SET pwd = ?, salt = ?, hashIterations = ? WHERE userId = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPwd);
            ps.setString(2, salt);
            ps.setInt(3, iterations);
            ps.setString(4, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ 4️⃣ 성별 변경
     * @param userId 사용자 ID
     * @param newGender 새 성별
     * @return 변경 성공 여부
     */
    public boolean updateGender(String userId, String newGender) {
        String sql = "UPDATE User SET gender = ? WHERE userId = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newGender);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
