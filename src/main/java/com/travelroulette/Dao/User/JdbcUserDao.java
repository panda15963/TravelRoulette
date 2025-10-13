package com.travelroulette.Dao.User;

import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class JdbcUserDao implements UserDao {
    private static final String USER_SELECT_BY_ID =
            "SELECT userId, pwd, email, gender, salt, hashIterations\n" +
                    "FROM user\n" +
                    "WHERE user_id = ?";

    private static final String USER_EXISTS_BY_ID =
            "SELECT 1\n" +
                    "FROM user\n" +
                    "WHERE userId = ?";

    private static final String USER_EXISTS_BY_EMAIL =
            "SELECT 1\n" +
                    "FROM user\n" +
                    "WHERE email = ?";

    private static final String USER_INSERT =
            "INSERT INTO user (userId, pwd, email, gender, salt, hashIterations)\n" +
                    "VALUES (?, ?, ?, ?, ?, ?)";

    @Override
    public boolean existsByUserId(String userId) {
        return exists(userId, USER_EXISTS_BY_ID);
    }

    @Override
    public boolean existsByEmail(String email) {
        return exists(email, USER_EXISTS_BY_EMAIL);
    }

    private boolean exists(String value, String query) {
        try (Connection connection = ConnectionPoolHelper.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, value);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to execute exists query", e);
        }
    }

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
