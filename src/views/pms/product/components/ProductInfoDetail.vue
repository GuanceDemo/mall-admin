<template>
  <div style="margin-top: 50px">
    <el-form :model="value" :rules="rules" ref="productInfoForm" label-width="120px" class="form-inner-container" size="small">
      <el-form-item :label="$t('language.productCategory')+'：'" prop="productCategoryId">
        <el-cascader
          v-model="selectProductCateValue"
          :options="productCateOptions">
        </el-cascader>
      </el-form-item>
      <el-form-item :label="$t('language.productName')+'：'" prop="name">
        <el-input v-model="value.name"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.subtitle')+'：'" prop="subTitle">
        <el-input v-model="value.subTitle"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.productBrand')+'：'" prop="brandId">
        <el-select
          v-model="value.brandId"
          @change="handleBrandChange"
          :placeholder="$t('language.selectBrand')">
          <el-option
            v-for="item in brandOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item :label="$t('language.productIntroduction')+'：'">
        <el-input
          :autoSize="true"
          v-model="value.description"
          type="textarea"
          :placeholder="$t('language.enterContent')"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.productNo')+'：'">
        <el-input v-model="value.productSn"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.productPrice')+'：'">
        <el-input v-model="value.price"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.marketPrice')+'：'">
        <el-input v-model="value.originalPrice"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.merchandiseInventory')+'：'">
        <el-input v-model="value.stock"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.unitsMeasurement')+'：'">
        <el-input v-model="value.unit"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.productWeight')+'：'">
        <el-input v-model="value.weight" style="width: 300px"></el-input>
        <span style="margin-left: 20px">{{$t('language.gram')}}</span>
      </el-form-item>
      <el-form-item :label="$t('language.sorting')">
        <el-input v-model="value.sort"></el-input>
      </el-form-item>
      <el-form-item style="text-align: center">
        <el-button type="primary" size="medium" @click="handleNext('productInfoForm')">{{$t('language.nextPromotion')}}</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import {fetchListWithChildren} from '@/api/productCate'
  import {fetchList as fetchBrandList} from '@/api/brand'
  import {getProduct} from '@/api/product';
  import { translate as $t } from "@/i18n/index.js"

  export default {
    name: "ProductInfoDetail",
    props: {
      value: Object,
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        hasEditCreated:false,
        //选中商品分类的值
        selectProductCateValue: [],
        productCateOptions: [],
        brandOptions: [],
        rules: {
          name: [
            {required: true, message: $t('language.enterProductName'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.charLength'), trigger: 'blur'}
          ],
          subTitle: [{required: true, message: $t('language.enterProductSubtitle'), trigger: 'blur'}],
          productCategoryId: [{required: true, message: $t('language.selectProductSategory'), trigger: 'blur'}],
          brandId: [{required: true, message: $t('language.selectProductBrand'), trigger: 'blur'}],
          description: [{required: true, message: $t('language.enterProductDescription'), trigger: 'blur'}],
          requiredProp: [{required: true, message: $t('language.itemMandatory'), trigger: 'blur'}]
        }
      };
    },
    created() {
      this.getProductCateList();
      this.getBrandList();
    },
    computed:{
      //商品的编号
      productId(){
        return this.value.id;
      }
    },
    watch: {
      productId:function(newValue){
        if(!this.isEdit)return;
        if(this.hasEditCreated)return;
        if(newValue===undefined||newValue==null||newValue===0)return;
        this.handleEditCreated();
      },
      selectProductCateValue: function (newValue) {
        if (newValue != null && newValue.length === 2) {
          this.value.productCategoryId = newValue[1];
          this.value.productCategoryName= this.getCateNameById(this.value.productCategoryId);
        } else {
          this.value.productCategoryId = null;
          this.value.productCategoryName=null;
        }
      }
    },
    methods: {
      //处理编辑逻辑
      handleEditCreated(){
        if(this.value.productCategoryId!=null){
          this.selectProductCateValue.push(this.value.cateParentId);
          this.selectProductCateValue.push(this.value.productCategoryId);
        }
        this.hasEditCreated=true;
      },
      getProductCateList() {
        fetchListWithChildren().then(response => {
          let list = response.data;
          this.productCateOptions = [];
          for (let i = 0; i < list.length; i++) {
            let children = [];
            if (list[i].children != null && list[i].children.length > 0) {
              for (let j = 0; j < list[i].children.length; j++) {
                children.push({label: list[i].children[j].name, value: list[i].children[j].id});
              }
            }
            this.productCateOptions.push({label: list[i].name, value: list[i].id, children: children});
          }
        });
      },
      getBrandList() {
        fetchBrandList({pageNum: 1, pageSize: 100}).then(response => {
          this.brandOptions = [];
          let brandList = response.data.list;
          for (let i = 0; i < brandList.length; i++) {
            this.brandOptions.push({label: brandList[i].name, value: brandList[i].id});
          }
        });
      },
      getCateNameById(id){
        let name=null;
        for(let i=0;i<this.productCateOptions.length;i++){
          for(let j=0;j<this.productCateOptions[i].children.length;j++){
            if(this.productCateOptions[i].children[j].value===id){
              name=this.productCateOptions[i].children[j].label;
              return name;
            }
          }
        }
        return name;
      },
      handleNext(formName){
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$emit('nextStep');
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
      handleBrandChange(val) {
        let brandName = '';
        for (let i = 0; i < this.brandOptions.length; i++) {
          if (this.brandOptions[i].value === val) {
            brandName = this.brandOptions[i].label;
            break;
          }
        }
        this.value.brandName = brandName;
      }
    }
  }
</script>

<style scoped>
</style>
