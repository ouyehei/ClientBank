package com.ClientBank.manage.domain.vo;


import lombok.Data;

@Data
public class SysUserUpdateVo {
    private String nickName;
    private String email;
    private String phonenumber;
    private String avatar; // 头像URL
    private String realName;
    private String idCardNumber;
    private String residenceAddress;
    private Integer age;
}
