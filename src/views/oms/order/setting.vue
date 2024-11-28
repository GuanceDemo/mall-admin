<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="orderSetting"
             ref="orderSettingForm"
             :rules="rules"
             label-width="150px">
      <el-form-item :label="$t('language.seckillOrdersExceed')+'：'" prop="flashOrderOvertime">
        <el-input v-model="orderSetting.flashOrderOvertime" class="input-width">
          <template slot="append">{{$t('language.minute')}}</template>
        </el-input>
        <span class="note-margin"> {{$t('language.orderAutomaticallyClosed')}}</span>
      </el-form-item>
      <el-form-item :label="$t('language.normalOrdersOver')+'：'" prop="normalOrderOvertime">
        <el-input v-model="orderSetting.normalOrderOvertime" class="input-width">
          <template slot="append">{{$t('language.minute')}}</template>
        </el-input>
        <span class="note-margin"> {{$t('language.orderAutomaticallyClosed')}}</span>
      </el-form-item>
      <el-form-item :label="$t('language.shipmentExceeds')+'：'" prop="confirmOvertime">
        <el-input v-model="orderSetting.confirmOvertime" class="input-width">
          <template slot="append">{{$t('language.day')}}</template>
        </el-input>
        <span class="note-margin">{{$t('language.orderAutomaticallyCompleted')}}</span>
      </el-form-item>
      <el-form-item :label="$t('language.ordersCompletedOver')+'：'" prop="finishOvertime">
        <el-input v-model="orderSetting.finishOvertime" class="input-width">
          <template slot="append">{{$t('language.day')}}</template>
        </el-input>
        <span class="note-margin"> {{$t('language.transactionAutomaticallyEnded')}}</span>
      </el-form-item>
      <el-form-item :label="$t('language.ordersCompletedOver')+'：'" prop="commentOvertime">
        <el-input v-model="orderSetting.commentOvertime" class="input-width">
          <template slot="append">{{$t('language.day')}}</template>
        </el-input>
        <span class="note-margin">{{$t('language.fivestarReviews')}}</span>
      </el-form-item>
      <el-form-item>
        <el-button
          @click="confirm('orderSettingForm')"
          type="primary">{{$t('language.submit')}}</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>
<script>
  import {getOrderSetting,updateOrderSetting} from '@/api/orderSetting';
  import { translate as $t } from "@/i18n/index.js"
  const defaultOrderSetting = {
    id: null,
    flashOrderOvertime: 0,
    normalOrderOvertime: 0,
    confirmOvertime: 0,
    finishOvertime: 0,
    commentOvertime: 0
  };
  const checkTime = (rule, value, callback) => {
    if (!value) {
      return callback(new Error($t('language.timeCannotEmpty')));
    }
    console.log("checkTime",value);
    let intValue = parseInt(value);
    if (!Number.isInteger(intValue)) {
      return callback(new Error($t('language.enterNumericValue')));
    }
    callback();
  };
  export default {
    name: 'orderSetting',
    data() {
      return {
        orderSetting: Object.assign({}, defaultOrderSetting),
        rules: {
          flashOrderOvertime:{validator: checkTime, trigger: 'blur' },
          normalOrderOvertime:{validator: checkTime, trigger: 'blur' },
          confirmOvertime: {validator: checkTime, trigger: 'blur' },
          finishOvertime: {validator: checkTime, trigger: 'blur' },
          commentOvertime:{validator: checkTime, trigger: 'blur' }
        }
      }
    },
    created(){
      this.getDetail();
    },
    methods:{
      confirm(formName){
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$confirm($t('language.sureSubmitModification'), $t('language.tips'), {
              confirmButtonText: $t('language.confirm'),
              cancelButtonText: $t('language.cancel'),
              type: 'warning'
            }).then(() => {
              updateOrderSetting(1,this.orderSetting).then(response=>{
                this.$message({
                  type: 'success',
                  message: $t('language.submittedSuccessfully'),
                  duration:1000
                });
              })
            });
          } else {
            this.$message({
              message: $t('language.parameterInvalid'),
              type: 'warning'
            });
            return false;
          }
        });
      },
      getDetail(){
        getOrderSetting(1).then(response=>{
          this.orderSetting=response.data;
        })
      }
    }
  }
</script>
<style scoped>
  .input-width {
    width: 50%;
  }

  .note-margin {
    margin-left: 15px;
  }
</style>


