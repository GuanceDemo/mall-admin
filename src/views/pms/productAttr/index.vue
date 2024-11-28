<template> 
  <div class="app-container">
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets" style="margin-top: 5px"></i>
      <span style="margin-top: 5px">{{$t('language.dataList')}}</span>
      <el-button
        class="btn-add"
        @click="addProductAttrCate()"
        size="mini">
        {{$t('language.add')}}
      </el-button>
    </el-card>
    <div class="table-container">
      <el-table ref="productAttrCateTable"
                style="width: 100%"
                :data="list"
                v-loading="listLoading"
                border>
        <el-table-column :label="$t('language.numberCode')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.typeName')" align="center">
          <template slot-scope="scope">{{scope.row.name}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.numberAttributes')" width="200" align="center">
          <template slot-scope="scope">{{scope.row.attributeCount==null?0:scope.row.attributeCount}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.numberParameters')" width="200" align="center">
          <template slot-scope="scope">{{scope.row.paramCount==null?0:scope.row.paramCount}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.setting')" width="200" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="getAttrList(scope.$index, scope.row)">{{$t('language.attributeList')}}
            </el-button>
            <el-button
              size="mini"
              @click="getParamList(scope.$index, scope.row)">{{$t('language.listParameters')}}
            </el-button>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="200" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="handleUpdate(scope.$index, scope.row)">{{$t('language.edit')}}
            </el-button>
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.$index, scope.row)">{{$t('language.delete')}}
            </el-button>
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
        :page-size="listQuery.pageSize"
        :page-sizes="[5,10,15]"
        :current-page.sync="listQuery.pageNum"
        :total="total">
      </el-pagination>
    </div>
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      :before-close="handleClose()"
      width="30%">
      <el-form ref="productAttrCatForm" :model="productAttrCate" :rules="rules" label-width="120px">
        <el-form-item :label="$t('language.typeName')" prop="name">
          <el-input v-model="productAttrCate.name" auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">{{$t('language.cancle')}}</el-button>
        <el-button type="primary" @click="handleConfirm('productAttrCatForm')">{{$t('language.determined')}}</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
  import {fetchList,createProductAttrCate,deleteProductAttrCate,updateProductAttrCate} from '@/api/productAttrCate'
  import { translate as $t } from "@/i18n/index.js"

  export default {
    name: 'productAttrCateList',
    data() {
      return {
        list: null,
        total: null,
        listLoading: true,
        listQuery: {
          pageNum: 1,
          pageSize: 5
        },
        dialogVisible: false,
        dialogTitle:'',
        productAttrCate:{
          name:'',
          id:null
        },
        rules: {
          name: [
            { required: true, message: $t('language.enterType'), trigger: 'blur' }
          ]
        }
      }
    },
    created() {
      this.getList();
    },
    methods: {
      getList() {
        this.listLoading = true;
        fetchList(this.listQuery).then(response => {
          this.listLoading = false;
          this.list = response.data.list;
          this.total = response.data.total;
        });
      },
      addProductAttrCate() {
        this.dialogVisible = true;
        this.dialogTitle = $t('language.additionType');
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
      handleDelete(index, row) {
        this.$confirm($t('language.deleteText'), $t('language.tips'), {
          confirmButtonText: $t('language.confirm'),
          cancelButtonText: $t('language.cancel'),
          type: 'warning'
        }).then(() => {
          deleteProductAttrCate(row.id).then(response=>{
            this.$message({
              message: $t('language.deleteSuccess'),
              type: 'success',
              duration:1000
            });
            this.getList();
          });
        });
      },
      handleUpdate(index, row) {
        this.dialogVisible = true;
        this.dialogTitle = $t('language.editType');
        this.productAttrCate.name = row.name;
        this.productAttrCate.id = row.id;
      },
      getAttrList(index, row) {
        this.$router.push({path: '/pms/productAttrList',query:{cid:row.id,cname:row.name,type:0}})
      },
      getParamList(index, row) {
        this.$router.push({path: '/pms/productAttrList',query:{cid:row.id,cname:row.name,type:1}})
      },
      handleConfirm(formName){
        this.$refs[formName].validate((valid) => {
          if (valid) {
            let data = new URLSearchParams();
            data.append("name",this.productAttrCate.name);
            if(this.dialogTitle===$t('language.additionType')){
              createProductAttrCate(data).then(response=>{
                this.$message({
                  message: $t('language.addSuccess'),
                  type: 'success',
                  duration:1000
                });
                this.dialogVisible = false;
                this.getList();
              });
            }else{
              updateProductAttrCate(this.productAttrCate.id,data).then(response=>{
                this.$message({
                  message: $t('language.modificationSucceeded'),
                  type: 'success',
                  duration:1000
                });
                this.dialogVisible = false;
                this.getList();
              });
            }
          } else {
            console.log('error submit!!');
            return false;
          }
        });
      },
      handleClose(){
        if (!this.dialogVisible && this.$refs.productAttrCatForm) {
          this.$refs.productAttrCatForm.clearValidate()
        }
      }
    }
  }
</script>
<style rel="stylesheet/scss" lang="scss" scoped>
</style>


