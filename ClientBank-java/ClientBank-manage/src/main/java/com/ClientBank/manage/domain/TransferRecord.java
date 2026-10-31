package com.ClientBank.manage.domain;

import java.math.BigDecimal;

import lombok.Data;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ClientBank.common.annotation.Excel;
import com.ClientBank.common.core.domain.BaseEntity;

/**
 * 用户转账记录对象 transfer_record
 * 
 * @author WangAiling
 * @date 2026-10-22
 */
@Data
public class TransferRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 转账业务单号 */
    private String transferNo;

    /** 转出账户ID */
    private String fromAccountId;

    /** 转入账户ID */
    private String toAccountId;

    /** 转出用户ID */
    private String fromUserId;

    /** 转入用户ID */
    private String toUserId;

    /** 转账金额 */
    private BigDecimal amount;

    /** 手续费 */
    private BigDecimal fee;

    /** 状态：0待处理 1成功 2失败 3已取消 */
    private Long status;

    /** 失败原因 */
    private String failReason;


    /**  转账备注 **/
    private String remark;


    /** 解冻时间 **/
    private String freeTime;



    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("transferNo", getTransferNo())
            .append("fromAccountId", getFromAccountId())
            .append("toAccountId", getToAccountId())
            .append("fromUserId", getFromUserId())
            .append("toUserId", getToUserId())
            .append("amount", getAmount())
            .append("fee", getFee())
            .append("status", getStatus())
            .append("failReason", getFailReason())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
