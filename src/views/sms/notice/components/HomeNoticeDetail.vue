<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="homeNotice"
             ref="homeNoticeFrom"
             label-width="150px"
             size="small">
      <el-form-item :label="$t('language.noticeTitle')" prop="name">
        <el-input v-model="homeNotice.title" class="input-width"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.noticeIntroduce')" prop="name">
        <el-input v-model="homeNotice.introduce" class="input-width"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.noticeContent')">
        <el-input
            class="input-width"
            type="textarea"
            :rows="5"
            :placeholder="$t('language.enterContent')"
            v-model="homeNotice.content">
        </el-input>
      </el-form-item>
      <el-form-item :label="$t('language.noticePic')">
        <single-upload v-model="homeNotice.pic"></single-upload>
      </el-form-item>
      <el-form-item :label="$t('language.startTime')" prop="startTime">
        <el-date-picker
            type="datetime"
            :placeholder="$t('language.selectTime')"
            v-model="homeNotice.start"></el-date-picker>
      </el-form-item>
      <el-form-item :label="$t('language.endTime')" prop="endTime">
        <el-date-picker
            type="datetime"
            :placeholder="$t('language.selectTime')"
            v-model="homeNotice.finish"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('homeNoticeFrom')">{{$t("language.submit")}}</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>
<script>
import SingleUpload from '@/components/Upload/singleUpload'
import {fetchList, createNotice} from '@/api/notice';
import {translate as $t} from "../../../../i18n";
const defaultHomeNotice = {
  id: null,
  title: null,
  introduce: null,
  content: null,
  start: null,
  finish: null,
  pic: null,
};
export default {
  name: 'HomeNoticeDetail',
  components: {SingleUpload},
  props: {},
  data() {
    return {
      homeNotice: null
    }
  },
  created() {
    this.homeNotice = Object.assign({}, defaultHomeNotice);
  },
  methods: {
    onSubmit(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$confirm($t('language.isConfirm'), $t('language.tips'), {
            confirmButtonText: $t('language.determined'),
            cancelButtonText: $t('language.cancle'),
            type: 'warning'
          }).then(() => {
              createNotice(this.homeNotice).then(response => {
              this.$refs[formName].resetFields();
              this.homeNotice = Object.assign({}, defaultHomeNotice);
              this.$message({
                message: $t('language.submittedSuccessfully'),
                type: 'success',
                duration: 1000
              });
            });
          });
        } else {
          this.$message({
            message: $t('language.validationFailed'),
            type: 'error',
            duration: 1000
          });
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
      this.homeNotice = Object.assign({}, defaultHomeNotice);
    }
  }
}
</script>
<style scoped>
.input-width {
  width: 70%;
}
</style>


