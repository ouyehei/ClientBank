import request from '@/utils/request'

// 查询业务预约表列表
export function listReservation(query) {
  return request({
    url: '/manage/reservation/list',
    method: 'get',
    params: query
  })
}

// 查询业务预约表详细
export function getReservation(id) {
  return request({
    url: '/manage/reservation/' + id,
    method: 'get'
  })
}

// 新增业务预约表
export function addReservation(data) {
  return request({
    url: '/manage/reservation',
    method: 'post',
    data: data
  })
}

// 修改业务预约表
export function updateReservation(data) {
  return request({
    url: '/manage/reservation',
    method: 'put',
    data: data
  })
}

// 删除业务预约表
export function delReservation(id) {
  return request({
    url: '/manage/reservation/' + id,
    method: 'delete'
  })
}
