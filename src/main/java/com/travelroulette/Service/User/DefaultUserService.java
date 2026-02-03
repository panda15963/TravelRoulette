package com.travelroulette.Service.User;

import com.travelroulette.Dao.User.UserDAO;
import com.travelroulette.Dto.User.AuthenticatedUser;
import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Dto.User.UserRegistrationRequest;
import com.travelroulette.Service.User.Exception.AuthenticationException;
import com.travelroulette.Service.User.Exception.DuplicateUserException;
import com.travelroulette.Utils.User.PasswordHasher;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import java.util.Objects;

/**
 * ✅ DefaultUserService
 * - 회원가입(register)
 * - 로그인(authenticate)
 * 
 * 역할:
 *   • 비밀번호 해시 처리 (PasswordHasher)
 *   • 입력값 검증
 *   • 중복 유저 확인
 *   • 인증 성공 시 AuthenticatedUser 반환
 */
/**
 * UserService의 구현체.
 * 사용자 등록(회원가입) 및 인증(로그인) 관련 비즈니스 로직을 처리합니다.
 */
@RequiredArgsConstructor
public class DefaultUserService implements UserService {

    // DAO 의존성 주입 (DB 접근)
    @NonNull
    private final UserDAO userDao;

    /**
     * ✅ 회원가입 기능
     * @param request 회원가입 시 입력받은 데이터 (userId, password, email, gender 등)
     */
    /**
     * ✅ 회원가입 처리
     */
    @Override
    public void register(UserRegistrationRequest request) {
        // 1️⃣ null 검증
        Objects.requireNonNull(request);

        // 2️⃣ 필수 필드 검증 (아이디/비밀번호/이메일이 비어있는지)
        validateRegistrationRequest(request);

        // 3️⃣ 아이디 중복 확인
        if (userDao.existsByUserId(request.getUserId())) {
            throw new DuplicateUserException("USER_ID");
        }

        // 4️⃣ 이메일 중복 확인
        if (userDao.existsByEmail(request.getEmail())) {
            throw new DuplicateUserException("EMAIL");
        }

        // 5️⃣ 비밀번호 해시 생성 (솔트 + 반복횟수 적용)
        String salt = PasswordHasher.generateSalt();                       // 랜덤 솔트 생성
        int hashIterations = PasswordHasher.getDefaultIterations();         // 기본 반복 횟수 (120,000회)
        String hashedPassword = PasswordHasher.hashPassword(                // PBKDF2 해시 생성
                request.getRawPassword().toCharArray(),
                salt,
                hashIterations
        );

        // 6️⃣ DTO 생성 (비밀번호는 해시된 상태로 저장)
        UserDto user = UserDto.builder()
                .userId(request.getUserId())
                .pwd(hashedPassword)    // 해시된 비밀번호 저장
                .email(request.getEmail())
                .gender(request.getGender())
                .salt(salt)             // 솔트 저장 (비밀번호 검증 시 필요)
                .hashIterations(hashIterations) // 반복 횟수 저장
                .build();

        // 7️⃣ DB에 저장
        userDao.save(user);
    }

    /**
     * ✅ 로그인(인증) 기능
     * @param userId 사용자 아이디
     * @param rawPassword 사용자가 입력한 비밀번호 (평문)
     * @return 인증된 사용자 정보 (AuthenticatedUser)
     */
    /**
     * ✅ 로그인(인증) 처리
     */
    @Override
    public AuthenticatedUser authenticate(String userId, String rawPassword) {
        // 1️⃣ 입력값 검증
        if (userId == null || rawPassword == null) {
            throw new AuthenticationException("Invalid credential input");
        }

        // 2️⃣ DB에서 사용자 정보 조회 (없으면 예외)
        UserDto user = userDao.findByUserId(userId)
                .orElseThrow(() -> new AuthenticationException("User not found"));

        // 3️⃣ 입력 비밀번호 해시 (DB 저장 시 사용된 솔트 + 반복횟수로 동일하게 해시)
        String hashedPassword = PasswordHasher.hashPassword(
                rawPassword.toCharArray(),
                user.getSalt(),
                user.getHashIterations()
        );

        // 4️⃣ 해시 결과가 DB의 비밀번호와 다르면 로그인 실패
        if (!hashedPassword.equals(user.getPwd())) {
            throw new AuthenticationException("Invalid credentials");
        }

        // 5️⃣ 인증 성공 시 비밀번호를 제외한 사용자 정보만 담아 반환
        return AuthenticatedUser.builder()
                .userId(user.getUserId())
                .email(user.getEmail())
                .gender(user.getGender())
                .build();
    }

    /**
     * ✅ 회원가입 필수 입력값 검증
     * @throws IllegalArgumentException 필수 필드가 누락된 경우
     */
    private void validateRegistrationRequest(UserRegistrationRequest request) {
        if (isBlank(request.getUserId()) || isBlank(request.getRawPassword()) || isBlank(request.getEmail())) {
            throw new IllegalArgumentException("Required fields missing");
        }
    }

    /**
     * ✅ 문자열 공백 검증 유틸
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * ✅ 아이디 존재 여부 확인
     */
    @Override
    public boolean existsByUserId(String userId) {
        return userDao.existsByUserId(userId);
    }

    /**
     * ✅ 이메일 존재 여부 확인
     */
    @Override
    public boolean existsByEmail(String email) {
        return userDao.existsByEmail(email);
    }
}
