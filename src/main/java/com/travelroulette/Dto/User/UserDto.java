package com.travelroulette.Dto.User;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {
    private String userId;
    private String pwd;
    private String email;
    private String gender;
    private String salt;
    private int hashIterations;
}
