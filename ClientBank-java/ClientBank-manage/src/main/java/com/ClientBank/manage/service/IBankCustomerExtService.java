package com.ClientBank.manage.service;

import java.util.List;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.domain.vo.BankCustomerExtUserVo;

/**
 * 客户信息Service接口
 * 
 * @author ruoyi
 * @date 2026-10-22
 */
public interface IBankCustomerExtService 
{
    /**
     * 查询客户信息
     * 
     * @param extId 客户信息主键
     * @return 客户信息
     */
    public BankCustomerExt selectBankCustomerExtByExtId(Long extId);

    /**
     * 查询客户信息列表
     * 
     * @param bankCustomerExt 客户信息
     * @return 客户信息集合
     */
    public List<BankCustomerExt> selectBankCustomerExtList(BankCustomerExt bankCustomerExt);

    /**
     * 新增客户信息
     * 
     * @param bankCustomerExt 客户信息
     * @return 结果
     */
    public int insertBankCustomerExt(BankCustomerExt bankCustomerExt);

    /**
     * 修改客户信息
     * 
     * @param bankCustomerExt 客户信息
     * @return 结果
     */
    public int updateBankCustomerExt(BankCustomerExt bankCustomerExt);

    /**
     * 批量删除客户信息
     * 
     * @param extIds 需要删除的客户信息主键集合
     * @return 结果
     */
    public int deleteBankCustomerExtByExtIds(Long[] extIds);

    /**
     * 删除客户信息信息
     * 
     * @param extId 客户信息主键
     * @return 结果
     */
    public int deleteBankCustomerExtByExtId(Long extId);
    /**
     * 根据userId查询客户信息及关联用户信息
     */
    public BankCustomerExtUserVo selectBankCustomerExtByUserId(Long userId);
}
