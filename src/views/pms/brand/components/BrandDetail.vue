<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="brand" :rules="rules" ref="brandFrom" label-width="150px">
      <el-form-item :label="$t('language.brandName')+'：'" prop="name">
        <el-input v-model="brand.name"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.brandInitials')+'：'">
        <el-input v-model="brand.firstLetter"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.brandLOGO')+'：'" prop="logo">
        <single-upload v-model="brand.logo"></single-upload>
      </el-form-item>
      <el-form-item :label="$t('language.brandBigPicture')+'：'">
        <single-upload v-model="brand.bigPic"></single-upload>
      </el-form-item>
      <el-form-item :label="$t('language.brandStory')+'：'">
        <el-input
          :placeholder="$t('language.enterContent')"
          type="textarea"
          v-model="brand.brandStory"
          :autosize="true"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.sorting')+'：'" prop="sort">
        <el-input v-model.number="brand.sort"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.isDisplay')+'：'">
        <el-radio-group v-model="brand.showStatus">
          <el-radio :label="1">{{$t('language.yes')}}</el-radio>
          <el-radio :label="0">{{$t('language.no')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.brandManufacturer')+'：'">
        <el-radio-group v-model="brand.factoryStatus">
          <el-radio :label="1">{{$t('language.yes')}}</el-radio>
          <el-radio :label="0">{{$t('language.no')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('brandFrom')">{{$t('language.submit')}}</el-button>
        <el-button v-if="!isEdit" @click="resetForm('brandFrom')">{{$t('language.reset')}}</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>
<script>
  import {createBrand, getBrand, updateBrand} from '@/api/brand'
  import SingleUpload from '@/components/Upload/singleUpload'
  import { translate as $t } from "@/i18n/index.js"
  const defaultBrand={
    bigPic: '',
    brandStory: '',
    factoryStatus: 0,
    firstLetter: '',
    logo: '',
    name: '',
    showStatus: 0,
    sort: 0
  };
  export default {
    name: 'BrandDetail',
    components:{SingleUpload},
    props: {
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        brand:Object.assign({}, defaultBrand),
        rules: {
          name: [
            {required: true, message: $t('language.enterBrand'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.charLength'), trigger: 'blur'}
          ],
          logo: [
            {required: true, message: $t('language.enterBrandLogo'), trigger: 'blur'}
          ],
          sort: [
            {type: 'number', message: $t('language.orderMustNumeric')}
          ],
        }
      }
    },
    created() {
      if (this.isEdit) {
        getBrand(this.$route.query.id).then(response => {
          this.brand = response.data;
        });
      }else{
        this.brand = Object.assign({},defaultBrand);
      }
    },
    methods: {
      onSubmit(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$confirm($t('language.whetherSubmit'), $t('language.tips'), {
              confirmButtonText: $t('language.confirm'),
              cancelButtonText: $t('language.cancel'),
              type: 'warning'
            }).then(() => {
              if (this.isEdit) {
                updateBrand(this.$route.query.id, this.brand).then(response => {
                  this.$refs[formName].resetFields();
                  this.$message({
                    message: $t('language.modificationSucceeded'),
                    type: 'success',
                    duration:1000
                  });
                  this.$router.back();
                });
              } else {
                createBrand(this.brand).then(response => {
                  this.$refs[formName].resetFields();
                  this.brand = Object.assign({},defaultBrand);
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
        this.brand = Object.assign({},defaultBrand);
      }
    }
  }
</script>
<style>
</style>


