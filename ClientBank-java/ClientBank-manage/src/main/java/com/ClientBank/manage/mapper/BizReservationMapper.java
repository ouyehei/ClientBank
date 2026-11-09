package com.ClientBank.manage.mapper;

import java.util.List;
import com.ClientBank.manage.domain.BizReservation;
import com.ClientBank.manage.domain.BizReservationLog;

/**
 * 业务预约表Mapper接口
 * 
 * @author WangAiling
 * @date 2026-11-09
 */
public interface BizReservationMapper 
{
    /**
     * 查询业务预约表
     * 
     * @param id 业务预约表主键
     * @return 业务预约表
     */
    public BizReservation selectBizReservationById(Long id);

    /**
     * 查询业务预约表列表
     * 
     * @param bizReservation 业务预约表
     * @return 业务预约表集合
     */
    public List<BizReservation> selectBizReservationList(BizReservation bizReservation);

    /**
     * 新增业务预约表
     * 
     * @param bizReservation 业务预约表
     * @return 结果
     */
    public int insertBizReservation(BizReservation bizReservation);

    /**
     * 修改业务预约表
     * 
     * @param bizReservation 业务预约表
     * @return 结果
     */
    public int updateBizReservation(BizReservation bizReservation);

    /**
     * 删除业务预约表
     * 
     * @param id 业务预约表主键
     * @return 结果
     */
    public int deleteBizReservationById(Long id);

    /**
     * 批量删除业务预约表
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBizReservationByIds(Long[] ids);

    /**
     * 批量删除预约处理流水子
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBizReservationLogByReservationIds(Long[] ids);
    
    /**
     * 批量新增预约处理流水子
     * 
     * @param bizReservationLogList 预约处理流水子列表
     * @return 结果
     */
    public int batchBizReservationLog(List<BizReservationLog> bizReservationLogList);
    

    /**
     * 通过业务预约表主键删除预约处理流水子信息
     * 
     * @param id 业务预约表ID
     * @return 结果
     */
    public int deleteBizReservationLogByReservationId(Long id);
}
