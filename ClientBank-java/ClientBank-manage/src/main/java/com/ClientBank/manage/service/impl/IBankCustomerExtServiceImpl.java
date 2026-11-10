package com.ClientBank.manage.service.impl;

import java.util.List;

import com.ClientBank.common.core.domain.entity.SysUser;
import com.ClientBank.common.utils.SecurityUtils;
import com.ClientBank.manage.domain.vo.BankCustomerExtUserVo;
import com.ClientBank.manage.domain.vo.SysUserUpdateVo;
import com.ClientBank.system.service.ISysUserService;
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
    @Autowired
    private ISysUserService userService; // 注入若依自带的用户Service

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

    @Override
    public List<Long> selectOverdueUserIds() {
        return bankCustomerExtMapper.selectOverdueUserIds();
    }

    @Override
    public int updateCustomerStatusToExceptionByUserIds(List<Long> userIds) {
        return bankCustomerExtMapper.updateCustomerStatusToExceptionByUserIds(userIds);
    }

    @Transactional
    @Override
    public int updateProfile(SysUserUpdateVo updateVo) {
        Long userId = SecurityUtils.getUserId();
        // 1. 更新扩展表 (bank_customer_ext)
        BankCustomerExt ext = new BankCustomerExt();
        ext.setUserId(userId);
        ext.setRealName(updateVo.getRealName());
        ext.setIdCardNumber(updateVo.getIdCardNumber());
        ext.setResidenceAddress(updateVo.getResidenceAddress());
        ext.setAge(updateVo.getAge());
        bankCustomerExtMapper.updateBankCustomerExtByUserId(ext);
        // 2. 更新系统用户表 (sys_user) - 复用若依自带校验
        SysUser sysUser = new SysUser();
        sysUser.setUserId(userId);
        sysUser.setNickName(updateVo.getNickName());
        sysUser.setEmail(updateVo.getEmail());
        sysUser.setPhonenumber(updateVo.getPhonenumber());
        sysUser.setAvatar(updateVo.getAvatar());
        sysUser.setDeptId(null);
        userService.updateUserProfile(sysUser);
        return 1;
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
