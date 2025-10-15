package com.travelroulette.Service.User;

import com.travelroulette.Dao.User.MyPageDao;
import com.travelroulette.Dto.User.UserDto;
import com.travelroulette.Service.User.Exception.AuthenticationException;
import com.travelroulette.Utils.User.PasswordHasher;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import java.util.Objects;

/**
 * ✅ DefaultMyPageService
 * - 마이페이지(회원 정보 관리) 전용 서비스
 * - 회원가입/로그인 시 사용된 PasswordHasher 알고리즘과 동일한 방식으로 비밀번호 처리
 */
@RequiredArgsConstructor
public class DefaultMyPageService implements MyPageService {

    @NonNull
    private final MyPageDao myPageDao;

    /**
     * ✅ 1️⃣ 회원 정보 조회
     */
    @Override
    public UserDto getUserInfo(String userId) {
        Objects.requireNonNull(userId, "userId must not be null");
        return myPageDao.findByUserId(userId);
    }

    /**
     * ✅ 2️⃣ 이메일 변경
     */
    @Override
    public boolean updateEmail(String userId, String newEmail) {
        Objects.requireNonNull(userId, "userId must not be null");
        Objects.requireNonNull(newEmail, "newEmail must not be null");
        return myPageDao.updateEmail(userId, newEmail);
    }

    /**
     * ✅ 3️⃣ 비밀번호 변경
     * - 현재 비밀번호 검증 후, 새 비밀번호 해시 생성 & DB 저장
     * - 회원가입 시의 PasswordHasher 로직과 동일하게 작동
     */
    @Override
    public boolean changePassword(String userId, String currentPassword, String newPassword, String confirmPassword)
            throws AuthenticationException {

        // 1️⃣ 입력값 검증
        if (userId == null || currentPassword == null || newPassword == null || confirmPassword == null) {
            throw new IllegalArgumentException("입력값이 비어 있습니다.");
        }

        // 2️⃣ 새 비밀번호와 확인 비밀번호 일치 확인
        if (!newPassword.equals(confirmPassword)) {
            throw new AuthenticationException("새 비밀번호가 일치하지 않습니다.");
        }

        // 3️⃣ DB에서 유저 정보 조회
        UserDto user = myPageDao.findByUserId(userId);
        if (user == null) {
            throw new AuthenticationException("사용자 정보를 찾을 수 없습니다.");
        }

        // 4️⃣ 현재 비밀번호 검증 (회원가입 때와 동일한 해시 알고리즘)
        boolean valid = PasswordHasher.hashPassword(
                currentPassword.toCharArray(),
                user.getSalt(),
                user.getHashIterations()
        ).equals(user.getPwd());

        if (!valid) {
            throw new AuthenticationException("현재 비밀번호가 일치하지 않습니다.");
        }

        // 5️⃣ 새 비밀번호 해시 생성 (회원가입 로직과 동일)
        String newSalt = PasswordHasher.generateSalt();
        int newIterations = PasswordHasher.getDefaultIterations();
        String newHashedPassword = PasswordHasher.hashPassword(
                newPassword.toCharArray(),
                newSalt,
                newIterations
        );

        // 6️⃣ DAO 호출 — 해시된 비밀번호 저장
        return myPageDao.updatePassword(userId, newHashedPassword, newSalt, newIterations);
    }

    /**
     * ✅ 4️⃣ 성별 변경
     */
    @Override
    public boolean updateGender(String userId, String newGender) {
        Objects.requireNonNull(userId, "userId must not be null");
        Objects.requireNonNull(newGender, "newGender must not be null");
        return myPageDao.updateGender(userId, newGender);
    }
}
