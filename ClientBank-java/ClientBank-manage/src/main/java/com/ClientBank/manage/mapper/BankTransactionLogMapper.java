package com.ClientBank.manage.mapper;

import com.ClientBank.manage.domain.BankTransactionLog;

import java.util.List;

public interface BankTransactionLogMapper {
    public int insertBankTransactionLog(BankTransactionLog log);

    // 查询该账户下未结清借款
    List<BankTransactionLog> selectUnpaidLoansByAccountId(Long accountId);
    /**
     * 更新借贷记录（用于还款时更新本金、利息和状态）
     */
    public int updateBankTransactionLog(BankTransactionLog bankTransactionLog);
    /**
    * 查询该账户下所有欠款本息相加的总额
    * */
    public Double selectTotalDebtByAccountId(Long accountId);
    /**
     * 查询该账户下所有已还清的借款
     * */
    public BankTransactionLog selectBankTransactionLogById(String id);
}
