<template> 
  <div class="app-container">
    <el-card shadow="never" class="operate-container">
      <i class="el-icon-tickets"></i>
      <span>{{$t("language.dataList")}}</span>
      <el-button size="mini" class="btn-add" @click="handleAdd()">{{$t("language.add")}}</el-button>
    </el-card>
    <div class="table-container">
      <el-table ref="resourceCategoryTable"
                :data="list"
                style="width: 100%;"
                v-loading="listLoading" border>
        <el-table-column :label="$t('language.numbering')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.resourceName')" align="center">
          <template slot-scope="scope">{{scope.row.name}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.startTime')" align="center">
          <template slot-scope="scope">{{scope.row.createTime | formatDateTime}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.sorting')" align="center">
          <template slot-scope="scope">{{scope.row.sort}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="180" align="center">
          <template slot-scope="scope">
            <el-button size="mini"
                       type="text"
                       @click="handleUpdate(scope.$index, scope.row)">{{$t("language.edit")}}
            </el-button>
            <el-button size="mini"
                       type="text"
                       @click="handleDelete(scope.$index, scope.row)">{{$t("language.delete")}}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <el-dialog
      :title="$t('language.addCategory')"
      :visible.sync="dialogVisible"
      width="40%">
      <el-form :model="resourceCategory"
               ref="resourceCategoryForm"
               label-width="150px" size="small">
        <el-form-item :label="$t('language.resourceName')">
          <el-input v-model="resourceCategory.name" style="width: 250px"></el-input>
        </el-form-item>
        <el-form-item :label="$t('language.sorting')">
          <el-input v-model="resourceCategory.sort" style="width: 250px"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false" size="small">{{$t("language.cancle")}}</el-button>
        <el-button type="primary" @click="handleDialogConfirm()" size="small">{{$t("language.confirm")}}</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
  import {listAllCate,createResourceCategory,updateResourceCategory,deleteResourceCategory} from '@/api/resourceCategory';
  import {formatDate} from '@/utils/date';
  import {translate as $t} from "../../../i18n";
  const defaultResourceCategory={
    name:null,
    sort:0
  };
  export default {
    name: 'resourceCategoryList',
    data() {
      return {
        list: null,
        listLoading: false,
        dialogVisible:false,
        isEdit:false,
        resourceCategory:Object.assign({},defaultResourceCategory)
      }
    },
    created() {
      this.getList();
    },
    filters:{
      formatDateTime(time) {
        if (time == null || time === '') {
          return 'N/A';
        }
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd hh:mm:ss')
      }
    },
    methods: {
      handleAdd() {
        this.dialogVisible = true;
        this.isEdit = false;
        this.resourceCategory = Object.assign({},defaultResourceCategory);
      },
      handleUpdate(index,row){
        this.dialogVisible = true;
        this.isEdit = true;
        this.resourceCategory = Object.assign({},row);
      },
      handleDelete(index,row){
        this.$confirm($t('language.isDelete'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          deleteResourceCategory(row.id).then(response => {
            this.$message({
              type: 'success',
              message: $t('language.deleteSuccess')
            });
            this.getList();
          });
        });
      },
      handleDialogConfirm() {
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          if (this.isEdit) {
            updateResourceCategory(this.resourceCategory.id,this.resourceCategory).then(response => {
              this.$message({
                message: $t('language.modificationSuccess'),
                type: 'success'
              });
              this.dialogVisible =false;
              this.getList();
            })
          } else {
            createResourceCategory(this.resourceCategory).then(response => {
              this.$message({
                message: $t('language.addSuccess'),
                type: 'success'
              });
              this.dialogVisible =false;
              this.getList();
            })
          }
        })
      },
      getList() {
        this.listLoading = true;
        listAllCate({}).then(response => {
          this.listLoading = false;
          this.list = response.data;
        });
      }
    }
  }
</script>
<style>
</style>


