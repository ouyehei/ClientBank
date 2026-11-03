import request from '@/utils/request'

// 新增信贷交易（借款）
export function addCredit(data) {
  return request({
    url: '/manage/loan/credit',
    method: 'post',
    data: data
  })
}
// 新增信贷交易（还款）
export function repayLoan(data) {
  return request({
    url: '/manage/loan/repay',
    method: 'post',
    data
  })
}
// 查询某账户的未结清借款列表
export function listUnpaidLoans(accountId) {
  return request({
    url: '/manage/loan/unpaid/' + accountId,
    method: 'get'
  })
}

// 查询某账户的负债总额（本金+利息）
export function getDebtSummary(accountId) {
  return request({
    url: '/manage/loan/debtSummary/' + accountId,
    method: 'get'
  })
}