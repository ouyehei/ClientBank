package com.ClientBank.manage.mapper;

import com.ClientBank.manage.domain.vo.ChartDataDTO;
import com.ClientBank.manage.domain.vo.OverviewCardDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AccountOverviewMapper {
    // 查询环形图数据
    List<ChartDataDTO> getAssetChartData(@Param("userId") Long userId);

    // 查询顶部卡片数据
    OverviewCardDTO getOverviewCards(@Param("userId") Long userId);
    // 获取近7天收支趋势数据
    List<Map<String, Object>> getTrendData(@Param("userId") Long userId);
}
