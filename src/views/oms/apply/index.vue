<template> 
  <div class="app-container">
    <el-card class="filter-container" shadow="never">
      <div>
        <i class="el-icon-search"></i>
        <span>{{$t('language.filterSearch')}}</span>
        <el-button
          style="float:right"
          type="primary"
          @click="handleSearchList()"
          size="small">
          {{$t('language.querySearch')}}
        </el-button>
        <el-button
          style="float:right;margin-right: 15px"
          @click="handleResetSearch()"
          size="small">
          {{$t('language.reset')}}
        </el-button>
      </div>
      <div style="margin-top: 15px">
        <el-form :inline="true" :model="listQuery" size="small" label-width="140px">
          <el-form-item :label="$t('language.enterSearch')+'：'">
            <el-input v-model="listQuery.id" class="input-width" :placeholder="$t('language.serviceOrderNo')"></el-input>
          </el-form-item>
          <el-form-item :label="$t('language.processingStatus')+'：'">
            <el-select v-model="listQuery.status" :placeholder="$t('language.all')" clearable class="input-width">
              <el-option v-for="item in statusOptions"
                         :key="item.value"
                         :label="item.label"
                         :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item :label="$t('language.timeApplication')+'：'">
            <el-date-picker
              class="input-width"
              v-model="listQuery.createTime"
              value-format="yyyy-MM-dd"
              type="date"
              :placeholder="$t('language.selectTime')">
            </el-date-picker>
          </el-form-item>
          <el-form-item :label="$t('language.operatorPerson')+'：'">
            <el-input v-model="listQuery.handleMan" class="input-width" :placeholder="$t('language.all')"></el-input>
          </el-form-item>
          <el-form-item :label="$t('language.processingTime')+'：'">
            <el-date-picker
              class="input-width"
              v-model="listQuery.handleTime"
              value-format="yyyy-MM-dd"
              type="date"
              :placeholder="$t('language.selectTime')">
            </el-date-picker>
          </el-form-item>
        </el-form>
      </div>
    </el-card>
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets"></i>
      <span>{{$t('language.dataList')}}</span>
    </el-card>
    <div class="table-container">
      <el-table ref="returnApplyTable"
                :data="list"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                v-loading="listLoading" border>
        <el-table-column type="selection" width="60" align="center"></el-table-column>
        <el-table-column :label="$t('language.serviceOrderNo')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.timeApplication')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.createTime | formatTime}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.userAccount')" align="center">
          <template slot-scope="scope">{{scope.row.memberUsername}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.refundAmount')" width="180" align="center">
          <template slot-scope="scope">￥{{scope.row | formatReturnAmount}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.applicationStatus')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.status | formatStatus}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.processingTime')" width="180" align="center">
          <template slot-scope="scope">{{scope.row.handleTime | formatTime}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="180" align="center">
          <template slot-scope="scope">
            <el-button
            size="mini"
            @click="handleViewDetail(scope.$index, scope.row)">{{$t('language.viewDetails')}}</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="batch-operate-container">
      <el-select
        size="small"
        v-model="operateType" :placeholder="$t('language.batchOperations')">
        <el-option
          v-for="item in operateOptions"
          :key="item.value"
          :label="item.label"
          :value="item.value">
        </el-option>
      </el-select>
      <el-button
        style="margin-left: 20px"
        class="search-button"
        @click="handleBatchOperate()"
        type="primary"
        size="small">
        {{$t('language.confirm')}}
      </el-button>
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
  import {formatDate} from '@/utils/date';
  import {fetchList,deleteApply} from '@/api/returnApply';
  import { translate as $t } from "@/i18n/index.js"
  const defaultListQuery = {
    pageNum: 1,
    pageSize: 10,
    id: null,
    receiverKeyword: null,
    status: null,
    createTime: null,
    handleMan: null,
    handleTime: null
  };
  const defaultStatusOptions=[
    {
      label: $t('language.unprocessed'),
      value: 0
    },
    {
      label: $t('language.returning'),
      value: 1
    },
    {
      label: $t('language.completed'),
      value: 2
    },
    {
      label: $t('language.rejected'),
      value: 3
    }
  ];
  export default {
    name:'returnApplyList',
    data() {
      return {
        listQuery:Object.assign({},defaultListQuery),
        statusOptions: Object.assign({},defaultStatusOptions),
        list:null,
        total:null,
        listLoading:false,
        multipleSelection:[],
        operateType:1,
        operateOptions: [
          {
            label: $t('language.bulkDelete'),
            value: 1
          }
        ],
      }
    },
    created(){
      this.getList();
    },
    filters:{
      formatTime(time) {
        if(time==null||time===''){
          return 'N/A';
        }
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd hh:mm:ss')
      },
      formatStatus(status){
        for(let i=0;i<defaultStatusOptions.length;i++){
          if(status===defaultStatusOptions[i].value){
            return defaultStatusOptions[i].label;
          }
        }
      },
      formatReturnAmount(row){
        return row.productRealPrice*row.productCount;
      }
    },
    methods:{
      handleSelectionChange(val){
        this.multipleSelection = val;
      },
      handleResetSearch() {
        this.listQuery = Object.assign({}, defaultListQuery);
      },
      handleSearchList() {
        this.listQuery.pageNum = 1;
        this.getList();
      },
      handleViewDetail(index,row){
        this.$router.push({path:'/oms/returnApplyDetail',query:{id:row.id}})
      },
      handleBatchOperate(){
        if(this.multipleSelection==null||this.multipleSelection.length<1){
          this.$message({
            message: $t('language.selectApplication'),
            type: 'warning',
            duration: 1000
          });
          return;
        }
        if(this.operateType===1){
          //批量删除
          this.$confirm($t('language.sureDelete'), $t('language.tips'), {
            confirmButtonText: $t('language.confirm'),
            cancelButtonText: $t('language.cancel'),
            type: 'warning'
          }).then(() => {
            let params = new URLSearchParams();
            let ids=[];
            for(let i=0;i<this.multipleSelection.length;i++){
              ids.push(this.multipleSelection[i].id);
            }
            params.append("ids",ids);
            deleteApply(params).then(response=>{
              this.getList();
              this.$message({
                type: 'success',
                message: $t('language.deletedSuccessfully')
              });
            });
          })
        }
      },
      handleSizeChange(val){
        this.listQuery.pageNum = 1;
        this.listQuery.pageSize = val;
        this.getList();
      },
      handleCurrentChange(val){
        this.listQuery.pageNum = val;
        this.getList();
      },
      getList(){
        this.listLoading=true;
        fetchList(this.listQuery).then(response => {
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


