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
          <el-form-item :label="$t('language.name')">
            <el-input v-model="listQuery.productName" class="input-width" :placeholder="$t('language.name')"></el-input>
          </el-form-item>
          <el-form-item :label="$t('language.goodStatus')">
            <el-select v-model="listQuery.recommendStatus" :placeholder="$t('language.all')" clearable class="input-width">
              <el-option v-for="item in recommendOptions"
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
      <el-button size="mini" class="btn-add" @click="handleSelectSubject()">{{$t("language.selectTopic")}}</el-button>
    </el-card>
    <div class="table-container">
      <el-table ref="newSubjectTable"
                :data="list"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                v-loading="listLoading" border>
        <el-table-column type="selection" width="60" align="center"></el-table-column>
        <el-table-column :label="$t('language.numbering')" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.name')" align="center">
          <template slot-scope="scope">{{scope.row.subjectName}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.recommendedOrNot')" width="200" align="center">
          <template slot-scope="scope">
            <el-switch
              @change="handleRecommendStatusStatusChange(scope.$index, scope.row)"
              :active-value="1"
              :inactive-value="0"
              v-model="scope.row.recommendStatus">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.sorting')" width="160" align="center">
          <template slot-scope="scope">{{scope.row.sort}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.status')" width="160" align="center">
          <template slot-scope="scope">{{scope.row.recommendStatus | formatRecommendStatus}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="180" align="center">
          <template slot-scope="scope">
            <el-button size="mini"
                       type="text"
                       @click="handleEditSort(scope.$index, scope.row)">{{$t("language.setSorting")}}
            </el-button>
            <el-button size="mini"
                       type="text"
                       @click="handleDelete(scope.$index, scope.row)">{{$t("language.delete")}}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="batch-operate-container">
      <el-select
        size="small"
        v-model="operateType" :placeholder="$t('language.batchOperations')">
        <el-option
          v-for="item in operates"
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
        {{$t("language.confirm")}}
      </el-button>
    </div>
    <div class="pagination-container">
      <el-pagination
        background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        layout="total, sizes,prev, pager, next,jumper"
        :page-size="listQuery.pageSize"
        :page-sizes="[5,10,15]"
        :current-page.sync="listQuery.pageNum"
        :total="total">
      </el-pagination>
    </div>
    <el-dialog :title="$t('language.selectTopic')" :visible.sync="selectDialogVisible" width="50%">
      <el-input v-model="dialogData.listQuery.keyword"
                style="width: 250px;margin-bottom: 20px"
                size="small"
                :placeholder="$t('language.topicSearch')">
        <el-button slot="append" icon="el-icon-search" @click="handleSelectSearch()"></el-button>
      </el-input>
      <el-table :data="dialogData.list"
                @selection-change="handleDialogSelectionChange" border>
        <el-table-column type="selection" width="60" align="center"></el-table-column>
        <el-table-column :label="$t('language.topicName')" align="center">
          <template slot-scope="scope">{{scope.row.title}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.category')" width="160" align="center">
          <template slot-scope="scope">{{scope.row.categoryName}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.startTime')" width="160" align="center">
          <template slot-scope="scope">{{scope.row.createTime | formatTime}}</template>
        </el-table-column>
      </el-table>
      <div class="pagination-container">
        <el-pagination
          background
          @size-change="handleDialogSizeChange"
          @current-change="handleDialogCurrentChange"
          layout="prev, pager, next"
          :current-page.sync="dialogData.listQuery.pageNum"
          :page-size="dialogData.listQuery.pageSize"
          :page-sizes="[5,10,15]"
          :total="dialogData.total">
        </el-pagination>
      </div>
      <div style="clear: both;"></div>
      <div slot="footer">
        <el-button  size="small" @click="selectDialogVisible = false">{{$t("language.cancle")}}</el-button>
        <el-button  size="small" type="primary" @click="handleSelectDialogConfirm()">{{$t("language.confirm")}}</el-button>
      </div>
    </el-dialog>
    <el-dialog :title="$t('language.setSorting')"
               :visible.sync="sortDialogVisible"
               width="40%">
      <el-form :model="sortDialogData"
               label-width="150px">
        <el-form-item :title="$t('language.sorting')">
          <el-input v-model="sortDialogData.sort" style="width: 200px"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="sortDialogVisible = false" size="small">{{$t("language.cancle")}}</el-button>
        <el-button type="primary" @click="handleUpdateSort" size="small">{{$t("language.confirm")}}</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
  import {fetchList,updateRecommendStatus,deleteHomeSubject,createHomeSubject,updateHomeSubjectSort} from '@/api/homeSubject';
  import {fetchList as fetchSubjectList} from '@/api/subject';
  import {formatDate} from '@/utils/date';
  import {translate as $t} from "../../../i18n";

  const defaultListQuery = {
    pageNum: 1,
    pageSize: 5,
    subjectName: null,
    recommendStatus: null
  };
  const defaultRecommendOptions = [
    {
      label: $t('language.notRecommended'),
      value: 0
    },
    {
      label: $t('language.recommending'),
      value: 1
    }
  ];
  export default {
    name: 'homeSubjectList',
    data() {
      return {
        listQuery: Object.assign({}, defaultListQuery),
        recommendOptions: Object.assign({}, defaultRecommendOptions),
        list: null,
        total: null,
        listLoading: false,
        multipleSelection: [],
        operates: [
          {
            label: $t('language.setRecommending'),
            value: 0
          },
          {
            label: $t('language.cancelRecommending'),
            value: 1
          },
          {
            label: $t('language.delete'),
            value: 2
          }
        ],
        operateType: null,
        selectDialogVisible:false,
        dialogData:{
          list: null,
          total: null,
          multipleSelection:[],
          listQuery:{
            keyword: null,
            pageNum: 1,
            pageSize: 5
          }
        },
        sortDialogVisible:false,
        sortDialogData:{sort:0,id:null}
      }
    },
    created() {
      this.getList();
    },
    filters:{
      formatRecommendStatus(status){
        if(status===1){
          return $t('language.notRecommended')
        }else{
          return $t('language.recommending')
        }
      },
      formatTime(time){
        if(time==null||time===''){
          return 'N/A';
        }
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd hh:mm:ss')
      },
    },
    methods: {
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
      handleRecommendStatusStatusChange(index,row){
        this.updateRecommendStatusStatus(row.id,row.recommendStatus);
      },
      handleDelete(index,row){
        this.deleteSubject(row.id);
      },
      handleBatchOperate(){
        if (this.multipleSelection < 1) {
          this.$message({
            message: $t('language.selectRecord'),
            type: 'warning',
            duration: 1000
          });
          return;
        }
        let ids = [];
        for (let i = 0; i < this.multipleSelection.length; i++) {
          ids.push(this.multipleSelection[i].id);
        }
        if (this.operateType === 0) {
          //设为推荐
          this.updateRecommendStatusStatus(ids,1);
        } else if (this.operateType === 1) {
          //取消推荐
          this.updateRecommendStatusStatus(ids,0);
        } else if(this.operateType===2){
          //删除
          this.deleteSubject(ids);
        }else {
          this.$message({
            message: $t('language.selectOperationTypes'),
            type: 'warning',
            duration: 1000
          });
        }
      },
      handleSelectSubject(){
        this.selectDialogVisible=true;
        this.dialogData.listQuery.keyword=null;
        this.getDialogList();
      },
      handleSelectSearch(){
        this.getDialogList();
      },
      handleDialogSizeChange(val) {
        this.dialogData.listQuery.pageNum = 1;
        this.dialogData.listQuery.pageSize = val;
        this.getDialogList();
      },
      handleDialogCurrentChange(val) {
        this.dialogData.listQuery.pageNum = val;
        this.getDialogList();
      },
      handleDialogSelectionChange(val){
        this.dialogData.multipleSelection = val;
      },
      handleSelectDialogConfirm(){
        if (this.dialogData.multipleSelection < 1) {
          this.$message({
            message: $t('language.selectRecord'),
            type: 'warning',
            duration: 1000
          });
          return;
        }
        let selectSubjects = [];
        for (let i = 0; i < this.dialogData.multipleSelection.length; i++) {
          selectSubjects.push({
            subjectId:this.dialogData.multipleSelection[i].id,
            subjectName:this.dialogData.multipleSelection[i].title
          });
        }
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          createHomeSubject(selectSubjects).then(response=>{
            this.selectDialogVisible=false;
            this.dialogData.multipleSelection=[];
            this.getList();
            this.$message({
              type: 'success',
              message: $t('language.modificationSuccess'),
            });
          });
        });
      },
      handleEditSort(index,row){
        this.sortDialogVisible=true;
        this.sortDialogData.sort=row.sort;
        this.sortDialogData.id=row.id;
      },
      handleUpdateSort(){
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          updateHomeSubjectSort(this.sortDialogData).then(response=>{
            this.sortDialogVisible=false;
            this.getList();
            this.$message({
              type: 'success',
              message: $t('language.deleteSuccess')
            });
          });
        })
      },
      getList() {
        this.listLoading = true;
        fetchList(this.listQuery).then(response => {
          this.listLoading = false;
          this.list = response.data.list;
          this.total = response.data.total;
        })
      },
      updateRecommendStatusStatus(ids,status){
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          let params=new URLSearchParams();
          params.append("ids",ids);
          params.append("recommendStatus",status);
          updateRecommendStatus(params).then(response=>{
            this.getList();
            this.$message({
              type: 'success',
              message: $t('language.modificationSuccess'),
            });
          });
        }).catch(() => {
          this.$message({
            type: 'success',
            message: $t('language.cancelModification'),
          });
          this.getList();
        });
      },
      deleteSubject(ids){
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          let params=new URLSearchParams();
          params.append("ids",ids);
          deleteHomeSubject(params).then(response=>{
            this.getList();
            this.$message({
              type: 'success',
              message: $t('language.deleteSuccess')
            });
          });
        })
      },
      getDialogList(){
        fetchSubjectList(this.dialogData.listQuery).then(response=>{
          this.dialogData.list=response.data.list;
          this.dialogData.total=response.data.total;
        })
      }
    }
  }
</script>
<style></style>
