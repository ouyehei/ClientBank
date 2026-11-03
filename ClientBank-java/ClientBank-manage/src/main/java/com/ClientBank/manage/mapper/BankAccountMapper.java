package com.ClientBank.manage.mapper;

import com.ClientBank.manage.domain.BankAccount;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

public interface BankAccountMapper {
    /**
     * 根据银行卡号查询账户信息
     * 注意：这里参数名用 cardNumber，类型用 String
     */
    BankAccount selectBankAccountByCardNumber(@Param("cardNumber") String cardNumber);
    /**
     * 更新信用额度
     * @param cardNumber 账户ID
     * @param amount 变动金额（正数代表释放/还款，负数代表扣减/借款）
     * @return 影响行数
     */
    int updateCreditLimit(@Param("cardNumber") String cardNumber, @Param("amount") BigDecimal amount);

    /**
     * 更新账户余额
     * @param cardNumber 账户ID
     * @param amount 变动金额（正数代表增加，负数代表减少）
     * @return 影响行数
     */
    int updateBalance(@Param("cardNumber") String cardNumber, @Param("amount") BigDecimal amount);
}
