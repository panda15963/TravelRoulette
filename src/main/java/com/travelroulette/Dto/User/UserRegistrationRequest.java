package com.travelroulette.Dto.User;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserRegistrationRequest {
    private String userId;
    private String rawPassword;
    private String email;
    private String gender;
}
