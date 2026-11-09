package com.ClientBank.manage.domain;

import java.util.List;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ClientBank.common.annotation.Excel;
import com.ClientBank.common.core.domain.BaseEntity;

/**
 * 业务预约表对象 biz_reservation
 * 
 * @author WangAiling
 * @date 2026-11-09
 */
public class BizReservation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 预约单号(主键) */
    private Long id;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 服务编码(如:OPEN_I_ACCOUNT) */
    @Excel(name = "服务编码(如:OPEN_I_ACCOUNT)")
    private String serviceCode;

    /** 服务名称(冗余展示) */
    @Excel(name = "服务名称(冗余展示)")
    private String serviceName;

    /** 办理渠道(1自主 2需临柜) */
    @Excel(name = "办理渠道(1自主 2需临柜)")
    private String serviceType;

    /** 预约到店时间(仅临柜需填) */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "预约到店时间(仅临柜需填)", width = 30, dateFormat = "yyyy-MM-dd")
    private Date reserveTime;

    /** 状态(0待处理 1已受理 2已完成 3已取消) */
    @Excel(name = "状态(0待处理 1已受理 2已完成 3已取消)")
    private String status;

    /** 删除标志(0存在 2删除) */
    private String delFlag;

    /** 预约处理流水子信息 */
    private List<BizReservationLog> bizReservationLogList;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setServiceCode(String serviceCode) 
    {
        this.serviceCode = serviceCode;
    }

    public String getServiceCode() 
    {
        return serviceCode;
    }

    public void setServiceName(String serviceName) 
    {
        this.serviceName = serviceName;
    }

    public String getServiceName() 
    {
        return serviceName;
    }

    public void setServiceType(String serviceType) 
    {
        this.serviceType = serviceType;
    }

    public String getServiceType() 
    {
        return serviceType;
    }

    public void setReserveTime(Date reserveTime) 
    {
        this.reserveTime = reserveTime;
    }

    public Date getReserveTime() 
    {
        return reserveTime;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }

    public List<BizReservationLog> getBizReservationLogList()
    {
        return bizReservationLogList;
    }

    public void setBizReservationLogList(List<BizReservationLog> bizReservationLogList)
    {
        this.bizReservationLogList = bizReservationLogList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("userId", getUserId())
            .append("serviceCode", getServiceCode())
            .append("serviceName", getServiceName())
            .append("serviceType", getServiceType())
            .append("reserveTime", getReserveTime())
            .append("status", getStatus())
            .append("remark", getRemark())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("bizReservationLogList", getBizReservationLogList())
            .toString();
    }
}
