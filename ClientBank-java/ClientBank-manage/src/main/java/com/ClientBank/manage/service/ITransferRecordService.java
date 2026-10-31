package com.ClientBank.manage.service;

import java.math.BigDecimal;
import java.util.List;

import com.ClientBank.manage.domain.BankAccount;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.domain.TransferRecord;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 用户转账记录Service接口
 * 
 * @author WangAiling
 * @date 2026-10-22
 */
public interface ITransferRecordService 
{
    /**
     * 查询用户转账记录
     * 
     * @param id 用户转账记录主键
     * @return 用户转账记录
     */
    public TransferRecord selectTransferRecordById(Long id);

    /**
     * 查询用户转账记录列表
     * 
     * @param transferRecord 用户转账记录
     * @return 用户转账记录集合
     */
    public List<TransferRecord> selectTransferRecordList(TransferRecord transferRecord);

    /**
     * 新增用户转账记录
     * 
     * @param transferRecord 用户转账记录
     * @return 结果
     */
    public int insertTransferRecord(TransferRecord transferRecord);

    /**
     * 修改用户转账记录
     * 
     * @param transferRecord 用户转账记录
     * @return 结果
     */
    public int updateTransferRecord(TransferRecord transferRecord);

    /**
     * 批量删除用户转账记录
     * 
     * @param ids 需要删除的用户转账记录主键集合
     * @return 结果
     */
    public int deleteTransferRecordByIds(Long[] ids);

    /**
     * 删除用户转账记录信息
     * 
     * @param id 用户转账记录主键
     * @return 结果
     */
    public int deleteTransferRecordById(Long id);

    /**
     * 根据用户ID查询转账记录列表
     */
    List<TransferRecord> selectTransferRecordListByUserId(Long userId);

    BankCustomerExt selectRealNameByCardNumber(@Param("cardNumber") String cardNumber);

    /**
     * 根据卡号查询余额
     */
    BigDecimal selectBalanceByCardNumber(@Param("cardNumber") String cardNumber);
    /**
     * 根据卡号查询银行卡类型
     */
    String selectCardTypeByCardNumber(@Param("cardNumber") String cardNumber);
    /**
     * 用户转账
     *
     */
    public boolean doTransfer(TransferRecord transferRecord);
}
