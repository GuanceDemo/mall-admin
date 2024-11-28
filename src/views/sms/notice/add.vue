<template> 
  <home-notice-detail :isEdit="false"></home-notice-detail>
</template>
<script>
  import HomeNoticeDetail from './components/HomeNoticeDetail.vue'
  export default {
    name: 'addHomeNotice',
    components: { HomeNoticeDetail }
  }
</script>
<style></style>
