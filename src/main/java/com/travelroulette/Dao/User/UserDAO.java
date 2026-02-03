package com.travelroulette.Dao.User;

import com.travelroulette.Dto.User.UserDto;

import java.util.Optional;

public interface UserDAO {
    boolean existsByUserId(String userId);
    boolean existsByEmail(String email);
    Optional<UserDto> findByUserId(String userId);
    void save(UserDto user);
    boolean updatePassword(String userId, String newHashedPassword, String newSalt, int newHashIterations);
    boolean updateEmail(String userId, String newEmail);
}
