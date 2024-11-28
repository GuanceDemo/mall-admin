<template> 
  <div class="app-container">
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets"></i>
      <span>{{$t('language.shipmentList')}}</span>
    </el-card>
    <div class="table-container">
      <el-table ref="deliverOrderTable"
                style="width: 100%;"
                :data="list" border>
        <el-table-column :label="$t('language.orderNumber')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.orderSn}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.consignee')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.receiverName}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.mobilePhoneNumber')" width="160" align="center">
          <template slot-scope="scope">{{scope.row.receiverPhone}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.postalCode')" width="160" align="center">
          <template slot-scope="scope">{{scope.row.receiverPostCode}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.shipToAddress')" align="center">
          <template slot-scope="scope">{{scope.row.address}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.shippingMethod')" width="160" align="center">
          <template slot-scope="scope">
            <el-select :placeholder="$t('language.selectLogisticsCompany')"
                       v-model="scope.row.deliveryCompany"
                       size="small">
              <el-option v-for="item in companyOptions"
                         :key="item"
                         :label="item"
                         :value="item">
              </el-option>
            </el-select>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.logisticsOrderNo')" width="180" align="center">
          <template slot-scope="scope">
            <el-input size="small" v-model="scope.row.deliverySn"></el-input>
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 15px;text-align: center">
        <el-button @click="cancel">{{$t('language.cancel')}}</el-button>
        <el-button @click="confirm" type="primary">{{$t('language.confirm')}}</el-button>
      </div>
    </div>
  </div>
</template>
<script>
  import {deliveryOrder} from '@/api/order'
  import { translate as $t } from "@/i18n/index.js"
  const defaultLogisticsCompanies=[$t('language.SFExpress'),$t('language.YuantongExpress'),$t('language.ZhongtongExpress'),$t('language.YundaExpress')];
  export default {
    name: 'deliverOrderList',
    data() {
      return {
        list:[],
        companyOptions:defaultLogisticsCompanies
      }
    },
    created(){
      this.list= this.$route.query.list;
      //当list不为数组时转换为数组
      if(this.list instanceof Array===false){
        this.list=[];
      }
    },
    methods:{
      cancel(){
        this.$router.back();
      },
      confirm(){
        this.$confirm($('language.doPerformShipment'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          deliveryOrder(this.list).then(response=>{
            this.$router.back();
            this.$message({
              type: 'success',
              message: $t('language.shipmentSucceeded')
            });
          });
        }).catch(() => {
          this.$message({
            type: 'info',
            message: $t('language.shipmentCancelled')
          });
        });
      }
    }
  }
</script>
<style></style>


