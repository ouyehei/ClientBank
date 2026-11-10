package com.ClientBank.manage.mapper;

import java.util.List;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.domain.BankAccount;
import com.ClientBank.manage.domain.vo.BankCustomerExtUserVo;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

/**
 * 客户信息Mapper接口
 * 
 * @author ruoyi
 * @date 2026-10-22
 */
public interface BankCustomerExtMapper 
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
     * 删除客户信息
     * 
     * @param extId 客户信息主键
     * @return 结果
     */
    public int deleteBankCustomerExtByExtId(Long extId);

    /**
     * 批量删除客户信息
     * 
     * @param extIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankCustomerExtByExtIds(Long[] extIds);

    /**
     * 批量删除银行账户资金
     * 
     * @param extIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankAccountByAccountIds(Long[] extIds);
    
    /**
     * 批量新增银行账户资金
     * 
     * @param bankAccountList 银行账户资金列表
     * @return 结果
     */
    public int batchBankAccount(List<BankAccount> bankAccountList);
    

    /**
     * 通过客户信息主键删除银行账户资金信息
     * 
     * @param extId 客户信息ID
     * @return 结果
     */
    public int deleteBankAccountByAccountId(Long extId);

    public BankCustomerExtUserVo selectBankCustomerExtByUserId(@Param("userId") Long userId);

    // 查出逾期且未结清的账户对应的用户ID列表
    List<Long> selectOverdueUserIds();

    // 根据用户ID列表，批量更新客户账户状态为异常
    int updateCustomerStatusToExceptionByUserIds(@Param("list") List<Long> userIds);

    /**
     * 根据用户ID修改扩展信息
     */
    public int updateBankCustomerExtByUserId(BankCustomerExt bankCustomerExt);
}
