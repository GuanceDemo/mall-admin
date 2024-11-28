import request from '@/utils/request'
export function getOrderCount() {
  return request({
    url:'/order/get/orderNumber',
    method:'get',
  })
}