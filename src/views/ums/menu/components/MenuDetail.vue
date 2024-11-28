<template>
  <el-card class="form-container" shadow="never">
    <el-form :model="menu"
             :rules="rules"
             ref="menuFrom"
             label-width="150px">
      <el-form-item :label="$t('language.menuName')" prop="title">
        <el-input v-model="menu.title"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.upperMenu')">
        <el-select v-model="menu.parentId"
                   :placeholder="$t('language.selectMenu')">
          <el-option
            v-for="item in selectMenuList"
            :key="item.id"
            :label="item.title"
            :value="item.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item :label="$t('language.frontendName')" prop="name">
        <el-input v-model="menu.name"></el-input>
      </el-form-item>
      <el-form-item :label="$t('language.frontendPic')" prop="icon">
        <el-input v-model="menu.icon" style="width: 80%"></el-input>
        <svg-icon style="margin-left: 8px" :icon-class="menu.icon"></svg-icon>
      </el-form-item>
      <el-form-item :label="$t('language.isDisplay')">
        <el-radio-group v-model="menu.hidden">
          <el-radio :label="0">{{$t("language.yes")}}</el-radio>
          <el-radio :label="1">{{$t("language.no")}}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('language.sorting')">
        <el-input v-model="menu.sort"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('menuFrom')">{{$t("language.submit")}}</el-button>
        <el-button v-if="!isEdit" @click="resetForm('menuFrom')">{{$t("language.reset")}}</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script>
  import {fetchList, createMenu, updateMenu, getMenu} from '@/api/menu';
  import { translate as $t } from "../../../../i18n/index.js"
  const defaultMenu = {
    title: '',
    parentId: 0,
    name: '',
    icon: '',
    hidden: 0,
    sort: 0
  };
  export default {
    name: "MenuDetail",
    props: {
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        menu: Object.assign({}, defaultMenu),
        selectMenuList: [],
        rules: {
          title: [
            {required: true, message: $t('language.inputMenuName'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.charLength'), trigger: 'blur'}
          ],
          name: [
            {required: true, message: $t('language.inputFrontendName'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.charLength'), trigger: 'blur'}
          ],
          icon: [
            {required: true, message: $t('language.inputFrontendPic'), trigger: 'blur'},
            {min: 2, max: 140, message: $t('language.charLength'), trigger: 'blur'}
          ]
        }
      }
    },
    created() {
      if (this.isEdit) {
        getMenu(this.$route.query.id).then(response => {
          this.menu = response.data;
        });
      } else {
        this.menu = Object.assign({}, defaultMenu);
      }
      this.getSelectMenuList();
    },
    methods: {
      getSelectMenuList() {
        fetchList(0, {pageSize: 100, pageNum: 1}).then(response => {
          this.selectMenuList = response.data.list;
          this.selectMenuList.unshift({id: 0, title: $t('language.noUpperMenu')});
        });
      },
      onSubmit(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$confirm($t('language.isConfirm'), $t('language.tips'), {
              confirmButtonText: $t('language.determined'),
              cancelButtonText: $t('language.cancle'),
              type: 'warning'
            }).then(() => {
              if (this.isEdit) {
                updateMenu(this.$route.query.id, this.menu).then(response => {
                  this.$message({
                    message: $t('language.modificationSuccess'),
                    type: 'success',
                    duration: 1000
                  });
                  this.$router.back();
                });
              } else {
                createMenu(this.menu).then(response => {
                  this.$refs[formName].resetFields();
                  this.resetForm(formName);
                  this.$message({
                    message: $t('language.submittedSuccessfully'),
                    type: 'success',
                    duration: 1000
                  });
                  this.$router.back();
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
        this.menu = Object.assign({}, defaultMenu);
        this.getSelectMenuList();
      },
    }
  }
</script>

<style scoped>

</style>
