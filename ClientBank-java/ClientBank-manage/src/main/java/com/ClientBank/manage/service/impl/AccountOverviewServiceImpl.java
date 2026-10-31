package com.ClientBank.manage.service.impl;

import com.ClientBank.manage.domain.vo.ChartDataDTO;
import com.ClientBank.manage.domain.vo.OverviewCardDTO;
import com.ClientBank.manage.mapper.AccountOverviewMapper;
import com.ClientBank.manage.service.AccountOverviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AccountOverviewServiceImpl implements AccountOverviewService {
    @Autowired
    private AccountOverviewMapper overviewMapper;
    @Override
    public Map<String, Object> getDashboardData(Long userId) {
        // 1. 拿图表数据
        List<ChartDataDTO> chartData = overviewMapper.getAssetChartData(userId);
        // 2. 拿卡片数据
        OverviewCardDTO cardData = overviewMapper.getOverviewCards(userId);
        // 3. 组装成一个 Map 返回给前端（前端一次请求拿完所有数据，减少网络开销）
        Map<String, Object> result = new HashMap<>();
        result.put("chartData", chartData); // ECharts 用的数组
        result.put("cardData", cardData);   // 数字卡片用的对象
        List<Map<String, Object>> trendData = overviewMapper.getTrendData(userId);
        result.put("trendData", trendData);
        return result;
    }
}
