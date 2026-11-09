package com.ClientBank.manage.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ClientBank.common.annotation.Excel;
import com.ClientBank.common.core.domain.BaseEntity;

/**
 * 预约处理流水子对象 biz_reservation_log
 * 
 * @author WangAiling
 * @date 2026-11-09
 */
public class BizReservationLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 流水主键 */
    private Long id;

    /** 预约单号(关联主表id) */
    @Excel(name = "预约单号(关联主表id)")
    private Long reservationId;

    /** 处理柜员ID */
    @Excel(name = "处理柜员ID")
    private Long handlerId;

    /** 处理柜员姓名 */
    @Excel(name = "处理柜员姓名")
    private String handlerName;

    /** 处理动作(受理/退回/完成) */
    @Excel(name = "处理动作(受理/退回/完成)")
    private String action;

    /** 柜员处理意见(原主表审核字段) */
    @Excel(name = "柜员处理意见(原主表审核字段)")
    private String handleRemark;

    /** 处理时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "处理时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date handleTime;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setReservationId(Long reservationId) 
    {
        this.reservationId = reservationId;
    }

    public Long getReservationId() 
    {
        return reservationId;
    }
    public void setHandlerId(Long handlerId) 
    {
        this.handlerId = handlerId;
    }

    public Long getHandlerId() 
    {
        return handlerId;
    }
    public void setHandlerName(String handlerName) 
    {
        this.handlerName = handlerName;
    }

    public String getHandlerName() 
    {
        return handlerName;
    }
    public void setAction(String action) 
    {
        this.action = action;
    }

    public String getAction() 
    {
        return action;
    }
    public void setHandleRemark(String handleRemark) 
    {
        this.handleRemark = handleRemark;
    }

    public String getHandleRemark() 
    {
        return handleRemark;
    }
    public void setHandleTime(Date handleTime) 
    {
        this.handleTime = handleTime;
    }

    public Date getHandleTime() 
    {
        return handleTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("reservationId", getReservationId())
            .append("handlerId", getHandlerId())
            .append("handlerName", getHandlerName())
            .append("action", getAction())
            .append("handleRemark", getHandleRemark())
            .append("handleTime", getHandleTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .toString();
    }
}
