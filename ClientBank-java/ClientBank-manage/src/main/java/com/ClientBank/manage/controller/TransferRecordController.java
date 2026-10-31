package com.ClientBank.manage.controller;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.ClientBank.common.exception.ServiceException;
import com.ClientBank.common.utils.StringUtils;
import com.ClientBank.common.utils.spring.SpringUtils;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.util.DateUtil;
import com.ClientBank.manage.util.RandomUtil;
import com.ClientBank.system.service.ISysConfigService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ClientBank.common.annotation.Log;
import com.ClientBank.common.core.controller.BaseController;
import com.ClientBank.common.core.domain.AjaxResult;
import com.ClientBank.common.enums.BusinessType;
import com.ClientBank.manage.domain.TransferRecord;
import com.ClientBank.manage.service.ITransferRecordService;
import com.ClientBank.common.utils.poi.ExcelUtil;
import com.ClientBank.common.core.page.TableDataInfo;

/**
 * 用户转账记录Controller
 * 
 * @author WangAiling
 * @date 2026-10-22
 */
@RestController
@RequestMapping("/manage/TransferRecord")
public class TransferRecordController extends BaseController
{
    @Autowired
    private ITransferRecordService transferRecordService;
    /**
     * 兜底校验并批量解冻列表中的记录
     */
    private void unfreezeExpiredList(List<TransferRecord> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        // 获取参数配置，如果没配默认按24小时算
        ISysConfigService configService = SpringUtils.getBean(ISysConfigService.class);
        String hoursStr = configService.selectConfigByKey("transfer.freeze.hours");
        long hours = 24;
        try {
            hours = Long.parseLong(hoursStr);
        } catch (Exception e) {
            // 解析失败，默认24小时
        }

        long currentTime = System.currentTimeMillis();

        for (TransferRecord record : list) {
            // 只有状态是冻结(0L) 且 冻结时间不为空时才进行校验
            if (record.getStatus() != 0L || record.getFreeTime() == null || record.getFreeTime().isEmpty()) {
                continue;
            }

            String freeTimeStr = record.getFreeTime();
            // 计算过期时间字符串（yyyy-MM-dd HH:mm:ss 格式）
            String expireTimeStr = DateUtil.format(currentTime + hours * 60 * 60 * 1000);

            // 比较当前时间（作为过期时间）是否已经大于等于存入时的冻结时间
            if (expireTimeStr.compareTo(freeTimeStr) >= 0) {
                // 自动更新状态为正常（1L），并清空冻结时间
                record.setStatus(1L);
                record.setFreeTime(null);
                transferRecordService.updateTransferRecord(record);
            }
        }
    }

    /**
     * 查询用户转账记录列表
     */
    @PreAuthorize("@ss.hasPermi('manage:TransferRecord:list')")
    @GetMapping("/list")
    public TableDataInfo list(TransferRecord transferRecord)
    {
        startPage();
        List<TransferRecord> list = transferRecordService.selectTransferRecordList(transferRecord);
        return getDataTable(list);
    }
    /**
     * 根据用户ID查询转账记录列表
     */
    @GetMapping("/list/{userId}")
    public AjaxResult list(@PathVariable("userId") Long userId) {
        List<TransferRecord> list = transferRecordService.selectTransferRecordListByUserId(userId);
        unfreezeExpiredList(list);
        //        System.out.println("用户id"+list.toString());
        return AjaxResult.success(list);
    }
    /**
     * 导出用户转账记录列表
     */
    @PreAuthorize("@ss.hasPermi('manage:TransferRecord:export')")
    @Log(title = "用户转账记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TransferRecord transferRecord)
    {
        List<TransferRecord> list = transferRecordService.selectTransferRecordList(transferRecord);
        ExcelUtil<TransferRecord> util = new ExcelUtil<TransferRecord>(TransferRecord.class);
        util.exportExcel(response, list, "用户转账记录数据");
    }

    /**
     * 获取用户转账记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('manage:TransferRecord:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {

        return success(transferRecordService.selectTransferRecordById(id));
    }

    /**
     * 用户转账功能
     */
    @PreAuthorize("@ss.hasPermi('manage:TransferRecord:add')")
    @Log(title = "用户转账记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TransferRecord transferRecord)
    {
        try {
            transferRecordService.doTransfer(transferRecord);
            return AjaxResult.success("转账成功");
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 修改用户转账记录
     * 接口封存
     */
//    @PreAuthorize("@ss.hasPermi('manage:TransferRecord:edit')")
//    @Log(title = "用户转账记录", businessType = BusinessType.UPDATE)
//    @PutMapping
//    public AjaxResult edit(@RequestBody TransferRecord transferRecord)
//    {
//        return toAjax(transferRecordService.updateTransferRecord(transferRecord));
//    }

    /**
     * 删除用户转账记录
     */
    @PreAuthorize("@ss.hasPermi('manage:TransferRecord:remove')")
    @Log(title = "用户转账记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(transferRecordService.deleteTransferRecordByIds(ids));
    }
    @PreAuthorize("@ss.hasAnyPermi('manage:TransferRecord:query')")
    //@Log(title = "用户转账", businessType = BusinessType.OTHER)；不需要日志，该接口只是个小功能点
    @GetMapping("/getRealName")
    public AjaxResult getRealName(@RequestParam String cardNum) {
        if (StringUtils.isEmpty(cardNum)) {
            return AjaxResult.error("请输入银行卡号");
        }
        BankCustomerExt customer = transferRecordService.selectRealNameByCardNumber(cardNum);
        if (customer==null){
            return AjaxResult.error("未找到该账户对应的用户信息");
        }
        String realName = transferRecordService.selectRealNameByCardNumber(cardNum).getRealName();
        String userId = String.valueOf(transferRecordService.selectRealNameByCardNumber(cardNum).getUserId());
        return AjaxResult.success().put("realName", realName).put("userId", userId);

    }
}
