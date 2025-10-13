package com.travelroulette.Service.User;

import com.travelroulette.Dao.User.UserDao;
import com.travelroulette.Dto.User.AuthenticatedUser;
import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Dto.User.UserRegistrationRequest;
import com.travelroulette.Service.User.Exception.AuthenticationException;
import com.travelroulette.Service.User.Exception.DuplicateUserException;
import com.travelroulette.Utils.User.PasswordHasher;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import java.util.Objects;

@RequiredArgsConstructor
public class DefaultUserService implements UserService {
    @NonNull
    private final UserDao userDao;

    @Override
    public void register(UserRegistrationRequest request) {
        Objects.requireNonNull(request);

        validateRegistrationRequest(request);

        if (userDao.existsByUserId(request.getUserId())) {
            throw new DuplicateUserException("USER_ID");
        }
        if (userDao.existsByEmail(request.getEmail())) {
            throw new DuplicateUserException("EMAIL");
        }

        String salt = PasswordHasher.generateSalt();
        int hashIterations = PasswordHasher.getDefaultIterations();
        String hashedPassword = PasswordHasher.hashPassword(request.getRawPassword().toCharArray(), salt, hashIterations);

        UserDto user = UserDto.builder()
                .userId(request.getUserId())
                .pwd(hashedPassword)
                .email(request.getEmail())
                .gender(request.getGender())
                .salt(salt)
                .hashIterations(hashIterations)
                .build();
        userDao.save(user);
    }

    @Override
    public AuthenticatedUser authenticate(String userId, String rawPassword) {
        if (userId == null || rawPassword == null) {
            throw new AuthenticationException("Invalid credential input");
        }

        UserDto user = userDao.findByUserId(userId)
                .orElseThrow(() -> new AuthenticationException("User not found"));

        String hashedPassword = PasswordHasher.hashPassword(
                rawPassword.toCharArray(),
                user.getSalt(),
                user.getHashIterations()
        );
        if (!hashedPassword.equals(user.getPwd())) {
            throw new AuthenticationException("Invalid credentials");
        }

        return AuthenticatedUser.builder()
                .userId(user.getUserId())
                .email(user.getEmail())
                .gender(user.getGender())
                .build();
    }

    private void validateRegistrationRequest(UserRegistrationRequest request) {
        if (isBlank(request.getUserId()) || isBlank(request.getRawPassword()) || isBlank(request.getEmail())) {
            throw new IllegalArgumentException("Required fields missing");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
