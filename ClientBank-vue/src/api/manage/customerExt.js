import request from '@/utils/request'

// 查询客户信息列表
export function listCustomerExt(query) {
  return request({
    url: '/manage/customerExt/list',
    method: 'get',
    params: query
  })
}

// 查询客户信息详细
export function getCustomerExt(extId) {
  return request({
    url: '/manage/customerExt/' + extId,
    method: 'get'
  })
}

// 新增客户信息
export function addCustomerExt(data) {
  return request({
    url: '/manage/customerExt',
    method: 'post',
    data: data
  })
}

// 修改客户信息
export function updateCustomerExt(data) {
  return request({
    url: '/manage/customerExt',
    method: 'put',
    data: data
  })
}

// 删除客户信息
export function delCustomerExt(extId) {
  return request({
    url: `/manage/customerExt/${extId}`,
    method: 'delete'
  })
}
export function getCustomerExtByUserId(userId) {
  return request({
    url: `/manage/customerExt/list/${userId}`, // 注意：这里对应你后端的 /list/{userId}
    method: 'get'
  })
}
