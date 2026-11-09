package com.ClientBank.manage.domain.vo;

import com.ClientBank.manage.domain.BankAccount;
import lombok.Data;
import java.util.List;

@Data
public class BankCustomerExtUserVo {
    private static final long serialVersionUID = 1L;

    /** 扩展ID (必须加，否则主键映射不上) */
    private Long extId;

    /** 用户ID (必须加，用于关联查询和前端展示) */
    private Long userId;

    /** 真实姓名 */
    private String realName;

    /** 身份证号 */
    private String idCardNumber;

    /** 居住地址 */
    private String residenceAddress;

    /** 账户状态 */
    private String accountStatus;

    /** 备注 */
    private String remark;
    /** 年龄 **/
    private int age;

    // ================= 以下是来自 sys_user 表的字段 =================
    /** 用户账号 */
    private String userName;

    /** 用户昵称 */
    private String nickName;

    /** 用户邮箱 */
    private String email;

    /** 手机号码 */
    private String phonenumber;

    // ================= 关键：必须加上银行卡列表 =================
    /** 关联的银行卡列表 (由MyBatis的collection标签自动映射) */
    private List<BankAccount> bankAccountList;
}