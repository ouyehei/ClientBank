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

// 获取当前登录用户完整信息（含 deptId、扩展表字段）
export function getMyProfile() {
  return request({
    url: '/manage/customerExt/profile',
    method: 'get'
  })
}

// 提交个人信息修改（不含 deptId / userName / userType）
export function updateMyProfile(data) {
  return request({
    url: '/manage/customerExt/profile',
    method: 'put',
    data: data
  })
}

// 上传头像，返回 url
export function uploadAvatar(data) {
  return request({
    url: '/common/upload',
    method: 'post',
    data: data,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 修改密码（复用若依自带接口）
export function updatePassword(oldPassword, newPassword) {
  return request({
    url: '/system/user/profile/updatePwd',
    method: 'put',
    data: { oldPassword, newPassword }
  })
}