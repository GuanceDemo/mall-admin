<template> 
  <div class="app-container">
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets"></i>
      <span>{{$t("language.dataList")}}</span>
      <el-button size="mini" class="btn-add" @click="handleAdd()">{{$t("language.addNotice")}}</el-button>
    </el-card>
    <div class="table-container">
      <el-table ref="homeNoticeTable"
                :data="list"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                v-loading="listLoading" border>
        <el-table-column :label="$t('language.numbering')" width="120" align="center">
          <template slot-scope="scope">{{ scope.row.id }}</template>
        </el-table-column>
        <el-table-column :label="$t('language.noticeTitle')" align="center">
          <template slot-scope="scope">{{ scope.row.title }}</template>
        </el-table-column>
        <el-table-column :label="$t('language.noticeIntroduce')" align="center">
          <template slot-scope="scope">{{ scope.row.introduce }}</template>
        </el-table-column>
        <el-table-column :label="$t('language.noticeContent')" align="center">
          <template slot-scope="scope">{{ scope.row.content }}</template>
        </el-table-column>
        <el-table-column :label="$t('language.noticePic')" width="120" align="center">
          <template slot-scope="scope"><img style="height: 80px" :src="scope.row.pic"></template>
        </el-table-column>
        <el-table-column :label="$t('language.time')" width="220" align="center">
          <template slot-scope="scope">
            <p>{{$t("language.startTime")}} {{ scope.row.start }}</p>
            <p>{{$t("language.endTime")}} {{ scope.row.finish }}</p>
          </template>
        </el-table-column>
        <el-table-column :label="$t('language.action')" width="120" align="center">
          <template slot-scope="scope">
            <el-button size="mini"
                       type="text"
                       @click="handleDelete(scope.$index, scope.row)">{{$t("language.delete")}}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>
<script>
import {fetchList, deleteNotice} from '@/api/notice';
import {translate as $t} from "../../../i18n";
export default {
  name: 'homeNotice',
  data() {
    return {
      list: null,
    }
  },
  created() {
    this.getList();
  },
  methods: {
    handleDelete(index, row) {
      this.deleteHomeNotice(row.id);
    },
    handleAdd() {
      this.$router.push({path: '/sms/addHomeNotice'})
    },
    getList() {
      let params = new URLSearchParams();
      params.append('ids', []);
      fetchList(params).then(response => {
        this.list = response.data;
      })
    },
    deleteHomeNotice(id) {
      this.$confirm($t('language.isConfirm'), $t('language.tips'), {
        confirmButtonText: $t('language.determined'),
        cancelButtonText: $t('language.cancle'),
        type: 'warning'
      }).then(() => {
        let params = new URLSearchParams();
        params.append("id", id);
        deleteNotice(params).then(response => {
          this.getList();
          this.$message({
            type: 'success',
            message: $t('language.deleteSuccess')
          });
        });
      })
    }
  }
}
</script>
<style scoped>
.input-width {
  width: 203px;
}
</style>


