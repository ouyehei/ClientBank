package com.ClientBank.manage.controller;

import java.util.List;
import java.util.stream.Collectors;

import com.ClientBank.manage.domain.BankAccount;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ClientBank.common.annotation.Log;
import com.ClientBank.common.core.controller.BaseController;
import com.ClientBank.common.core.domain.AjaxResult;
import com.ClientBank.common.enums.BusinessType;
import com.ClientBank.manage.domain.BankCustomerExt;
import com.ClientBank.manage.service.IBankCustomerExtService;
import com.ClientBank.common.utils.poi.ExcelUtil;
import com.ClientBank.common.core.page.TableDataInfo;

/**
 * 客户信息Controller
 * 
 * @author ruoyi
 * @date 2026-10-22
 */
@RestController
@RequestMapping("/manage/customerExt")
public class BankCustomerExtController extends BaseController
{
    @Autowired
    private IBankCustomerExtService bankCustomerExtService;

    /**
     * 查询客户信息列表
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:list')")
    @GetMapping("/list")
    public TableDataInfo list(BankCustomerExt bankCustomerExt)
    {
        startPage();
        List<BankCustomerExt> list = bankCustomerExtService.selectBankCustomerExtList(bankCustomerExt);
        return getDataTable(list);
    }

    /**
     * 导出客户信息列表
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:export')")
    @Log(title = "客户信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, BankCustomerExt bankCustomerExt)
    {
        List<BankCustomerExt> list = bankCustomerExtService.selectBankCustomerExtList(bankCustomerExt);
        ExcelUtil<BankCustomerExt> util = new ExcelUtil<BankCustomerExt>(BankCustomerExt.class);
        util.exportExcel(response, list, "客户信息数据");
    }

    /**
     * 获取客户信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:query')")
    @GetMapping(value = "/{extId}")
    public AjaxResult getInfo(@PathVariable("extId") Long extId)
    {
        return success(bankCustomerExtService.selectBankCustomerExtByExtId(extId));
    }

    /**
     * 新增客户信息
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:add')")
    @Log(title = "客户信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody BankCustomerExt bankCustomerExt)
    {
        return toAjax(bankCustomerExtService.insertBankCustomerExt(bankCustomerExt));
    }

    /**
     * 修改客户信息
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:edit')")
    @Log(title = "客户信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody BankCustomerExt bankCustomerExt)
    {
        return toAjax(bankCustomerExtService.updateBankCustomerExt(bankCustomerExt));
    }

    /**
     * 删除客户信息
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:remove')")
    @Log(title = "客户信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{extIds}")
    public AjaxResult remove(@PathVariable Long[] extIds)
    {
        return toAjax(bankCustomerExtService.deleteBankCustomerExtByExtIds(extIds));
    }

    /**
     * 根据userId查询客户信息及关联用户信息
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:query')")
    @GetMapping("/list/{userId}")
    public AjaxResult getByUserId(@PathVariable("userId") Long userId)
    {
        return success(bankCustomerExtService.selectBankCustomerExtByUserId(userId));
    }
    /**
     * @param userId 用户id
     * @return 名下全部银行卡号信息
     * @deprecated 根据userId查询客户所有银行卡号
     */
    @PreAuthorize("@ss.hasPermi('manage:customerExt:query')")
    @GetMapping("/bankNum/{userId}")
    public AjaxResult getBankCardList(@PathVariable("userId") Long userId)
    {
        List<BankAccount> originalList  = bankCustomerExtService.selectBankCustomerExtByUserId(userId).getBankAccountList();
        List<String> cardNumbers = originalList.stream()
                .map(BankAccount::getCardNumber)
                .collect(Collectors.toList());
        return success().put("from_account_ids",cardNumbers);
    }
}
