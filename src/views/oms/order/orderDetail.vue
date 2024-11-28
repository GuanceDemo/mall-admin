<template> 
  <div class="detail-container">
    <div>
      <el-steps :active="formatStepStatus(order.status)" finish-status="success" align-center>
        <el-step :title="$t('language.submittingOrder')" :description="formatTime(order.createTime)"></el-step>
        <el-step :title="$t('language.paymentOrder')" :description="formatTime(order.paymentTime)"></el-step>
        <el-step :title="$t('language.platformDelivery')" :description="formatTime(order.deliveryTime)"></el-step>
        <el-step :title="$t('language.confirmReceipt')" :description="formatTime(order.receiveTime)"></el-step>
        <el-step :title="$t('language.completeEvaluation')" :description="formatTime(order.commentTime)"></el-step>
      </el-steps>
    </div>
    <el-card shadow="never" style="margin-top: 15px">
      <div class="operate-container">
        <i class="el-icon-warning color-danger" style="margin-left: 20px"></i>
        <span class="color-danger">{{$t('language.currentOrderStatus')}}：{{order.status | formatStatus}}</span>
        <div class="operate-button-container" v-show="order.status===0">
          <el-button size="mini" @click="showUpdateReceiverDialog">{{$t('language.modifyConsigneeInformation')}}</el-button>
          <el-button size="mini" @click="showUpdateMoneyDialog">{{$t('language.modifyingFeeInformation')}}</el-button>
          <el-button size="mini" @click="showMessageDialog">{{$t('language.sendingInternalMessage')}}</el-button>
          <el-button size="mini" @click="showCloseOrderDialog">{{$t('language.closeOrder')}}</el-button>
          <el-button size="mini" @click="showMarkOrderDialog">{{$t('language.remarksOrder')}}</el-button>
        </div>
        <div class="operate-button-container" v-show="order.status===1">
          <el-button size="mini" @click="showUpdateReceiverDialog">{{$t('language.modifyConsigneeInformation')}}</el-button>
          <el-button size="mini" @click="showMessageDialog">{{$t('language.sendingInternalMessage')}}</el-button>
          <el-button size="mini">{{$t('language.cancelingOrder')}}</el-button>
          <el-button size="mini" @click="showMarkOrderDialog">{{$t('language.remarksOrder')}}</el-button>
        </div>
        <div class="operate-button-container" v-show="order.status===2||order.status===3">
          <el-button size="mini" @click="showLogisticsDialog">{{$t('language.orderTracking')}}</el-button>
          <el-button size="mini" @click="showMessageDialog">{{$t('language.sendingInternalMessage')}}</el-button>
          <el-button size="mini" @click="showMarkOrderDialog">{{$t('language.remarksOrder')}}</el-button>
        </div>
        <div class="operate-button-container" v-show="order.status===4">
          <el-button size="mini" @click="handleDeleteOrder">{{$t('language.deleteOrders')}}</el-button>
          <el-button size="mini" @click="showMarkOrderDialog">{{$t('language.remarksOrder')}}</el-button>
        </div>
      </div>
      <div style="margin-top: 20px">
        <svg-icon icon-class="marker" style="color: #606266"></svg-icon>
        <span class="font-small">{{$t('language.basicInfo')}}</span>
      </div>
      <div class="table-layout">
        <el-row>
          <el-col :span="4" class="table-cell-title">{{$t('language.orderNumber')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.serialNumber')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.userAccount')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.modePayment')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.orderSource')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.orderType')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="4" class="table-cell">{{order.orderSn}}</el-col>
          <el-col :span="4" class="table-cell">{{$t('language.nonePresent')}}</el-col>
          <el-col :span="4" class="table-cell">{{order.memberUsername}}</el-col>
          <el-col :span="4" class="table-cell">{{order.payType | formatPayType}}</el-col>
          <el-col :span="4" class="table-cell">{{order.sourceType | formatSourceType}}</el-col>
          <el-col :span="4" class="table-cell">{{order.orderType | formatOrderType}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="4" class="table-cell-title">{{$t('language.shippingMethod')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.logisticsOrderNo')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.automaticConfirmationReceiving')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.preferentialCurrencyOrders')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.growthValueOrders')}}</el-col>
          <el-col :span="4" class="table-cell-title">{{$t('language.eventInfo')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="4" class="table-cell">{{order.deliveryCompany | formatNull}}</el-col>
          <el-col :span="4" class="table-cell">{{order.deliverySn | formatNull}}</el-col>
          <el-col :span="4" class="table-cell">{{order.autoConfirmDay}}天</el-col>
          <el-col :span="4" class="table-cell">{{order.integration}}</el-col>
          <el-col :span="4" class="table-cell">{{order.growth}}</el-col>
          <el-col :span="4" class="table-cell">
            <el-popover
              placement="top-start"
              :title="$t('language.eventInfo')"
              width="200"
              trigger="hover"
              :content="order.promotionInfo">
              <span slot="reference">{{order.promotionInfo | formatLongText}}</span>
            </el-popover>
          </el-col>
        </el-row>
      </div>
      <div style="margin-top: 20px">
        <svg-icon icon-class="marker" style="color: #606266"></svg-icon>
        <span class="font-small">{{$t('language.consigneeInformation')}}</span>
      </div>
      <div class="table-layout">
        <el-row>
          <el-col :span="6" class="table-cell-title">{{$t('language.consignee')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.mobilePhoneNumber')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.postalCode')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.shipToAddress')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell">{{order.receiverName}}</el-col>
          <el-col :span="6" class="table-cell">{{order.receiverPhone}}</el-col>
          <el-col :span="6" class="table-cell">{{order.receiverPostCode}}</el-col>
          <el-col :span="6" class="table-cell">{{order | formatAddress}}</el-col>
        </el-row>
      </div>
      <div style="margin-top: 20px">
        <svg-icon icon-class="marker" style="color: #606266"></svg-icon>
        <span class="font-small">{{$t('language.productInformation')}}</span>
      </div>
      <el-table
        ref="orderItemTable"
        :data="order.orderItemList"
        style="width: 100%;margin-top: 20px" border>
        <el-table-column :label="$t('language.productImage')" width="120" align="center">
          <template slot-scope="scope">
            <img :src="scope.row.productPic" style="height: 80px">
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.productName')" align="center">
          <template slot-scope="scope">
            <p>{{scope.row.productName}}</p>
            <p>{{$t('language.brand')}}：{{scope.row.productBrand}}</p>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.price')+'/'+$t('language.goodsNo')" width="120" align="center">
          <template slot-scope="scope">
            <p>{{$t('language.price')}}：￥{{scope.row.productPrice}}</p>
            <p>{{$t('language.goodsNo')}}：{{scope.row.productSn}}</p>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.attributes')" width="120" align="center">
          <template slot-scope="scope">
            {{scope.row.productAttr | formatProductAttr}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.quantity')" width="120" align="center">
          <template slot-scope="scope">
            {{scope.row.productQuantity}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.subtotal')" width="120" align="center">
          <template slot-scope="scope">
            ￥{{scope.row.productPrice*scope.row.productQuantity}}
          </template>
        </el-table-column>
      </el-table>
      <div style="float: right;margin: 20px">
        {{$t('language.totals')}}：<span class="color-danger">￥{{order.totalAmount}}</span>
      </div>
      <div style="margin-top: 60px">
        <svg-icon icon-class="marker" style="color: #606266"></svg-icon>
        <span class="font-small">{{$t('language.feeInformation')}}</span>
      </div>
      <div class="table-layout">
        <el-row>
          <el-col :span="6" class="table-cell-title">{{$t('language.totalCommodities')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.freightCharges')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.coupons')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.bonusPointDeduction')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell">￥{{order.totalAmount}}</el-col>
          <el-col :span="6" class="table-cell">￥{{order.freightAmount}}</el-col>
          <el-col :span="6" class="table-cell">-￥{{order.couponAmount}}</el-col>
          <el-col :span="6" class="table-cell">-￥{{order.integrationAmount}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell-title">{{$t('language.eventOffers')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.discountAmount')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.totalOrderAmount')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.amountPayable')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell">-￥{{order.promotionAmount}}</el-col>
          <el-col :span="6" class="table-cell">-￥{{order.discountAmount}}</el-col>
          <el-col :span="6" class="table-cell">
            <span class="color-danger">￥{{order.totalAmount+order.freightAmount}}</span>
          </el-col>
          <el-col :span="6" class="table-cell">
            <span class="color-danger">￥{{order.payAmount+order.freightAmount-order.discountAmount}}</span>
          </el-col>
        </el-row>
      </div>
      <div style="margin-top: 20px">
        <svg-icon icon-class="marker" style="color: #606266"></svg-icon>
        <span class="font-small">{{$t('language.operatioInfo')}}</span>
      </div>
      <el-table style="margin-top: 20px;width: 100%"
                ref="orderHistoryTable"
                :data="order.historyList" border>
        <el-table-column :label="$t('language.operators')"  width="120" align="center">
          <template slot-scope="scope">
            {{scope.row.operateMan}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.operationTime')"  width="160" align="center">
          <template slot-scope="scope">
            {{formatTime(scope.row.createTime)}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.orderStatus')"  width="120" align="center">
          <template slot-scope="scope">
            {{scope.row.orderStatus | formatStatus}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.paymentStatus')"  width="120" align="center">
          <template slot-scope="scope">
            {{scope.row.orderStatus | formatPayStatus}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.shipmentStatus')"  width="120" align="center">
          <template slot-scope="scope">
            {{scope.row.orderStatus | formatDeliverStatus}}
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.note')" align="center">
          <template slot-scope="scope">
            {{scope.row.note}}
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <el-dialog :title="$t('language.modifyConsigneeInformation')"
               :visible.sync="receiverDialogVisible"
               width="40%">
      <el-form :model="receiverInfo"
               ref="receiverInfoForm"
               label-width="150px">
        <el-form-item :label="$t('language.nameConsignee')+'：'">
          <el-input v-model="receiverInfo.receiverName" style="width: 200px"></el-input>
        </el-form-item>
        <el-form-item :label="$t('language.mobilePhoneNumber')+'：'">
          <el-input v-model="receiverInfo.receiverPhone" style="width: 200px">
          </el-input>
        </el-form-item>
        <el-form-item :label="$t('language.postalCode')+'：'">
          <el-input v-model="receiverInfo.receiverPostCode" style="width: 200px">
          </el-input>
        </el-form-item>
        <el-form-item :label="$t('language.regions')+'：'">
          <v-distpicker :province="receiverInfo.receiverProvince"
                        :city="receiverInfo.receiverCity"
                        :area="receiverInfo.receiverRegion"
                        @selected="onSelectRegion"></v-distpicker>
        </el-form-item>
        <el-form-item :label="$t('language.detailedAddress')+'：'">
          <el-input v-model="receiverInfo.receiverDetailAddress" type="textarea" rows="3">
          </el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
      <el-button @click="receiverDialogVisible = false">{{$t('language.cancle')}}</el-button>
      <el-button type="primary" @click="handleUpdateReceiverInfo">{{$t('language.determined')}}</el-button>
      </span>
    </el-dialog>
    <el-dialog :title="$t('language.modifyingFeeInformation')"
               :visible.sync="moneyDialogVisible"
               width="40%">
      <div class="table-layout">
        <el-row>
          <el-col :span="6" class="table-cell-title">{{$t('language.totalCommodities')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.freightCharges')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.coupons')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.bonusPointDeduction')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell">￥{{order.totalAmount}}</el-col>
          <el-col :span="6" class="table-cell">
            <el-input v-model.number="moneyInfo.freightAmount" size="mini"><template slot="prepend">￥</template></el-input>
          </el-col>
          <el-col :span="6" class="table-cell">-￥{{order.couponAmount}}</el-col>
          <el-col :span="6" class="table-cell">-￥{{order.integrationAmount}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell-title">{{$t('language.eventOffers')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.discountAmount')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.totalOrderAmount')}}</el-col>
          <el-col :span="6" class="table-cell-title">{{$t('language.amountPayable')}}</el-col>
        </el-row>
        <el-row>
          <el-col :span="6" class="table-cell">-￥{{order.promotionAmount}}</el-col>
          <el-col :span="6" class="table-cell">
            <el-input v-model.number="moneyInfo.discountAmount" size="mini"><template slot="prepend">-￥</template></el-input>
          </el-col>
          <el-col :span="6" class="table-cell">
            <span class="color-danger">￥{{order.totalAmount+moneyInfo.freightAmount}}</span>
          </el-col>
          <el-col :span="6" class="table-cell">
            <span class="color-danger">￥{{order.payAmount+moneyInfo.freightAmount-moneyInfo.discountAmount}}</span>
          </el-col>
        </el-row>
      </div>
      <span slot="footer" class="dialog-footer">
      <el-button @click="moneyDialogVisible = false">{{$t('language.cancle')}}</el-button>
      <el-button type="primary" @click="handleUpdateMoneyInfo">{{$t('language.determined')}}</el-button>
      </span>
    </el-dialog>
    <el-dialog :title="$t('language.sendingInternalMessage')"
               :visible.sync="messageDialogVisible"
               width="40%">
      <el-form :model="message"
               ref="receiverInfoForm"
               label-width="150px">
        <el-form-item :label="$t('language.titles')+'：'">
          <el-input v-model="message.title" style="width: 200px"></el-input>
        </el-form-item>
        <el-form-item :label="$t('language.contents')+'：'">
          <el-input v-model="message.content" type="textarea" rows="3">
          </el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="messageDialogVisible = false">{{$t('language.cancle')}}</el-button>
        <el-button type="primary" @click="handleSendMessage">{{$t('language.determined')}}</el-button>
      </span>
    </el-dialog>
    <el-dialog :title="$t('language.closeOrder')"
               :visible.sync="closeDialogVisible"
               width="40%">
      <el-form :model="closeInfo"
               label-width="150px">
        <el-form-item :label="$t('language.operationRemarks')+'：'">
          <el-input v-model="closeInfo.note" type="textarea" rows="3">
          </el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="closeDialogVisible = false">{{$t('language.cancle')}}</el-button>
        <el-button type="primary" @click="handleCloseOrder">{{$t('language.determined')}}</el-button>
      </span>
    </el-dialog>
    <el-dialog :title="$t('language.remarksOrder')"
               :visible.sync="markOrderDialogVisible"
               width="40%">
      <el-form :model="markInfo"
               label-width="150px">
        <el-form-item :label="$t('language.operationRemarks')+'：'">
          <el-input v-model="markInfo.note" type="textarea" rows="3">
          </el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="markOrderDialogVisible = false">{{$t('language.cancle')}}</el-button>
        <el-button type="primary" @click="handleMarkOrder">{{$t('language.determined')}}</el-button>
      </span>
    </el-dialog>
    <logistics-dialog v-model="logisticsDialogVisible"></logistics-dialog>
  </div>
</template>
<script>
  import {getOrderDetail,updateReceiverInfo,updateMoneyInfo,closeOrder,updateOrderNote,deleteOrder,cancelTimeOrder} from '@/api/order';
  import LogisticsDialog from '@/views/oms/order/components/logisticsDialog';
  import {formatDate} from '@/utils/date';
  import VDistpicker from 'v-distpicker';
  import { translate as $t } from "@/i18n/index.js"
  const defaultReceiverInfo = {
    orderId:null,
    receiverName:null,
    receiverPhone:null,
    receiverPostCode:null,
    receiverDetailAddress:null,
    receiverProvince:null,
    receiverCity:null,
    receiverRegion:null,
    status:null
  };
  export default {
    name: 'orderDetail',
    components: { VDistpicker, LogisticsDialog},
    data() {
      return {
        id: null,
        order: {},
        receiverDialogVisible:false,
        receiverInfo:Object.assign({},defaultReceiverInfo),
        moneyDialogVisible:false,
        moneyInfo:{orderId:null, freightAmount:0, discountAmount:0,status:null},
        messageDialogVisible:false,
        message: {title:null, content:null},
        closeDialogVisible:false,
        closeInfo:{note:null,id:null},
        markOrderDialogVisible:false,
        markInfo:{note:null},
        logisticsDialogVisible:false
      }
    },
    created() {
      this.id = this.list = this.$route.query.id;
      getOrderDetail(this.id).then(response => {
        this.order = response.data;
      });
    },
    filters: {
      formatNull(value) {
        if(value===undefined||value===null||value===''){
          return $t('language.nonePresent');
        }else{
          return value;
        }
      },
      formatLongText(value) {
        if(value===undefined||value===null||value===''){
          return $t('language.nonePresent');
        }else if(value.length>8){
          return value.substr(0, 8) + '...';
        }else{
          return value;
        }
      },
      formatPayType(value) {
        if (value === 1) {
          return $t('language.Paypal');
        } else if (value === 2) {
          return $t('language.Wechat');
        } else {
          return $t('language.unpaid');
        }
      },
      formatSourceType(value) {
        if (value === 1) {
          return $t('language.APPOrder');
        } else {
          return $t('language.PCOrders');
        }
      },
      formatOrderType(value) {
        if (value === 1) {
          return $t('language.seckillOrder');
        } else {
          return $t('language.normalOrder');
        }
      },
      formatAddress(order) {
        let str = order.receiverProvince;
        if (order.receiverCity != null) {
          str += "  " + order.receiverCity;
        }
        str += "  " + order.receiverRegion;
        str += "  " + order.receiverDetailAddress;
        return str;
      },
      formatStatus(value) {
        if (value === 1) {
          return $t('language.pendingShipment');
        } else if (value === 2) {
          return $t('language.shipped');
        } else if (value === 3) {
          return $t('language.completed');
        } else if (value === 4) {
          return $t('language.closed');
        } else if (value === 5) {
          return $t('language.invalidOrder');
        } else {
          return $t('language.pendingPayment');
        }
      },
      formatPayStatus(value) {
        if (value === 0) {
          return $t('language.unpaid');
        } else if(value===4){
          return $t('language.refunded');
        }else{
          return $t('language.paid');
        }
      },
      formatDeliverStatus(value) {
        if (value === 0||value === 1) {
          return $t('language.unshipped');
        } else {
          return $t('language.shipped');
        }
      },
      formatProductAttr(value){
        if(value==null){
          return '';
        }else{
          let attr = JSON.parse(value);
          let result='';
          for(let i=0;i<attr.length;i++){
            result+=attr[i].key;
            result+=":";
            result+=attr[i].value;
            result+=";";
          }
          return result;
        }
      }
    },
    methods: {
      onSelectRegion(data){
        this.receiverInfo.receiverProvince=data.province.value;
        this.receiverInfo.receiverCity=data.city.value;
        this.receiverInfo.receiverRegion=data.area.value;
      },
      formatTime(time) {
        if (time == null || time === '') {
          return '';
        }
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd hh:mm:ss')
      },
      formatStepStatus(value) {
        if (value === 1) {
          //待发货
          return 2;
        } else if (value === 2) {
          //已发货
          return 3;
        } else if (value === 3) {
          //已完成
          return 4;
        }else {
          //待付款、已关闭、无限订单
          return 1;
        }
      },
      showUpdateReceiverDialog(){
        this.receiverDialogVisible=true;
        this.receiverInfo={
          orderId:this.order.id,
          receiverName:this.order.receiverName,
          receiverPhone:this.order.receiverPhone,
          receiverPostCode:this.order.receiverPostCode,
          receiverDetailAddress:this.order.receiverDetailAddress,
          receiverProvince:this.order.receiverProvince,
          receiverCity:this.order.receiverCity,
          receiverRegion:this.order.receiverRegion,
          status:this.order.status
        }
      },
      handleUpdateReceiverInfo(){
        this.$confirm($t('language.modifyReceivingInformation'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          updateReceiverInfo(this.receiverInfo).then(response=>{
            this.receiverDialogVisible=false;
            this.$message({
              type: 'success',
              message: $t('language.modificationSuccess')
            });
            getOrderDetail(this.id).then(response => {
              this.order = response.data;
            });
          });
        });
      },
      showUpdateMoneyDialog(){
        this.moneyDialogVisible=true;
        this.moneyInfo.orderId=this.order.id;
        this.moneyInfo.freightAmount=this.order.freightAmount;
        this.moneyInfo.discountAmount=this.order.discountAmount;
        this.moneyInfo.status=this.order.status;
      },
      handleUpdateMoneyInfo(){
        this.$confirm($t('language.modifyFeeInformation'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          updateMoneyInfo(this.moneyInfo).then(response=>{
            this.moneyDialogVisible=false;
            this.$message({
              type: 'success',
              message: $t('language.modificationSuccess')
            });
            getOrderDetail(this.id).then(response => {
              this.order = response.data;
            });
          });
        });
      },
      showMessageDialog(){
        this.messageDialogVisible=true;
        this.message.title=null;
        this.message.content=null;
      },
      handleSendMessage(){
        this.$confirm($t('language.sendInternalMessage'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          this.messageDialogVisible=false;
          this.$message({
            type: 'success',
            message: $t('language.sentSuccessfully')
          });
        });
      },
      showCloseOrderDialog(){
        this.closeDialogVisible=true;
        this.closeInfo.note=null;
        this.closeInfo.id=this.id;
      },
      handleCloseOrder(){
        this.$confirm($t('language.doClose'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
            let params = new URLSearchParams();
            params.append("ids",[this.closeInfo.id]);
            params.append("note",this.closeInfo.note);
            closeOrder(params).then(response=>{
              this.closeDialogVisible=false;
              this.$message({
                type: 'success',
                message: $t('language.orderClosedSuccessfully')
              });
              getOrderDetail(this.id).then(response => {
                this.order = response.data;
              });
            });
        });
      },
      showMarkOrderDialog(){
        this.markOrderDialogVisible=true;
        this.markInfo.id=this.id;
        this.closeOrder.note=null;
      },
      handleMarkOrder(){
        this.$confirm($t('language.whetherRemarkOrder'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          let params = new URLSearchParams();
          params.append("id",this.markInfo.id);
          params.append("note",this.markInfo.note);
          params.append("status",this.order.status);
          updateOrderNote(params).then(response=>{
            this.markOrderDialogVisible=false;
            this.$message({
              type: 'success',
              message: $t('language.orderRemarkSucceeded')
            });
            getOrderDetail(this.id).then(response => {
              this.order = response.data;
            });
          });
        });
      },
      handleCancelOrder(){
        this.$confirm($t('language.sureCancelOrder'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          let params = new URLSearchParams();
          params.append("ids",[this.id]);
          cancelTimeOrder(params).then(response=>{
            this.$message({
              message: $t('language.canceledSuccessfully'),
              type: 'success',
              duration: 1000
            });
            this.$router.back();
          });
        })
      },
      handleDeleteOrder(){
        this.$confirm($t('language.sureDeletion'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          let params = new URLSearchParams();
          params.append("ids",[this.id]);
          deleteOrder(params).then(response=>{
            this.$message({
              message: $t('language.deletedSuccessfully'),
              type: 'success',
              duration: 1000
            });
            this.$router.back();
          });
        })
      },
      showLogisticsDialog(){
        this.logisticsDialogVisible=true;
      }
    }
  }
</script>
<style scoped>
  .detail-container {
    width: 80%;
    padding: 20px 20px 20px 20px;
    margin: 20px auto;
  }

  .operate-container {
    background: #F2F6FC;
    height: 80px;
    margin: -20px -20px 0;
    line-height: 80px;
  }

  .operate-button-container {
    float: right;
    margin-right: 20px
  }

  .table-layout {
    margin-top: 20px;
    border-left: 1px solid #DCDFE6;
    border-top: 1px solid #DCDFE6;
  }

  .table-cell {
    height: 60px;
    line-height: 40px;
    border-right: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
    padding: 10px;
    font-size: 14px;
    color: #606266;
    text-align: center;
    overflow: hidden;
  }

  .table-cell-title {
    border-right: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
    padding: 10px;
    background: #F2F6FC;
    text-align: center;
    font-size: 14px;
    color: #303133;
  }
</style>
