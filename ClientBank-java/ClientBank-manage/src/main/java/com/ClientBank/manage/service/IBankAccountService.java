package com.ClientBank.manage.service;

import com.ClientBank.manage.domain.BankAccount;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;

public interface IBankAccountService {
    /** 根据ID查询账户信息 */
    BankAccount selectBankAccountById(String accountId);

    /**
     * 更新信用额度
     * @param cardNumber 账户卡号
     * @param amount 变动金额（正数代表释放/还款，负数代表扣减/借款）
     * @return 影响行数
     */
    int updateCreditLimit(@Param("cardNumber") String cardNumber, @Param("amount") BigDecimal amount);

    /**
     * 根据卡号更新余额
     */
    int updateBalance(@Param("cardNumber") String cardNumber, @Param("amount") BigDecimal amount);
}
