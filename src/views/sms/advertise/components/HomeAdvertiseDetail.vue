<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="homeAdvertise"
             :rules="rules"
             ref="homeAdvertiseFrom"
             label-width="150px"
             size="small">
      <el-form-item :label="$t('language.adName')" prop="name">
        <el-input v-model="homeAdvertise.name" class="input-width"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.adLocation')">
        <el-select v-model="homeAdvertise.type">
          <el-option
            v-for="type in typeOptions"
            :key="type.value"
            :label="type.label"
            :value="type.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item :label="$t('language.startTime')" prop="startTime">
        <el-date-picker
          type="datetime"
          :placeholder="$t('language.selectTime')"
          v-model="homeAdvertise.startTime"></el-date-picker>
      </el-form-item>
      <el-form-item :label="$t('language.endTime')" prop="endTime">
        <el-date-picker
          type="datetime"
          :placeholder="$t('language.selectTime')"
          v-model="homeAdvertise.endTime"></el-date-picker>
      </el-form-item>
      <el-form-item :label="$t('language.onOffline')">
        <el-radio-group v-model="homeAdvertise.status">
          <el-radio :label="0">{{$t("language.offline")}}</el-radio>
          <el-radio :label="1">{{$t("language.online")}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.adPic')">
        <single-upload v-model="homeAdvertise.pic"></single-upload>
      </el-form-item>
      <el-form-item :label="$t('language.sorting')">
        <el-input v-model="homeAdvertise.sort" class="input-width"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.adUrl')" prop="url">
        <el-input v-model="homeAdvertise.url" class="input-width"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.adRemarks')">
        <el-input
          class="input-width"
          type="textarea"
          :rows="5"
          :placeholder="$t('language.enterContent')"
          v-model="homeAdvertise.note">
        </el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('homeAdvertiseFrom')">{{$t("language.submit")}}</el-button>
        <el-button v-if="!isEdit" @click="resetForm('homeAdvertiseFrom')">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>
<script>
  import SingleUpload from '@/components/Upload/singleUpload'
  import {createHomeAdvertise, getHomeAdvertise, updateHomeAdvertise} from '@/api/homeAdvertise'
  import { translate as $t } from "../../../../i18n/index.js"
  const defaultTypeOptions = [
    {
      label: $t('language.pcCarousel'),
      value: 0
    },
    {
      label: $t('language.appCarousel'),
      value: 1
    }
  ];
  const defaultHomeAdvertise = {
    name: null,
    type: 1,
    pic: null,
    startTime: null,
    endTime: null,
    status: 0,
    url: null,
    note: null,
    sort: 0
  };
  export default {
    name: 'HomeAdvertiseDetail',
    components:{SingleUpload},
    props: {
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        homeAdvertise: null,
        rules: {
          name: [
            {required: true, message: $t('language.inputAdName'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.inputAdNameLength'), trigger: 'blur'}
          ],
          url: [
            {required: true, message: $t('language.inputAdUrl'), trigger: 'blur'}
          ],
          startTime: [
            {required: true, message: $t('language.inputAdStart'), trigger: 'blur'}
          ],
          endTime: [
            {required: true, message: $t('language.inputAdEnd'), trigger: 'blur'}
          ],
          pic: [
            {required: true, message: $t('language.inputAdPic'), trigger: 'blur'}
          ]
        },
        typeOptions: Object.assign({}, defaultTypeOptions)
      }
    },
    created(){
      if (this.isEdit) {
        getHomeAdvertise(this.$route.query.id).then(response => {
          this.homeAdvertise = response.data;
        });
      }else{
        this.homeAdvertise = Object.assign({},defaultHomeAdvertise);
      }
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
              if (this.isEdit) {
                updateHomeAdvertise(this.$route.query.id, this.homeAdvertise).then(response => {
                  this.$refs[formName].resetFields();
                  this.$message({
                    message: $t('language.modificationSuccess'),
                    type: 'success',
                    duration:1000
                  });
                  this.$router.back();
                });
              } else {
                createHomeAdvertise(this.homeAdvertise).then(response => {
                  this.$refs[formName].resetFields();
                  this.homeAdvertise = Object.assign({},defaultHomeAdvertise);
                  this.$message({
                    message: $t('language.submittedSuccessfully'),
                    type: 'success',
                    duration:1000
                  });
                });
              }
            });

          } else {
            this.$message({
              message: $t('language.validationFailed'),
              type: 'error',
              duration:1000
            });
            return false;
          }
        });
      },
      resetForm(formName) {
        this.$refs[formName].resetFields();
        this.homeAdvertise = Object.assign({},defaultHomeAdvertise);
      }
    }
  }
</script>
<style scoped>
  .input-width {
    width: 70%;
  }
</style>


