<template>
  <div style="margin-top: 50px">
    <el-form :model="value" ref="productSaleForm" label-width="120px" class="form-inner-container" size="small">
      <el-form-item :label="$t('language.rewardingBonusPoints')+'：'">
        <el-input v-model="value.giftPoint"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.rewardGrowthValue')+'：'">
        <el-input v-model="value.giftGrowth"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.pointPurchaseRestriction')+'：'">
        <el-input v-model="value.usePointLimit"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.preAnnouncedGoods')+'：'">
        <el-switch
          v-model="value.previewStatus"
          :active-value="1"
          :inactive-value="0">
        </el-switch>
      </el-form-item>
      <el-form-item :label="$t('language.productListing')+'：'">
        <el-switch
          v-model="value.publishStatus"
          :active-value="1"
          :inactive-value="0">
        </el-switch>
      </el-form-item>
      <el-form-item :label="$t('language.offeringRecommendation')+'：'">
        <span style="margin-right: 10px">{{$t('language.newProducts')}}</span>
        <el-switch
          v-model="value.newStatus"
          :active-value="1"
          :inactive-value="0">
        </el-switch>
        <span style="margin-left: 10px;margin-right: 10px">{{$t('language.recommends')}}</span>
        <el-switch
          v-model="value.recommandStatus"
          :active-value="1"
          :inactive-value="0">
        </el-switch>
      </el-form-item>
      <el-form-item :label="$t('language.serviceAssurance')+'：'">
        <el-checkbox-group v-model="selectServiceList">
          <el-checkbox :label="1">{{$t('language.hassleFreeReturns')}}</el-checkbox>
          <el-checkbox :label="2">{{$t('language.quickRefund')}}</el-checkbox>
          <el-checkbox :label="3">{{$t('language.freePostage')}}</el-checkbox>
        </el-checkbox-group>
      </el-form-item>
      <el-form-item :label="$t('language.detailPageTitle')+'：'">
        <el-input v-model="value.detailTitle"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.detailPageDescription')+'：'">
        <el-input v-model="value.detailDesc"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.commodityKeyword')+'：'">
        <el-input v-model="value.keywords"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.productRemarks')+'：'">
        <el-input v-model="value.note" type="textarea" :autoSize="true"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.selectPreferenceMode')+'：'">
        <el-radio-group v-model="value.promotionType" size="small">
          <el-radio-button :label="0">{{$t('language.noDiscount')}}</el-radio-button>
          <el-radio-button :label="1">{{$t('language.specialPromotions')}}</el-radio-button>
          <el-radio-button :label="2">{{$t('language.memberPrice')}}</el-radio-button>
          <el-radio-button :label="3">{{$t('language.tieredPrice')}}</el-radio-button>
          <el-radio-button :label="4">{{$t('language.fullyReducedPrice')}}</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item v-show="value.promotionType===1">
        <div>
          {{$t('language.startTime')}}：
          <el-date-picker
            v-model="value.promotionStartTime"
            type="datetime"
            :picker-options="pickerOptions1"
            :placeholder="$t('language.selectStartTime')">
          </el-date-picker>
        </div>
        <div class="littleMargin">
          {{$t('language.endTime')}}：
          <el-date-picker
            v-model="value.promotionEndTime"
            type="datetime"
            :picker-options="pickerOptions1"
            :placeholder="$t('language.selectEndTime')">
          </el-date-picker>
        </div>
        <div class="littleMargin">
          {{$t('language.promotionPrice')}}：
          <el-input style="width: 220px" v-model="value.promotionPrice" :placeholder="$t('language.enterPromotionalPrice')"></el-input>
        </div>

      </el-form-item>
      <el-form-item v-show="value.promotionType===2">
        <div v-for="(item, index) in value.memberPriceList" :class="{littleMargin:index!==0}">
          {{item.memberLevelName}}：
          <el-input v-model="item.memberPrice" style="width: 200px"></el-input>
        </div>
      </el-form-item>
      <el-form-item v-show="value.promotionType===3">
        <el-table :data="value.productLadderList"
                  style="width: 80%" border>
          <el-table-column
            :label="$t('language.quantity')"
            align="center"
            width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.count"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            :label="$t('language.discounts')"
            align="center"
            width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.discount"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            align="center"
            :label="$t('language.action')">
            <template slot-scope="scope">
              <el-button type="text" @click="handleRemoveProductLadder(scope.$index, scope.row)">{{$t('language.delete')}}</el-button>
              <el-button type="text" @click="handleAddProductLadder(scope.$index, scope.row)">{{$t('language.increase')}}</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-form-item>
      <el-form-item v-show="value.promotionType===4">
        <el-table :data="value.productFullReductionList"
                  style="width: 80%" border>
          <el-table-column
            :label="$t('language.fulls')"
            align="center"
            width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.fullPrice"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            :label="$t('language.immediateReduction')"
            align="center"
            width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.reducePrice"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            align="center"
            :label="$t('language.action')">
            <template slot-scope="scope">
              <el-button type="text" @click="handleRemoveFullReduction(scope.$index, scope.row)">{{$t('language.delete')}}</el-button>
              <el-button type="text" @click="handleAddFullReduction(scope.$index, scope.row)">{{$t('language.increase')}}</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-form-item>
      <el-form-item style="text-align: center">
        <el-button size="medium" @click="handlePrev">{{$t('language.backFillInformation')}}</el-button>
        <el-button type="primary" size="medium" @click="handleNext">{{$t('language.nextProductAttributes')}}</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import {fetchList as fetchMemberLevelList} from '@/api/memberLevel'
  import { translate as $t } from "@/i18n/index.js"

  export default {
    name: "ProductSaleDetail",
    props: {
      value: Object,
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        //日期选择器配置
        pickerOptions1: {
          disabledDate(time) {
            return time.getTime() < Date.now();
          }
        }
      }
    },
    created() {
      if (this.isEdit) {
        // this.handleEditCreated();
      } else {
        fetchMemberLevelList({defaultStatus: 0}).then(response => {
          let memberPriceList = [];
          for (let i = 0; i < response.data.length; i++) {
            let item = response.data[i];
            memberPriceList.push({memberLevelId: item.id, memberLevelName: item.name})
          }
          this.value.memberPriceList = memberPriceList;
        });
      }
    },
    computed: {
      //选中的服务保证
      selectServiceList: {
        get() {
          let list = [];
          if (this.value.serviceIds === undefined || this.value.serviceIds == null || this.value.serviceIds === '') return list;
          let ids = this.value.serviceIds.split(',');
          for (let i = 0; i < ids.length; i++) {
            list.push(Number(ids[i]));
          }
          return list;
        },
        set(newValue) {
          let serviceIds = '';
          if (newValue != null && newValue.length > 0) {
            for (let i = 0; i < newValue.length; i++) {
              serviceIds += newValue[i] + ',';
            }
            if (serviceIds.endsWith(',')) {
              serviceIds = serviceIds.substr(0, serviceIds.length - 1)
            }
            this.value.serviceIds = serviceIds;
          } else {
            this.value.serviceIds = null;
          }
        }
      }
    },
    methods: {
      handleEditCreated() {
        let ids = this.value.serviceIds.split(',');
        console.log('handleEditCreated', ids);
        for (let i = 0; i < ids.length; i++) {
          this.selectServiceList.push(Number(ids[i]));
        }
      },
      handleRemoveProductLadder(index, row) {
        let productLadderList = this.value.productLadderList;
        if (productLadderList.length === 1) {
          productLadderList.pop();
          productLadderList.push({
            count: 0,
            discount: 0,
            price: 0
          })
        } else {
          productLadderList.splice(index, 1);
        }
      },
      handleAddProductLadder(index, row) {
        let productLadderList = this.value.productLadderList;
        if (productLadderList.length < 3) {
          productLadderList.push({
            count: 0,
            discount: 0,
            price: 0
          })
        } else {
          this.$message({
            message: $t('language.maximumThree'),
            type: 'warning'
          });
        }
      },
      handleRemoveFullReduction(index, row) {
        let fullReductionList = this.value.productFullReductionList;
        if (fullReductionList.length === 1) {
          fullReductionList.pop();
          fullReductionList.push({
            fullPrice: 0,
            reducePrice: 0
          });
        } else {
          fullReductionList.splice(index, 1);
        }
      },
      handleAddFullReduction(index, row) {
        let fullReductionList = this.value.productFullReductionList;
        if (fullReductionList.length < 3) {
          fullReductionList.push({
            fullPrice: 0,
            reducePrice: 0
          });
        } else {
          this.$message({
            message: $t('language.maximumThree'),
            type: 'warning'
          });
        }
      },
      handlePrev() {
        this.$emit('prevStep')
      },
      handleNext() {
        this.$emit('nextStep')
      }
    }
  }
</script>

<style scoped>
  .littleMargin {
    margin-top: 10px;
  }
</style>
