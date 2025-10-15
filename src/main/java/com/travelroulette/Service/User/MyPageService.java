package com.travelroulette.Service.User;

import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Service.User.Exception.AuthenticationException;

public interface MyPageService {

    // 회원 정보 조회
    UserDto getUserInfo(String userId);

    // 이메일 변경
    boolean updateEmail(String userId, String newEmail);

    // 비밀번호 변경 (현재 비밀번호 검증 + 새 비밀번호 해시 저장)
    boolean changePassword(String userId, String currentPassword, String newPassword, String confirmPassword)
            throws AuthenticationException;

    // 성별 변경
    boolean updateGender(String userId, String newGender);
}
