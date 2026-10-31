package com.ClientBank.manage.domain;

import java.math.BigDecimal;

import lombok.Data;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ClientBank.common.annotation.Excel;
import com.ClientBank.common.core.domain.BaseEntity;

/**
 * 银行账户资金对象 bank_account
 * 
 * @author ruoyi
 * @date 2026-10-22
 */
@Data
public class BankAccount extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 账户ID */
    private Long accountId;

    /** 关联sys_user的用户ID */
    private Long userId;

    /** 银行卡号 */
    @Excel(name = "银行卡号")
    private String cardNumber;

    /** 账户类型（1-储蓄卡，2-信用卡） */
    @Excel(name = "账户类型", readConverterExp = "1=-储蓄卡，2-信用卡")
    private String accountType;

    /** 当前账户余额（保留两位小数） */
    @Excel(name = "当前账户余额", readConverterExp = "保=留两位小数")
    private BigDecimal balance;

    /** 贷款/信用额度 */
    @Excel(name = "贷款/信用额度")
    private BigDecimal creditLimit;

    /** 货币类型 */
    @Excel(name = "货币类型")
    private String currency;

    /** 可用金额 **/
    private BigDecimal availableBalance;
    /** 冻结金额 **/
    private BigDecimal frozenBalance;



    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("accountId", getAccountId())
            .append("userId", getUserId())
            .append("cardNumber", getCardNumber())
            .append("accountType", getAccountType())
            .append("balance", getBalance())
            .append("creditLimit", getCreditLimit())
            .append("currency", getCurrency())
            .append("createTime", getCreateTime())
            .toString();
    }
}
