package com.ClientBank.manage.service.impl;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.ClientBank.common.exception.ServiceException;
import com.ClientBank.common.utils.DateUtils;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.util.RandomUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ClientBank.manage.mapper.TransferRecordMapper;
import com.ClientBank.manage.domain.TransferRecord;
import com.ClientBank.manage.service.ITransferRecordService;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户转账记录Service业务层处理
 * 
 * @author WangAiling
 * @date 2026-10-22
 */
@Service
public class ITransferRecordServiceImpl implements ITransferRecordService
{
    @Autowired
    private TransferRecordMapper transferRecordMapper;

    /**
     * 查询用户转账记录
     * 
     * @param id 用户转账记录主键
     * @return 用户转账记录
     */
    @Override
    public TransferRecord selectTransferRecordById(Long id)
    {
        return transferRecordMapper.selectTransferRecordById(id);
    }

    /**
     * 查询用户转账记录列表
     * 
     * @param transferRecord 用户转账记录
     * @return 用户转账记录
     */
    @Override
    public List<TransferRecord> selectTransferRecordList(TransferRecord transferRecord)
    {
        return transferRecordMapper.selectTransferRecordList(transferRecord);
    }

    /**
     * 新增用户转账记录
     * 
     * @param transferRecord 用户转账记录
     * @return 结果
     */
    @Override
    public int insertTransferRecord(TransferRecord transferRecord)
    {
        transferRecord.setCreateTime(DateUtils.getNowDate());
        return transferRecordMapper.insertTransferRecord(transferRecord);
    }

    /**
     * 修改用户转账记录
     * 
     * @param transferRecord 用户转账记录
     * @return 结果
     */
    @Override
    public int updateTransferRecord(TransferRecord transferRecord)
    {
        transferRecord.setUpdateTime(DateUtils.getNowDate());
        return transferRecordMapper.updateTransferRecord(transferRecord);
    }

    /**
     * 批量删除用户转账记录
     * 
     * @param ids 需要删除的用户转账记录主键
     * @return 结果
     */
    @Override
    public int deleteTransferRecordByIds(Long[] ids)
    {
        return transferRecordMapper.deleteTransferRecordByIds(ids);
    }

    /**
     * 删除用户转账记录信息
     * 
     * @param id 用户转账记录主键
     * @return 结果
     */
    @Override
    public int deleteTransferRecordById(Long id)
    {
        return transferRecordMapper.deleteTransferRecordById(id);
    }

    @Override
    public List<TransferRecord> selectTransferRecordListByUserId(Long userId) {
        return transferRecordMapper.selectTransferRecordListByUserId(userId);
    }

    @Override
    public BankCustomerExt selectRealNameByCardNumber(String cardNumber) {
        BankCustomerExt bankCustomerExt = transferRecordMapper.selectRealNameByCardNumber(cardNumber);
        if (bankCustomerExt == null) {
            return null;
        }
        return bankCustomerExt;
    }

    @Override
    public BigDecimal selectBalanceByCardNumber(String cardNumber) {
        return transferRecordMapper.selectBalanceByCardNumber(cardNumber);
    }

    @Override
    public String selectCardTypeByCardNumber(String cardNumber) {
        return transferRecordMapper.selectCardTypeByCardNumber(cardNumber);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean doTransfer(TransferRecord transferRecord) {

        // ToDo: 1.基础校验
        if (transferRecord.getFromAccountId() == null || transferRecord.getToAccountId() == null) {
            throw new ServiceException("转出账户和转入账户不能为空");
        }
        if (transferRecord.getAmount() == null || transferRecord.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new ServiceException("转账金额必须大于0");
        }
        if (transferRecord.getFromAccountId().equals(transferRecord.getToAccountId())) {
            throw new ServiceException("不能转账给自己");
        }
        //ToDo:2.信息记录 (在这里先计算出手续费)
        BigDecimal transferAmount = transferRecord.getAmount();
        BigDecimal fee = transferAmount.multiply(new BigDecimal("0.001"));
        BigDecimal totalDeduct = transferAmount.add(fee);
        //Todo:3-风控：根据卡类型判断是否冻结
        //       对卡号类型进行判断，如果是一类卡，超过一万元，冻结24小时
        //                     如果是二类卡，超过五千元，冻结24小时
        //   1.使用卡号查询类型(11-一类卡，12-二类卡；2-借记卡)
        String cardType = this.selectCardTypeByCardNumber(transferRecord.getFromAccountId());
        boolean needFreeze = false;
        if (cardType != null) {
            if ("11".equals(cardType) && transferAmount.compareTo(new BigDecimal("10000")) > 0) {
                needFreeze = true;
            } else if ("12".equals(cardType) && transferAmount.compareTo(new BigDecimal("5000")) > 0) {
                needFreeze = true;
            }
        }
        // ToDo:4. 根据风控结果执行资金操作 (这里替代了你原来的直接扣款)
        if (needFreeze) {
            // 【触发风控】资金进入冻结余额 (balance = available_balance + frozen_balance)
            int freezeResult = transferRecordMapper.freezeTransferFunds(
                    transferRecord.getFromAccountId(),
                    transferRecord.getToAccountId(),
                    transferAmount,
                    fee
            );
            if (freezeResult <= 0) {
                throw new ServiceException("余额不足或账户异常，无法完成转账");
            }
            long freezeTime = System.currentTimeMillis() + 24L * 60 * 60 * 1000;
            transferRecord.setFreeTime(DateUtils.parseDateToStr("yyyy-MM-dd HH:mm:ss", new Date(freezeTime)));
            transferRecord.setStatus(0L); // 0=冻结中
        } else {
            // 【未触发风控】直接扣款入账 (动 available_balance)
            int deduct = transferRecordMapper.deductBalance(
                    Long.valueOf(transferRecord.getFromAccountId()), totalDeduct);
            if (deduct <= 0) {
                throw new ServiceException("余额不足，无法完成转账");
            }

            int add = transferRecordMapper.addBalance(
                    Long.valueOf(transferRecord.getToAccountId()), transferAmount);
            if (add <= 0) {
                throw new ServiceException("转入账户入账失败");
            }

            transferRecord.setStatus(1L); // 1=已完成
        }

        //ToDo:5. 补充转账记录信息并入库
        transferRecord.setTransferNo("TR" + RandomUtil.next10());
        transferRecord.setFee(fee);
        transferRecord.setCreateTime(DateUtils.getNowDate());
        transferRecord.setUpdateTime(DateUtils.getNowDate());

        // 6. 插入转账记录（复用现有的 insert 方法）
        this.insertTransferRecord(transferRecord);

        return true;
    }
}
