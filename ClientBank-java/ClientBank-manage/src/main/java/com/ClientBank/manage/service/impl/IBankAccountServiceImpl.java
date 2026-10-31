package com.ClientBank.manage.service.impl;

import com.ClientBank.manage.domain.BankAccount;
import com.ClientBank.manage.mapper.BankAccountMapper;
import com.ClientBank.manage.service.IBankAccountService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class IBankAccountServiceImpl implements IBankAccountService {
    @Autowired
    private BankAccountMapper bankAccountMapper;



    @Override
    public BankAccount selectBankAccountById(String card_number) {
        return bankAccountMapper.selectBankAccountByCardNumber(card_number);
    }

    /**
     * 更新信用额度
     * @param cardNumber 账户卡号
     * @param amount 变动金额（正数代表释放/还款，负数代表扣减/借款）
     * @return 影响行数
     */
    @Override
    public int updateCreditLimit(@Param("cardNumber") String cardNumber, @Param("amount") BigDecimal amount) {
        return bankAccountMapper.updateCreditLimit(cardNumber, amount);
    }

    /**
     * 根据卡号更新余额
     */
    @Override
    public int updateBalance(@Param("cardNumber") String cardNumber, @Param("amount") BigDecimal amount) {
        return bankAccountMapper.updateBalance(cardNumber, amount);
    }
}
