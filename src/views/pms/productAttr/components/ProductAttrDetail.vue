<template>
  <el-card class="form-container" shadow="never">
    <el-form :model="productAttr" :rules="rules" ref="productAttrFrom" label-width="150px">
      <el-form-item :label="$t('language.attributeName')" prop="name">
        <el-input v-model="productAttr.name"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.productType')">
        <el-select v-model="productAttr.productAttributeCategoryId" :placeholder="$t('language.pleaseSelect')">
          <el-option
            v-for="item in productAttrCateList"
            :key="item.id"
            :label="item.name"
            :value="item.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item :label="$t('language.categoryFilterStyle')">
        <el-radio-group v-model="productAttr.filterType">
          <el-radio :label="0">{{$t('language.ordinary')}}</el-radio>
          <el-radio :label="1">{{$t('language.color')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.canSearched')">
        <el-radio-group v-model="productAttr.searchType">
          <el-radio :label="0">{{$t('language.search1')}}</el-radio>
          <el-radio :label="1">{{$t('language.search2')}}</el-radio>
          <el-radio :label="2">{{$t('language.search3')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.offeringAssociation')">
        <el-radio-group v-model="productAttr.relatedStatus">
          <el-radio :label="1">{{$t('language.yes')}}</el-radio>
          <el-radio :label="0">{{$t('language.no')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.isOptional')">
        <el-radio-group v-model="productAttr.selectType">
          <el-radio :label="0">{{$t('language.choose3')}}</el-radio>
          <el-radio :label="1">{{$t('language.choose1')}}</el-radio>
          <el-radio :label="2">{{$t('language.choose2')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.attributeRecordingMethod')">
        <el-radio-group v-model="productAttr.inputType">
          <el-radio :label="0">{{$t('language.manualInput')}}</el-radio>
          <el-radio :label="1">{{$t('language.pickList')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.availableAttributeList')">
        <el-input :autosize="true" type="textarea" v-model="inputListFormat"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.supportAddition')">
        <el-radio-group v-model="productAttr.handAddStatus">
          <el-radio :label="1">{{$t('language.yes')}}</el-radio>
          <el-radio :label="0">{{$t('language.no')}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.sortingAttributes')">
        <el-input v-model="productAttr.sort"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('productAttrFrom')">{{$t('language.submit')}}</el-button>
        <el-button  v-if="!isEdit" @click="resetForm('productAttrFrom')">{{$t('language.reset')}}</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script>
  import {fetchList} from '@/api/productAttrCate'
  import {createProductAttr,getProductAttr,updateProductAttr} from '@/api/productAttr'
  import { translate as $t } from "@/i18n/index.js"

  const defaultProductAttr = {
    filterType: 0,
    handAddStatus: 0,
    inputList: '',
    inputType: 0,
    name: '',
    productAttributeCategoryId: 0,
    relatedStatus: 0,
    searchType: 0,
    selectType: 0,
    sort: 0,
    type: 0
  };
  export default {
    name: "ProductAttrDetail",
    props: {
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        productAttr: Object.assign({}, defaultProductAttr),
        rules: {
          name: [
            {required: true, message: $t('language.enterAttributeName'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.charLength'), trigger: 'blur'}
          ]
        },
        productAttrCateList: null,
        inputListFormat:null
      }
    },
    created() {
      if(this.isEdit){
        getProductAttr(this.$route.query.id).then(response => {
          this.productAttr = response.data;
          this.inputListFormat = this.productAttr.inputList.replace(/,/g,'\n');
        });
      }else{
        this.resetProductAttr();
      }
      this.getCateList();
    },
    watch:{
      inputListFormat: function (newValue, oldValue) {
        newValue = newValue.replace(/\n/g,',');
        this.productAttr.inputList = newValue;
      }
    },
    methods: {
      getCateList() {
        let listQuery = {pageNum: 1, pageSize: 100};
        fetchList(listQuery).then(response => {
          this.productAttrCateList = response.data.list;
        });
      },
      resetProductAttr() {
        this.productAttr = Object.assign({}, defaultProductAttr);
        this.productAttr.productAttributeCategoryId = Number(this.$route.query.cid);
        this.productAttr.type = Number(this.$route.query.type);
      },
      onSubmit(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$confirm($t('language.whetherSubmit'), $t('language.tips'), {
              confirmButtonText: $t('language.confirm'),
              cancelButtonText: $t('language.cancel'),
              type: 'warning'
            }).then(() => {
              if(this.isEdit){
                updateProductAttr(this.$route.query.id,this.productAttr).then(response=>{
                  this.$message({
                    message: $t('language.modificationSuccess'),
                    type: 'success',
                    duration: 1000
                  });
                  this.$router.back();
                });
              }else{
                createProductAttr(this.productAttr).then(response=>{
                  this.$message({
                    message: $t('language.submittedSuccessfully'),
                    type: 'success',
                    duration: 1000
                  });
                  this.resetForm('productAttrFrom');
                });
              }
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
        this.resetProductAttr();
      }
    },
  }
</script>

<style scoped>

</style>
