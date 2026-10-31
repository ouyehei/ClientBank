package com.ClientBank.manage.util;

import java.util.concurrent.ThreadLocalRandom;

public class RandomUtil {
    public static String next10() {
        StringBuilder sb = new StringBuilder(10);
        ThreadLocalRandom random = ThreadLocalRandom.current();
        for (int i = 0; i < 10; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
}
