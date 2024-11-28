<template> 
  <div class="app-container">
    <el-card class="filter-container" shadow="never">
      <div>
        <i class="el-icon-search"></i>
        <span>{{$t("language.filterSearch")}}</span>
        <el-button
          style="float:right"
          type="primary"
          @click="handleSearchList()"
          size="small">
          {{$t("language.querySearch")}}
        </el-button>
        <el-button
          style="float:right;margin-right: 15px"
          @click="handleResetSearch()"
          size="small">
          {{$t("language.reset")}}
        </el-button>
      </div>
      <div style="margin-top: 15px">
        <el-form :inline="true" :model="listQuery" size="small" label-width="140px">
          <el-form-item :label="$t('language.couponName')">
            <el-input v-model="listQuery.name" class="input-width" :placeholder="$t('language.couponName')"></el-input>
          </el-form-item>
          <el-form-item :label="$t('language.couponType')">
            <el-select v-model="listQuery.type" :placeholder="$t('language.all')" clearable class="input-width">
              <el-option v-for="item in typeOptions"
                         :key="item.value"
                         :label="item.label"
                         :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </div>
    </el-card>
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets"></i>
      <span>{{$t("language.dataList")}}</span>
      <el-button size="mini" class="btn-add" @click="handleAdd()">{{$t("language.add")}}</el-button>
    </el-card>
    <div class="table-container">
      <el-table ref="couponTable"
                :data="list"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                v-loading="listLoading" border>
        <el-table-column type="selection" width="60" align="center"></el-table-column>
        <el-table-column :label="$t('language.numbering')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.couponName')" align="center">
          <template slot-scope="scope">{{scope.row.name}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.couponType')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.type | formatType}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.availableProduct')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.useType | formatUseType}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.usageThreshold')" width="140" align="center">
          <template slot-scope="scope">{{$t("language.fulls")}} {{scope.row.minPoint}} {{$t("language.usable")}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.faceValue')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.amount}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.applicablePlatform')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.platform | formatPlatform}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.validityPeriod')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.startTime|formatDate}}-{{scope.row.endTime|formatDate}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.status')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.endTime | formatStatus}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="180" align="center">
          <template slot-scope="scope">
            <el-button size="mini"
                       type="text"
                       @click="handleView(scope.$index, scope.row)">{{$t("language.view")}}</el-button>
            <el-button size="mini"
                       type="text"
                       @click="handleUpdate(scope.$index, scope.row)">
              {{$t("language.edit")}}</el-button>
            <el-button size="mini"
                       type="text"
                       @click="handleDelete(scope.$index, scope.row)">{{$t("language.delete")}}</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="pagination-container">
      <el-pagination
        background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        layout="total, sizes,prev, pager, next,jumper"
        :current-page.sync="listQuery.pageNum"
        :page-size="listQuery.pageSize"
        :page-sizes="[5,10,15]"
        :total="total">
      </el-pagination>
    </div>
  </div>
</template>
<script>
  import {fetchList,deleteCoupon} from '@/api/coupon';
  import {formatDate} from '@/utils/date';
  import {translate as $t} from "../../../i18n";
  const defaultListQuery = {
    pageNum: 1,
    pageSize: 10,
    name: null,
    type: null
  };
  const defaultTypeOptions=[
    {
      label: $t('language.allCoupon'),
      value: 0
    },
    {
      label: $t('language.membershipCoupon'),
      value: 1
    },
    {
      label: $t('language.giftCoupon'),
      value: 2
    },
    {
      label: $t('language.registrationCoupon'),
      value: 3
    }
  ];
  export default {
    name:'couponList',
    data() {
      return {
        listQuery:Object.assign({},defaultListQuery),
        typeOptions:Object.assign({},defaultTypeOptions),
        list:null,
        total:null,
        listLoading:false,
        multipleSelection:[]
      }
    },
    created(){
      this.getList();
    },
    filters:{
      formatType(type){
        for(let i=0;i<defaultTypeOptions.length;i++){
          if(type===defaultTypeOptions[i].value){
            return defaultTypeOptions[i].label;
          }
        }
        return '';
      },
      formatUseType(useType){
        if(useType===0){
          return $t('language.wholeSite');
        }else if(useType===1){
          return $t('language.specifiedCategory');
        }else{
          return $t('language.specifiedProduct');
        }
      },
      formatPlatform(platform){
        if(platform===1){
          return $t('language.mobilePlatform');
        }else if(platform===2){
          return $t('language.pcPlatform');
        }else{
          return $t('language.allPlatform');
        }
      },
      formatDate(time){
        if(time==null||time===''){
          return 'N/A';
        }
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd')
      },
      formatStatus(endTime){
        let now = new Date().getTime();
        let endDate = new Date(endTime);
        if(endDate>now){
          return $t('language.notExpired')
        }else{
          return $t('language.expired');
        }
      }
    },
    methods:{
      handleResetSearch() {
        this.listQuery = Object.assign({}, defaultListQuery);
      },
      handleSearchList() {
        this.listQuery.pageNum = 1;
        this.getList();
      },
      handleSelectionChange(val){
        this.multipleSelection = val;
      },
      handleSizeChange(val) {
        this.listQuery.pageNum = 1;
        this.listQuery.pageSize = val;
        this.getList();
      },
      handleCurrentChange(val) {
        this.listQuery.pageNum = val;
        this.getList();
      },
      handleAdd(){
        this.$router.push({path: '/sms/addCoupon'})
      },
      handleView(index, row) {
        this.$router.push({path: '/sms/couponHistory', query: {id: row.id}})
      },
      handleUpdate(index, row) {
        this.$router.push({path: '/sms/updateCoupon', query: {id: row.id}})
      },
      handleDelete(index, row) {
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          deleteCoupon(row.id).then(response=>{
            this.$message({
              type: 'success',
              message: $t('language.deleteSuccess')
            });
            this.getList();
          });
        })
      },
      getList(){
        this.listLoading=true;
        fetchList(this.listQuery).then(response=>{
          this.listLoading = false;
          this.list = response.data.list;
          this.total = response.data.total;
        });
      }
    }
  }
</script>
<style scoped>
  .input-width {
    width: 203px;
  }
</style>


