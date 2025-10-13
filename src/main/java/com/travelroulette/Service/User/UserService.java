package com.travelroulette.Service.User;

import com.travelroulette.Dto.User.AuthenticatedUser;
import com.travelroulette.Dto.User.UserRegistrationRequest;

public interface UserService {
    void register(UserRegistrationRequest request);
    AuthenticatedUser authenticate(String userId, String rawPassword);
}
