package com.ClientBank.manage.service;

import com.ClientBank.manage.domain.BankTransactionLog;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 用户转账记录接口
 *
 */
public interface IBankTransactionLogService {
    /*新增转账记录*/
    public int insertBankTransactionLog(BankTransactionLog log);

//    /** 定时任务：每日更新利息 */
//    public void updateDailyInterest();

    @Transactional(rollbackFor = Exception.class)
    int repayLoan(String loanId, BigDecimal repayAmount);

    /** 查询账户未结清负债总额（前端获取应还金额用） */
    public List<BankTransactionLog> selectUnpaidLoansByAccountId(Long accountId);

    /**
     * 查询该账户下所有欠款本息相加的总额
     * */
    public Double selectTotalDebtByAccountId(Long accountId);

}
