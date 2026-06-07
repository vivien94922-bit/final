package util;

import java.security.MessageDigest;
import java.security.SecureRandom;

/**
 * 密碼雜湊工具（加分：password hash）
 *
 * 採用「加鹽 SHA-256」：
 *   雜湊值 = SHA-256( salt + 明文密碼 )  → 轉成小寫 16 進位字串
 *
 * - 不使用任何外部函式庫，只用 JDK 內建的 java.security，
 *   因此不需要額外的 jar 即可在 JSP / Servlet 中使用。
 * - 每位會員擁有獨立的 salt，避免相同密碼產生相同雜湊（防止彩虹表攻擊）。
 */
public class PasswordUtil {

    /** 產生隨機鹽值（16 bytes → 32 字 16 進位字串）。 */
    public static String generateSalt() {
        byte[] bytes = new byte[16];
        new SecureRandom().nextBytes(bytes);
        return toHex(bytes);
    }

    /** 以指定的鹽值計算密碼雜湊：SHA-256( salt + password )。 */
    public static String hash(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest((salt + password).getBytes("UTF-8"));
            return toHex(digest);
        } catch (Exception e) {
            // 理論上 SHA-256 / UTF-8 一定存在；包成 RuntimeException 方便呼叫端
            throw new RuntimeException("密碼雜湊失敗：" + e.getMessage(), e);
        }
    }

    /** 驗證：將輸入密碼以 storedSalt 雜湊後，與資料庫中的 storedHash 比對。 */
    public static boolean verify(String inputPassword, String storedSalt, String storedHash) {
        if (storedSalt == null || storedHash == null) return false;
        String computed = hash(inputPassword, storedSalt);
        return computed.equalsIgnoreCase(storedHash);
    }

    /** byte[] → 小寫 16 進位字串。 */
    private static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(Character.forDigit((b >> 4) & 0xF, 16));
            sb.append(Character.forDigit(b & 0xF, 16));
        }
        return sb.toString();
    }
}
