package com.ClientBank.manage.mapper;

import java.math.BigDecimal;
import java.util.List;

import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.domain.TransferRecord;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 用户转账记录Mapper接口
 * 
 * @author WangAiling
 * @date 2026-10-22
 */
public interface TransferRecordMapper 
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
     * 删除用户转账记录
     * 
     * @param id 用户转账记录主键
     * @return 结果
     */
    public int deleteTransferRecordById(Long id);

    /**
     * 批量删除用户转账记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTransferRecordByIds(Long[] ids);

    /**
     * 根据用户ID查询转账记录列表
     */
    List<TransferRecord> selectTransferRecordListByUserId(Long userId);

    @Select("SELECT bce.real_name as realName,bce.user_id as userId FROM bank_account ba " +
            "LEFT JOIN bank_customer_ext bce ON ba.user_id = bce.user_id " +
            "WHERE ba.card_number = #{cardNumber}")
    BankCustomerExt selectRealNameByCardNumber(@Param("cardNumber") String cardNumber);

    /**
     * 根据卡号查询余额
     */
    @Select("SELECT balance FROM bank_account WHERE card_number = #{cardNumber}")
    BigDecimal selectBalanceByCardNumber(@Param("cardNumber") String cardNumber);

    /**
     * 根据卡号查询银行卡类型
     */
    @Select("SELECT account_type FROM bank_account WHERE card_number = #{cardNumber}")
    String selectCardTypeByCardNumber(@Param("cardNumber") String cardNumber);
    @Select("SELECT * FROM transfer_record WHERE status = 0 AND freeze_time IS NOT NULL AND freeze_time <= FROM_UNIXTIME(#{expireTime} / 1000)")
    List<TransferRecord> selectExpiredFreezeRecords(@Param("expireTime") long expireTime);

    /**
     * 原子扣减账户余额
     *
     * @param accountId 账户ID
     * @param amount 扣减金额
     * @return 影响行数（如果余额不足或账户不存在，返回0）
     */
    public int deductBalance(@Param("accountId") Long accountId, @Param("amount") BigDecimal amount);

    /**
     * 原子增加账户余额
     *
     * @param accountId 账户ID
     * @param amount 增加金额
     * @return 影响行数
     */
    public int addBalance(@Param("accountId") Long accountId, @Param("amount") BigDecimal amount);

    List<TransferRecord> queryExpiredFreezeRecords();

    int unfreezeRecord(TransferRecord record);
    /**
     * 转账冻结资金：减少出账方可用余额，增加入账方冻结余额
     */
    int freezeTransferFunds(@Param("fromAccountId") String fromAccountId,
                            @Param("toAccountId") String toAccountId,
                            @Param("amount") BigDecimal amount,
                            @Param("fee") BigDecimal fee);

    /**
     * 更新转账记录状态为已完成
     */
    int updateTransferStatus();
}
