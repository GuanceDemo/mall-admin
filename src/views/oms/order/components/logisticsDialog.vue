<template> 
  <el-dialog :title="$t('language.orderTracking')"
             :visible.sync="visible"
             :before-close="handleClose"
             width="40%">
    <el-steps direction="vertical"
              :active="6"
              finish-status="success"
              space="50px">
      <el-step  v-for="item in logisticsList"
                :key="item.name"
                :title="item.name"
                :description="item.time"></el-step>
    </el-steps>
  </el-dialog>
</template>
<script>
  import { translate as $t } from "@/i18n/index.js"
  const defaultLogisticsList=[
    {name: $t('language.submittedWaitingPayment'),time:'2017-04-01 12:00:00 '},
    {name: $t('language.paidSuccessfully'),time:'2017-04-01 12:00:00 '},
    {name: $t('language.scanPendingPayment'),time:'2017-04-01 12:00:00 '},
    {name: $t('language.ShenzhenWaitingPayment'),time:'2017-04-01 12:00:00 '},
    {name: $t('language.scanningShenzhenCompany'),time:'2017-04-01 12:00:00 '},
    {name: $t('language.deliveredSoon'),time:'2017-04-01 12:00:00 '},
    {name: $t('language.receivedText'),time:'2017-04-01 12:00:00 '}
  ];
  export default {
    name:'logisticsDialog',
    props: {
      value: Boolean
    },
    computed:{
      visible: {
        get() {
          return this.value;
        },
        set(visible){
          this.value=visible;
        }
      }
    },
    data() {
      return {
        logisticsList:Object.assign({},defaultLogisticsList)
      }
    },
    methods:{
      emitInput(val) {
        this.$emit('input', val)
      },
      handleClose(){
        this.emitInput(false);
      }
    }
  }
</script>
<style></style>


