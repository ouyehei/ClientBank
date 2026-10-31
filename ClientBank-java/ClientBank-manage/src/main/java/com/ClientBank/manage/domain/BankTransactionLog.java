package com.ClientBank.manage.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 用户借贷记录对象 bank_transaction_log
 *
 * @author WangAiling
 * @date 2026-10-27
 */
@Data
public class BankTransactionLog {
    private String id;
    private Long accountId;
    private Integer transactionType; // 1-借款, 2-还款
    private BigDecimal amount;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date dueDate;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
    private BigDecimal accumulatedInterest;
    private int status; // 0-未结清, 1-已结清
}
