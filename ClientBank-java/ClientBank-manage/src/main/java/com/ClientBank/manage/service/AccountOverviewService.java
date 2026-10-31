package com.ClientBank.manage.service;

import java.util.Map;

public interface AccountOverviewService {
    // 一次性返回首页所需的全部数据，方便前端调用
    Map<String, Object> getDashboardData(Long userId);
}
