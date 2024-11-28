import request from '@/utils/request'

export function fetchList(params) {
  return request({
    url: '/home/notice/query',
    method: 'get',
    params: params
  })
}

export function deleteNotice(data) {
  return request({
    url: '/home/notice/delete',
    method: 'post',
    data: data
  })
}

export function createNotice(data) {
  return request({
    url: '/home/notice/insert',
    method: 'post',
    data: data
  })
}
