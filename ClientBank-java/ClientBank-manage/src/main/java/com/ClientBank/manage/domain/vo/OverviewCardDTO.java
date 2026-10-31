package com.ClientBank.manage.domain.vo;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 顶部数字卡片类
 */
@Data
public class OverviewCardDTO {
    private BigDecimal currentBalance;   // 当前总可用余额
    private BigDecimal totalBorrowed;    // 累计借款总额
    private BigDecimal totalTransferOut; // 累计转账支出
}
