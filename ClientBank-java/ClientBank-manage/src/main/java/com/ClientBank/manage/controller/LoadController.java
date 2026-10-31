package com.ClientBank.manage.controller;

import com.ClientBank.common.core.controller.BaseController;
import com.ClientBank.common.core.domain.AjaxResult;
import com.ClientBank.manage.domain.BankTransactionLog;
import com.ClientBank.manage.service.IBankTransactionLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Map;

@RestController
@RequestMapping("/manage/loan")
public class LoadController extends BaseController {
    @Autowired
    private IBankTransactionLogService bankTransactionLogService;
    /**
     * 借钱/还款
     */
    @PreAuthorize("@ss.hasPermi('manage:loan:add')") // 权限控制
    @PostMapping("/credit") // 专门的信贷接口路径
    public AjaxResult addCredit(@RequestBody BankTransactionLog bankTransactionLog) {
//        System.out.println("还钱");
        try {
            int rows = bankTransactionLogService.insertBankTransactionLog(bankTransactionLog);
            if (rows > 0) {
                String msg = bankTransactionLog.getTransactionType() == 1 ? "借款成功" : "还款成功";
                return AjaxResult.success(msg);
            }
            return AjaxResult.error("操作失败");
        } catch (RuntimeException e) {
            // 捕获业务异常（如“没有未还清借款”），返回友好提示
            return AjaxResult.error(e.getMessage());
        }
    }
    @PreAuthorize("@ss.hasPermi('manage:loan:update')")
    @PostMapping("/repay")
    public AjaxResult repay(@RequestBody Map<String, Object> params) {
        String loanId = (String) params.get("loanId");
        BigDecimal repayAmount = new BigDecimal(params.get("repayAmount").toString());
        int rows = bankTransactionLogService.repayLoan(loanId, repayAmount);
        return toAjax(rows);
    }
    @PreAuthorize("@ss.hasPermi('manage:loan:query')")
    @GetMapping("/unpaid/{accountId}")
    public AjaxResult unpaid(@PathVariable("accountId") String accountId) {
        return AjaxResult.success(bankTransactionLogService.selectUnpaidLoansByAccountId(Long.valueOf(accountId)));
    }

    @PreAuthorize("@ss.hasPermi('manage:loan:query')")
    @GetMapping("/debtSummary/{accountId}")
    public AjaxResult debtSummary(@PathVariable("accountId") String accountId) {
        return AjaxResult.success(bankTransactionLogService.selectTotalDebtByAccountId(Long.valueOf(accountId)));
    }
}
