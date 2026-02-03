package com.travelroulette.Service.User.Exception;

/**
 * 인증(Authentication) 과정에서 발생하는 예외.
 * 로그인 실패, 비밀번호 불일치 등 인증에 실패했을 때 사용됩니다.
 */
public class AuthenticationException extends RuntimeException {
    public AuthenticationException(String message) {
        super(message);
    }
}
