package com.ClientBank.manage.domain;

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ClientBank.common.annotation.Excel;
import com.ClientBank.common.core.domain.BaseEntity;

/**
 * 客户信息对象 bank_customer_ext
 * 
 * @author ruoyi
 * @date 2026-10-22
 */
public class BankCustomerExt extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long extId;

    /** 关联sys_user的用户ID（一对一关联，唯一） */
    private Long userId;

    /** 真实姓名（与身份证一致） */
    @Excel(name = "真实姓名", readConverterExp = "与=身份证一致")
    private String realName;

    /** 证件号码（用于实名校验） */
    @Excel(name = "证件号码", readConverterExp = "用=于实名校验")
    private String idCardNumber;

    /** 常用居住地址 */
    @Excel(name = "常用居住地址")
    private String residenceAddress;

    /** 账户状态（0正常，1冻结，2挂失） */
    @Excel(name = "账户状态", readConverterExp = "0=正常，1冻结，2挂失")
    private String accountStatus;
    private int age;
    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }

    /** 银行账户资金信息 */
    private List<BankAccount> bankAccountList;

    public void setExtId(Long extId) 
    {
        this.extId = extId;
    }

    public Long getExtId() 
    {
        return extId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setRealName(String realName) 
    {
        this.realName = realName;
    }

    public String getRealName() 
    {
        return realName;
    }

    public void setIdCardNumber(String idCardNumber) 
    {
        this.idCardNumber = idCardNumber;
    }

    public String getIdCardNumber() 
    {
        return idCardNumber;
    }

    public void setResidenceAddress(String residenceAddress) 
    {
        this.residenceAddress = residenceAddress;
    }

    public String getResidenceAddress() 
    {
        return residenceAddress;
    }

    public void setAccountStatus(String accountStatus) 
    {
        this.accountStatus = accountStatus;
    }

    public String getAccountStatus() 
    {
        return accountStatus;
    }

    public List<BankAccount> getBankAccountList()
    {
        return bankAccountList;
    }

    public void setBankAccountList(List<BankAccount> bankAccountList)
    {
        this.bankAccountList = bankAccountList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("extId", getExtId())
            .append("userId", getUserId())
            .append("realName", getRealName())
            .append("idCardNumber", getIdCardNumber())
            .append("residenceAddress", getResidenceAddress())
            .append("accountStatus", getAccountStatus())
            .append("remark", getRemark())
            .append("bankAccountList", getBankAccountList())
            .toString();
    }
}
