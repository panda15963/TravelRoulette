package com.travelroulette.Dao.User;

import com.travelroulette.Dto.User.UserDto;

import java.util.Optional;

public interface UserDao {
    boolean existsByUserId(String userId);
    boolean existsByEmail(String email);
    Optional<UserDto> findByUserId(String userId);
    void save(UserDto user);
}
