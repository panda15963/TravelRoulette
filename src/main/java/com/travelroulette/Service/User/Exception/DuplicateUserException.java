package com.travelroulette.Service.User.Exception;

/**
 * 데이터 중복 시 발생하는 예외.
 * 회원가입 시 아이디나 이메일이 이미 존재할 경우에 사용됩니다.
 */
public class DuplicateUserException extends RuntimeException {
    public DuplicateUserException(String message) {
        super(message);
    }
}
