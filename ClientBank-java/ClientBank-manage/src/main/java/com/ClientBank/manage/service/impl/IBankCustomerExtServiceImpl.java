package com.ClientBank.manage.service.impl;

import java.util.List;

import com.ClientBank.manage.domain.vo.BankCustomerExtUserVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.ClientBank.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.ClientBank.manage.domain.BankAccount;
import com.ClientBank.manage.mapper.BankCustomerExtMapper;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.service.IBankCustomerExtService;

/**
 * 客户信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2026-10-22
 */
@Service
public class IBankCustomerExtServiceImpl implements IBankCustomerExtService
{
    @Autowired
    private BankCustomerExtMapper bankCustomerExtMapper;

    /**
     * 查询客户信息
     * 
     * @param extId 客户信息主键
     * @return 客户信息
     */
    @Override
    public BankCustomerExt selectBankCustomerExtByExtId(Long extId)
    {
        return bankCustomerExtMapper.selectBankCustomerExtByExtId(extId);
    }

    /**
     * 查询客户信息列表
     * 
     * @param bankCustomerExt 客户信息
     * @return 客户信息
     */
    @Override
    public List<BankCustomerExt> selectBankCustomerExtList(BankCustomerExt bankCustomerExt)
    {
        return bankCustomerExtMapper.selectBankCustomerExtList(bankCustomerExt);
    }

    /**
     * 新增客户信息
     * 
     * @param bankCustomerExt 客户信息
     * @return 结果
     */
    @Transactional
    @Override
    public int insertBankCustomerExt(BankCustomerExt bankCustomerExt)
    {
        int rows = bankCustomerExtMapper.insertBankCustomerExt(bankCustomerExt);
        insertBankAccount(bankCustomerExt);
        return rows;
    }

    /**
     * 修改客户信息
     * 
     * @param bankCustomerExt 客户信息
     * @return 结果
     */
    @Transactional
    @Override
    public int updateBankCustomerExt(BankCustomerExt bankCustomerExt)
    {
        bankCustomerExtMapper.deleteBankAccountByAccountId(bankCustomerExt.getExtId());
        insertBankAccount(bankCustomerExt);
        return bankCustomerExtMapper.updateBankCustomerExt(bankCustomerExt);
    }

    /**
     * 批量删除客户信息
     * 
     * @param extIds 需要删除的客户信息主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteBankCustomerExtByExtIds(Long[] extIds)
    {
        bankCustomerExtMapper.deleteBankAccountByAccountIds(extIds);
        return bankCustomerExtMapper.deleteBankCustomerExtByExtIds(extIds);
    }

    /**
     * 删除客户信息信息
     * 
     * @param extId 客户信息主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteBankCustomerExtByExtId(Long extId)
    {
        bankCustomerExtMapper.deleteBankAccountByAccountId(extId);
        return bankCustomerExtMapper.deleteBankCustomerExtByExtId(extId);
    }

    @Override
    public BankCustomerExtUserVo selectBankCustomerExtByUserId(Long userId) {
        return bankCustomerExtMapper.selectBankCustomerExtByUserId(userId);
    }

    /**
     * 新增银行账户资金信息
     * 
     * @param bankCustomerExt 客户信息对象
     */
    public void insertBankAccount(BankCustomerExt bankCustomerExt)
    {
        List<BankAccount> bankAccountList = bankCustomerExt.getBankAccountList();
        Long extId = bankCustomerExt.getExtId();
        if (StringUtils.isNotNull(bankAccountList))
        {
            List<BankAccount> list = new ArrayList<BankAccount>();
            for (BankAccount bankAccount : bankAccountList)
            {
                bankAccount.setAccountId(extId);
                list.add(bankAccount);
            }
            if (list.size() > 0)
            {
                bankCustomerExtMapper.batchBankAccount(list);
            }
        }
    }
}
