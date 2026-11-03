package com.ClientBank.quartz.task;

import com.ClientBank.common.utils.spring.SpringUtils;
import com.ClientBank.manage.mapper.TransferRecordMapper;
import org.springframework.stereotype.Component;
/**
 * 该类用于解冻资金
 *
 */
@Component("transferUnfreezeTask")
public class TransferUnfreezeTask {
    public void unfreezeExpiredRecords() {
        TransferRecordMapper mapper = SpringUtils.getBean(TransferRecordMapper.class);

        try {
            int count = mapper.updateTransferStatus();
            if (count > 0) {
                System.out.println("定时任务触发！时间到了，已成功解冻 " + count + " 条记录，并重新计算了余额。");
            } else {
                System.out.println("定时任务触发！当前没有需要解冻的冻结记录。");
            }
        } catch (Exception e) {
            System.err.println("定时任务解冻异常：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
