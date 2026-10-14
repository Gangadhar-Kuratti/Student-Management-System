
package com.sms;

import java.security.SecureRandom;
import javax.crypto.spec.PBEKeySpec;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;

public class PasswordUtil {

    private static final int ITERATIONS = 210000;
    private static final int KEY_LENGTH = 256;
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String hash(String password) throws Exception {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            ITERATIONS,
            KEY_LENGTH
        );

        byte[] hash = SecretKeyFactory
            .getInstance("PBKDF2WithHmacSHA256")
            .generateSecret(spec)
            .getEncoded();

        spec.clearPassword();

        return ITERATIONS + ":"
            + Base64.getEncoder().encodeToString(salt) + ":"
            + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean verify(String password, String stored)
            throws Exception {

        String[] parts = stored.split(":");
        int iterations = Integer.parseInt(parts[0]);
        byte[] salt = Base64.getDecoder().decode(parts[1]);
        byte[] expected = Base64.getDecoder().decode(parts[2]);

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            iterations,
            expected.length * 8
        );

        byte[] actual = SecretKeyFactory
            .getInstance("PBKDF2WithHmacSHA256")
            .generateSecret(spec)
            .getEncoded();

        spec.clearPassword();

        if (actual.length != expected.length) {
            return false;
        }

        int difference = 0;

        for (int i = 0; i < actual.length; i++) {
            difference |= actual[i] ^ expected[i];
        }

        return difference == 0;
    }
}
