package com.ClientBank.manage.controller;

import com.ClientBank.common.core.domain.AjaxResult;
import com.ClientBank.manage.service.AccountOverviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/manage/account")
public class AccountOverviewController {
    @Autowired
    private AccountOverviewService overviewService;
    /**
     * 获取资产总览数据
     * @param userId 前端传来的用户ID
     * @return 包含图表和卡片数据的 Map
     */
    @PreAuthorize("@ss.hasPermi('manage:account:dashboard')")
    @GetMapping("/dashboard")
    public AjaxResult getDashboardData(@RequestParam(value = "userId", required = true) Long userId) {

        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return AjaxResult.success(overviewService.getDashboardData(userId));
    }
}
