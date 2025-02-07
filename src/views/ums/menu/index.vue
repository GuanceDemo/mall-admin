<template>
  <div class="app-container">
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets" style="margin-top: 5px"></i>
      <span style="margin-top: 5px">{{$t("language.dataList")}}</span>
      <el-button
        class="btn-add"
        @click="handleAddMenu()"
        size="mini">
        {{$t("language.add")}}
      </el-button>
    </el-card>
    <div class="table-container">
      <el-table ref="menuTable"
                style="width: 100%"
                :data="list"
                v-loading="listLoading" border>
        <el-table-column :label="$t('language.numbering')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.menuName')" align="center">
          <template slot-scope="scope">{{scope.row.title}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.menuLevel')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.level | levelFilter}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.frontendName')" align="center">
          <template slot-scope="scope">{{scope.row.name}}</template>
        </el-table-column>
        <el-table-column :label="$t('language.frontendPic')" width="100" align="center">
          <template slot-scope="scope"><svg-icon :icon-class="scope.row.icon"></svg-icon></template>
        </el-table-column>
        <el-table-column :label="$t('language.isDisplay')" width="100" align="center">
          <template slot-scope="scope">
            <el-switch
              @change="handleHiddenChange(scope.$index, scope.row)"
              :active-value="0"
              :inactive-value="1"
              v-model="scope.row.hidden">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.sorting')" width="100" align="center">
          <template slot-scope="scope">{{scope.row.sort }}</template>
        </el-table-column>
        <el-table-column :label="$t('language.setting')" width="120" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              :disabled="scope.row.level | disableNextLevel"
              @click="handleShowNextLevel(scope.$index, scope.row)">{{$t("language.viewSubordinates")}}
            </el-button>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="200" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              @click="handleUpdate(scope.$index, scope.row)">{{$t("language.edit")}}
            </el-button>
            <el-button
              size="mini"
              type="text"
              @click="handleDelete(scope.$index, scope.row)">{{$t("language.delete")}}
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
        :page-sizes="[10,15,20]"
        :current-page.sync="listQuery.pageNum"
        :total="total">
      </el-pagination>
    </div>
  </div>
</template>

<script>
  import {fetchList,deleteMenu,updateMenu,updateHidden} from '@/api/menu'
  import { translate as $t } from "../../../i18n/index.js"
  export default {
    name: "menuList",
    data() {
      return {
        list: null,
        total: null,
        listLoading: true,
        listQuery: {
          pageNum: 1,
          pageSize: 5
        },
        parentId: 0
      }
    },
    created() {
      this.resetParentId();
      this.getList();
    },
    watch: {
      $route(route) {
        this.resetParentId();
        this.getList();
      }
    },
    methods: {
      resetParentId(){
        this.listQuery.pageNum = 1;
        if (this.$route.query.parentId != null) {
          this.parentId = this.$route.query.parentId;
        } else {
          this.parentId = 0;
        }
      },
      handleAddMenu() {
        this.$router.push('/ums/addMenu');
      },
      getList() {
        this.listLoading = true;
        fetchList(this.parentId, this.listQuery).then(response => {
          this.listLoading = false;
          this.list = response.data.list;
          this.total = response.data.total;
        });
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
      handleHiddenChange(index, row) {
        updateHidden(row.id,{hidden:row.hidden}).then(response=>{
          this.$message({
            message: $t('language.modificationSuccess'),
            type: 'success',
            duration: 1000
          });
        });
      },
      handleShowNextLevel(index, row) {
        this.$router.push({path: '/ums/menu', query: {parentId: row.id}})
      },
      handleUpdate(index, row) {
        this.$router.push({path:'/ums/updateMenu',query:{id:row.id}});
      },
      handleDelete(index, row) {
        this.$confirm($t('language.isConfirm'), $t('language.tips'), {
          confirmButtonText: $t('language.determined'),
          cancelButtonText: $t('language.cancle'),
          type: 'warning'
        }).then(() => {
          deleteMenu(row.id).then(response => {
            this.$message({
              message: $t('language.deleteSuccess'),
              type: 'success',
              duration: 1000
            });
            this.getList();
          });
        });
      }
    },
    filters: {
      levelFilter(value) {
        if (value === 0) {
          return $t('language.level1');
        } else if (value === 1) {
          return $t('language.level2');
        }
      },
      disableNextLevel(value) {
        if (value === 0) {
          return false;
        } else {
          return true;
        }
      }
    }
  }
</script>

<style scoped>

</style>
