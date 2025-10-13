package com.travelroulette.Dto.User;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AuthenticatedUser {
    private String userId;
    private String email;
    private String gender;
}
