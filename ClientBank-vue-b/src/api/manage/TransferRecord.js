import request from '@/utils/request'

// 查询用户转账记录列表
export function listTransferRecord(query) {
  return request({
    url: '/manage/TransferRecord/list',
    method: 'get',
    params: query
  })
}

// 查询用户转账记录详细
export function getTransferRecord(id) {
  return request({
    url: '/manage/TransferRecord/' + id,
    method: 'get'
  })
}


// 新增用户转账记录
export function addTransferRecord(data) {
  return request({
    url: '/manage/TransferRecord',
    method: 'post',
    data: data
  })
}

// 修改用户转账记录
export function updateTransferRecord(data) {
  return request({
    url: '/manage/TransferRecord',
    method: 'put',
    data: data
  })
}

// 删除用户转账记录
export function delTransferRecord(id) {
  return request({
    url: '/manage/TransferRecord/' + id,
    method: 'delete'
  })
}

// 1. 根据银行卡号获取真实姓名
export function getRealNameByCardNum(cardNum) {
  return request({
    url: '/manage/TransferRecord/getRealName',
    method: 'get',
    params: {
      cardNum // 传递参数
    }
  });
}
/**
 * 根据userId查询客户所有银行卡号
 * @param userId
 * @return from_account_ids
 */
export function getBankCardList(userId) {
  return request({
    url: `/manage/customerExt/bankNum/${userId}`,
    method: 'get'
  });
}