import request from '@/utils/request'

// 获取资产总览数据
export function getDashboardData(userId) {
  return request({
    url: '/manage/account/dashboard',
    method: 'get',
    params: { userId: userId }
  })
}