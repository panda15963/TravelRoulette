package com.travelroulette.Dao.User;

import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

/**
 * UserDAO 인터페이스의 JDBC 구현체.
 * User 테이블에 대한 실제 SQL 쿼리를 수행합니다.
 */
public class JdbcUserDAO implements UserDAO {
    private static final String USER_SELECT_BY_ID =
            "SELECT userId, pwd, email, gender, salt, hashIterations\n" +
                    "FROM User\n" +
                    "WHERE userId = ?";

    private static final String USER_EXISTS_BY_ID =
            "SELECT 1\n" +
                    "FROM User\n" +
                    "WHERE userId = ?";

    private static final String USER_EXISTS_BY_EMAIL =
            "SELECT 1\n" +
                    "FROM User\n" +
                    "WHERE email = ?";

    private static final String USER_INSERT =
            "INSERT INTO User (userId, pwd, email, gender, salt, hashIterations)\n" +
                    "VALUES (?, ?, ?, ?, ?, ?)";

    /**
     * ✅ 아이디로 사용자 존재 여부 확인
     */
    @Override
    public boolean existsByUserId(String userId) {
        return exists(userId, USER_EXISTS_BY_ID);
    }

    /**
     * ✅ 이메일로 사용자 존재 여부 확인
     */
    @Override
    public boolean existsByEmail(String email) {
        return exists(email, USER_EXISTS_BY_EMAIL);
    }

    private boolean exists(String value, String query) {
        // Logging for debugging
        System.out.println("[DEBUG] Executing exists query. Input value: " + value);

        try (Connection connection = ConnectionPoolHelper.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, value);
            try (ResultSet resultSet = statement.executeQuery()) {
                boolean result = resultSet.next();
                // Logging for debugging
                System.out.println("[DEBUG] Query result for '" + value + "': " + (result ? "Exists" : "Does not exist"));
                return result;
            }
        } catch (SQLException e) {
            // Logging for debugging
            System.err.println("[ERROR] Failed to execute exists query for value: " + value);
            e.printStackTrace();
            throw new RuntimeException("Failed to execute exists query", e);
        }
    }

    /**
     * ✅ 아이디로 사용자 정보 조회
     */
    @Override
    public Optional<UserDto> findByUserId(String userId) {
        try (Connection connection = ConnectionPoolHelper.getConnection();
             PreparedStatement statement = connection.prepareStatement(USER_SELECT_BY_ID)) {
            statement.setString(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return Optional.empty();
                }
                return Optional.of(mapRow(resultSet));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find user by id", e);
        }
    }

    /**
     * ✅ 새 사용자 정보 저장
     */
    @Override
    public void save(UserDto user) {
        try (Connection connection = ConnectionPoolHelper.getConnection();
             PreparedStatement statement = connection.prepareStatement(USER_INSERT)) {
            statement.setString(1, user.getUserId());
            statement.setString(2, user.getPwd());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getGender());
            statement.setString(5, user.getSalt());
            statement.setInt(6, user.getHashIterations());
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save user", e);
        }
    }

    private static final String USER_UPDATE_PASSWORD =
            "UPDATE User SET pwd = ?, salt = ?, hashIterations = ? WHERE userId = ?";

    private static final String USER_UPDATE_EMAIL =
            "UPDATE User SET email = ? WHERE userId = ?";

    /**
     * ✅ 사용자의 비밀번호 변경
     */
    @Override
    public boolean updatePassword(String userId, String newHashedPassword, String newSalt, int newHashIterations) {
        try (Connection connection = ConnectionPoolHelper.getConnection();
             PreparedStatement statement = connection.prepareStatement(USER_UPDATE_PASSWORD)) {
            statement.setString(1, newHashedPassword);
            statement.setString(2, newSalt);
            statement.setInt(3, newHashIterations);
            statement.setString(4, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update password for user: " + userId, e);
        }
    }

    /**
     * ✅ 사용자의 이메일 변경
     */
    @Override
    public boolean updateEmail(String userId, String newEmail) {
        try (Connection connection = ConnectionPoolHelper.getConnection();
             PreparedStatement statement = connection.prepareStatement(USER_UPDATE_EMAIL)) {
            statement.setString(1, newEmail);
            statement.setString(2, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update email for user: " + userId, e);
        }
    }

    private UserDto mapRow(ResultSet resultSet) throws SQLException {
        return UserDto.builder()
                .userId(resultSet.getString("userId"))
                .pwd(resultSet.getString("pwd"))
                .email(resultSet.getString("email"))
                .gender(resultSet.getString("gender"))
                .salt(resultSet.getString("salt"))
                .hashIterations(resultSet.getInt("hashIterations"))
                .build();
    }
}
