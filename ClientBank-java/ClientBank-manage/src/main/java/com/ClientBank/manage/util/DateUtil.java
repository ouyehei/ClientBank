package com.ClientBank.manage.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
    private static final String DEFAULT_PATTERN = "yyyy-MM-dd HH:mm:ss";

    /**
     * 时间戳转字符串，默认格式：yyyy-MM-dd HH:mm:ss
     */
    public static String format(long timestamp) {
        return format(timestamp, DEFAULT_PATTERN);
    }

    /**
     * 时间戳转字符串，指定格式
     */
    public static String format(long timestamp, String pattern) {
        return new SimpleDateFormat(pattern).format(new Date(timestamp));
    }
}
