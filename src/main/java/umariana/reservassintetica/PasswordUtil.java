package umariana.reservassintetica;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public final class PasswordUtil {

    private static final int SALT_BYTES = 16;
    private static final String ALGO = "SHA-256";
    private static final SecureRandom RNG = new SecureRandom();

    private PasswordUtil() {
    }

    public static String hash(String plainPassword) {
        byte[] salt = new byte[SALT_BYTES];
        RNG.nextBytes(salt);
        byte[] digest = sha256(salt, plainPassword);
        return Base64.getEncoder().encodeToString(salt) + ":"
                + Base64.getEncoder().encodeToString(digest);
    }

    public static boolean verify(String plainPassword, String stored) {
        if (stored == null || !stored.contains(":")) {
            return false;
        }
        String[] parts = stored.split(":", 2);
        byte[] salt;
        byte[] expected;
        try {
            salt = Base64.getDecoder().decode(parts[0]);
            expected = Base64.getDecoder().decode(parts[1]);
        } catch (IllegalArgumentException e) {
            return false;
        }
        byte[] actual = sha256(salt, plainPassword);
        return MessageDigest.isEqual(expected, actual);
    }

    private static byte[] sha256(byte[] salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGO);
            md.update(salt);
            md.update(password.getBytes(StandardCharsets.UTF_8));
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 no disponible en la JVM", e);
        }
    }
}
