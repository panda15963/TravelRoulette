package com.travelroulette.Utils.User;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;

public class PasswordHasher {
    private static final int SALT_LENGTH_BYTES = 32; //솔트 길이(바이트)
    private static final int HASH_ITERATIONS = 120_000; //PBKDF2 반복 횟수
    private static final int HASH_KEY_LENGTH_BITS = 256; //생성할 해시 길이(비트)
    private static final String HASH_ALGORITHM = "PBKDF2WithHmacSHA256"; // 해시 알고리즘 식별자

    private PasswordHasher() {
    }

    public static String generateSalt() {
        byte[] salt = new byte[SALT_LENGTH_BYTES];
        new SecureRandom().nextBytes(salt);
        return toHex(salt);
    }

    public static int getDefaultIterations() {
        return HASH_ITERATIONS;
    }

    public static String hashPassword(char[] password, String hexSalt) {
        return hashPassword(password, hexSalt, HASH_ITERATIONS);
    }

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
            spec.clearPassword();
        }
    }

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
