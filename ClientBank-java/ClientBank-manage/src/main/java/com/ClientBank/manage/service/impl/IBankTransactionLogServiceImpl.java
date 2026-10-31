package com.ClientBank.manage.service.impl;

import com.ClientBank.common.utils.DateUtils;
import com.ClientBank.manage.domain.BankAccount;
import com.ClientBank.manage.domain.BankTransactionLog;
import com.ClientBank.manage.mapper.BankAccountMapper;
import com.ClientBank.manage.mapper.BankTransactionLogMapper;
import com.ClientBank.manage.service.IBankTransactionLogService;
import com.ClientBank.manage.util.RandomUtil;
import com.ClientBank.system.service.ISysConfigService;
import nl.basjes.parse.useragent.utils.springframework.util.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class IBankTransactionLogServiceImpl implements IBankTransactionLogService {
    @Autowired
    private BankTransactionLogMapper bankTransactionLogMapper;
    @Autowired
    private BankAccountMapper bankAccountMapper;

    // 注入若依参数服务
    @Autowired
    private ISysConfigService configService;

    // 日利率常量：0.1%
    private static final String KEY_LOAN_DAILY_RATE = "loan.daily.interest.rate";

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertBankTransactionLog(BankTransactionLog bankTransactionLog) {
        // 1. 基础字段
        bankTransactionLog.setId("BTLog" + RandomUtil.next10());
        if (bankTransactionLog.getCreateTime() == null) {
            bankTransactionLog.setCreateTime(DateUtils.getNowDate());
        }

        // 2. 金额和状态
        if (bankTransactionLog.getAmount() == null) {
            throw new RuntimeException("借款金额不能为空");
        }
        BigDecimal principal = bankTransactionLog.getAmount().abs();
        bankTransactionLog.setAmount(bankTransactionLog.getAmount());
        bankTransactionLog.setStatus(0);

        Date dueDate = bankTransactionLog.getDueDate();
        if (dueDate == null) {
            throw new RuntimeException("借款到期日不能为空");
        }
        System.out.println("bankTransactionLog.getAccountId() = " + bankTransactionLog.getAccountId());
        BankAccount account = bankAccountMapper.selectBankAccountByCardNumber(String.valueOf(bankTransactionLog.getAccountId()));
        System.out.println("Account: " + account);
        if (account == null){
            throw new RuntimeException("账户不存在");
        }
        BigDecimal creditLimit = account.getCreditLimit();
        System.out.println("Credit Limit: " + creditLimit);
        //额度计算
        if (account.getCreditLimit().compareTo(principal) < 0) {
            throw new RuntimeException("信用额度不足！当前可用额度：" + account.getCreditLimit() + " 元");
        }

        // 4. 计算借款天数（向上取整，至少 1 天）
        Date now = bankTransactionLog.getCreateTime();
        long diffMs = dueDate.getTime() - now.getTime();
        long days = (long) Math.ceil(diffMs / (1000.0 * 60 * 60 * 24));
        if (days < 1) {
            days = 1;
        }
        BigDecimal dailyRate = getDailyRate();
        BigDecimal interest = principal
                .multiply(dailyRate)
                .multiply(BigDecimal.valueOf(days))
                .setScale(2, RoundingMode.HALF_UP);

        // 6. 回填累计利息
        bankTransactionLog.setAccumulatedInterest(interest);
        // ================= 扣减额度操作 =================
        String cardNumber = account.getCardNumber();
        int updateCount = bankAccountMapper.updateCreditLimit(
                cardNumber,
                principal.negate()
        );

        if (updateCount <= 0) {
            throw new RuntimeException("额度扣减失败，请重试");
        }
        int balanceUpdateCount = bankAccountMapper.updateBalance(
                cardNumber,
                principal
        );
        if (balanceUpdateCount <= 0) {
            throw new RuntimeException("余额增加失败，请重试");
        }
        return bankTransactionLogMapper.insertBankTransactionLog(bankTransactionLog);
    }
    /**
     * 从若依参数配置读取日利率，带容错兜底
     */
    private BigDecimal getDailyRate() {
        try {
            String rateStr = configService.selectConfigByKey(KEY_LOAN_DAILY_RATE);
            if (rateStr != null && !rateStr.trim().isEmpty()) {
                return new BigDecimal(rateStr.trim());
            }
        } catch (Exception e) {
            // 参数未配置或格式错误，走兜底
        }
        // 兜底默认值 0.001，防止后台漏配导致借款失败
        return new BigDecimal("0.001");
    }



    @Override
    public List<BankTransactionLog> selectUnpaidLoansByAccountId(Long accountId) {
        return bankTransactionLogMapper.selectUnpaidLoansByAccountId(accountId);
    }

    @Override
    public Double selectTotalDebtByAccountId(Long accountId) {
        return bankTransactionLogMapper.selectTotalDebtByAccountId(accountId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int repayLoan(String loanId, BigDecimal repayAmount) {
        // 1. 参数校验
        if (loanId == null || loanId.isEmpty()) {
            throw new RuntimeException("借据编号不能为空！");
        }
        if (repayAmount == null || repayAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("还款金额必须大于0！");
        }

        // 2. 查询该笔借款
        BankTransactionLog loan = bankTransactionLogMapper.selectBankTransactionLogById(loanId);
        if (loan == null) {
            throw new RuntimeException("借据不存在！");
        }
        if (loan.getTransactionType() == null || loan.getTransactionType() != 1) {
            throw new RuntimeException("该记录不是借款记录，无法还款！");
        }
        if (loan.getStatus() == 1) {
            throw new RuntimeException("该笔借款已结清，无需还款！");
        }

        BigDecimal principal = loan.getAmount() != null ? loan.getAmount().abs() : BigDecimal.ZERO;
        BigDecimal interest  = loan.getAccumulatedInterest() != null ? loan.getAccumulatedInterest() : BigDecimal.ZERO;
        BigDecimal totalDebt = principal.add(interest);

        // 4. 校验还款金额
        if (repayAmount.compareTo(totalDebt) > 0) {
            throw new RuntimeException("还款金额不能超过当前欠款总额 " + totalDebt + " 元！");
        }

        // ================= 新增：获取账户信息并扣款加额度 =================
        // 因为你的流水表 accountId 存的实际上是卡号，所以这里按卡号查
        BankAccount account = bankAccountMapper.selectBankAccountByCardNumber(String.valueOf(loan.getAccountId()));
        if (account == null) {
            throw new RuntimeException("账户不存在！");
        }

        // 5.1 扣除账户余额和可用余额 (传入负数)
        int balanceCount = bankAccountMapper.updateBalance(account.getCardNumber(), repayAmount.negate());
        if (balanceCount <= 0) {
            throw new RuntimeException("扣除账户余额失败！");
        }

        // 5.2 恢复信用额度
        // 注意：只有还了本金才恢复额度，还的利息不占额度。
        // 所以我们需要算出这次还款里，有多少钱是还本金的。
        BigDecimal thisRepayPrincipal = BigDecimal.ZERO;
        if (repayAmount.compareTo(interest) > 0) {
            // 还款额大于利息，说明本金也还了一部分
            thisRepayPrincipal = repayAmount.subtract(interest);
        }

        // 如果还了本金，才需要恢复对应的额度
        if (thisRepayPrincipal.compareTo(BigDecimal.ZERO) > 0) {
            int limitCount = bankAccountMapper.updateCreditLimit(account.getCardNumber(), thisRepayPrincipal);
            if (limitCount <= 0) {
                throw new RuntimeException("恢复信用额度失败！");
            }
        }
        // =================================================================

        // 6. 核心扣款逻辑：更新流水的本金和利息 (你原有的逻辑)
        if (repayAmount.compareTo(interest) >= 0) {
            BigDecimal leftForPrincipal = repayAmount.subtract(interest);
            loan.setAccumulatedInterest(BigDecimal.ZERO);
            BigDecimal remainingPrincipal = principal.subtract(leftForPrincipal);
            loan.setAmount(remainingPrincipal.negate());
        } else {
            loan.setAccumulatedInterest(interest.subtract(repayAmount));
            loan.setAmount(principal.negate());
        }

        // 7. 判断是否结清
        BigDecimal newPrincipal = loan.getAmount() != null ? loan.getAmount().abs() : BigDecimal.ZERO;
        BigDecimal newInterest  = loan.getAccumulatedInterest() != null ? loan.getAccumulatedInterest() : BigDecimal.ZERO;
        if (newPrincipal.compareTo(BigDecimal.ZERO) == 0 && newInterest.compareTo(BigDecimal.ZERO) == 0) {
            loan.setStatus(1); // 标记为已结清
        }

        // 8. 更新流水表
        return bankTransactionLogMapper.updateBankTransactionLog(loan);
    }
}
