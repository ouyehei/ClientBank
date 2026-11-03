package com.ClientBank.quartz.task;
import com.ClientBank.manage.mapper.BankAccountMapper;
import com.ClientBank.manage.mapper.BankCustomerExtMapper;
import com.ClientBank.manage.mapper.BankTransactionLogMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import java.util.List;

@Component("loanOverdueTask")
public class BankOverdueTask {
    private static final Logger log = LoggerFactory.getLogger(BankOverdueTask.class);

    @Autowired
    private BankCustomerExtMapper bankCustomerExtMapper;

    /**
     * 扫描逾期借款并将对应客户账户状态改为异常
     */
    public void checkAndMarkOverdueAsException() {
//        System.out.println("=== 开始执行逾期借款账户状态异常检查 ===");
        log.info("=== 开始执行逾期借款账户状态异常检查 ===");
        try {
            // 1. 直接查出需要处理的逾期用户ID
            List<Long> overdueUserIds = bankCustomerExtMapper.selectOverdueUserIds();

            if (overdueUserIds != null && !overdueUserIds.isEmpty()) {
                // 2. 批量将这些用户的账户状态改为异常(1)
                int updateCount = bankCustomerExtMapper.updateCustomerStatusToExceptionByUserIds(overdueUserIds);
                log.info("定时任务执行完毕，共将 {} 个逾期客户的账户状态改为异常。", updateCount);
            } else {
                log.info("当前暂无需要处理的逾期用户，任务正常结束。");
            }
        } catch (Exception e) {
            log.error("执行逾期账户检查定时任务异常：", e);
        }
    }
}