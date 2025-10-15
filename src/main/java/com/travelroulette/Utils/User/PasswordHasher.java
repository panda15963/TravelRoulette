package com.travelroulette.Utils.User;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;

/**
 * PBKDF2 알고리즘과 Salt를 사용하여 안전한 비밀번호 해시를 생성하고 검증하는 유틸리티 클래스.
 * 이 클래스의 목적은 무차별 대입 공격(Brute-force attack)과 레인보우 테이블 공격을 어렵게 만드는 것입니다.
 */
public class PasswordHasher {

    // --- 보안 설정 상수 ---

    /** PBKDF2 솔트 바이트 길이. 솔트는 동일한 비밀번호라도 다른 해시 값을 갖도록 하여 레인보우 테이블 공격을 방지합니다. */
    private static final int SALT_LENGTH_BYTES = 32;

    /** PBKDF2 반복 횟수. 값이 높을수록 무차별 대입 공격에 대한 저항이 강해지지만, 해시 생성 시간이 길어집니다. */
    private static final int HASH_ITERATIONS = 120_000;

    /** 생성될 해시의 비트 길이 (256비트 = 32바이트). */
    private static final int HASH_KEY_LENGTH_BITS = 256;

    /** 사용할 해시 알고리즘. */
    private static final String HASH_ALGORITHM = "PBKDF2WithHmacSHA256";

    private PasswordHasher() {
        // 유틸리티 클래스는 인스턴스화하지 않습니다.
    }

    /**
     * ✅ 비밀번호 해싱에 사용할 안전한 랜덤 솔트(salt)를 생성합니다.
     * @return 16진수 문자열로 인코딩된 솔트
     */
    public static String generateSalt() {
        byte[] salt = new byte[SALT_LENGTH_BYTES];
        new SecureRandom().nextBytes(salt);
        return toHex(salt);
    }

    /**
     * ✅ 시스템의 기본 PBKDF2 반복 횟수를 반환합니다.
     * @return 기본 반복 횟수
     */
    public static int getDefaultIterations() {
        return HASH_ITERATIONS;
    }

    // 기본 반복 횟수를 사용하여 해싱하는 편의 메소드.
    public static String hashPassword(char[] password, String hexSalt) {
        return hashPassword(password, hexSalt, HASH_ITERATIONS);
    }

    /**
     * ✅ PBKDF2WithHmacSHA256 알고리즘을 사용하여 비밀번호를 해싱합니다.
     * 이 과정은 의도적으로 느리게 설계되어 무차별 대입 공격을 어렵게 만듭니다.
     * @param password 해싱할 원본 비밀번호
     * @param hexSalt 해싱에 사용할 16진수 문자열 솔트
     * @param iterations 해시 함수 반복 횟수
     * @return 16진수 문자열로 인코딩된 최종 해시 값
     */
    public static String hashPassword(char[] password, String hexSalt, int iterations) {
        byte[] salt = fromHex(hexSalt);
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, HASH_KEY_LENGTH_BITS);
        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance(HASH_ALGORITHM);
            byte[] hash = skf.generateSecret(spec).getEncoded();
            return toHex(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("Failed to hash password", e);
        } finally {
            spec.clearPassword(); // 메모리에서 비밀번호 즉시 제거
        }
    }

    /**
     * (내부 유틸) 바이트 배열을 16진수 문자열 표현으로 변환하는 헬퍼 메소드.
     */
    private static String toHex(byte[] bytes) {
        StringBuilder builder = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                builder.append('0');
            }
            builder.append(hex);
        }
        return builder.toString();
    }

    /**
     * (내부 유틸) 16진수 문자열을 바이트 배열로 변환하는 헬퍼 메소드.
     */
    private static byte[] fromHex(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i + 1), 16));
        }
        return data;
    }
}