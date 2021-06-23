<template>
  <div>
    <img :src="imgSrc">
  </div>
</template>
<script>
/* eslint-disable vue/require-default-prop */
export default {
  name: 'ContentImg',
  props: {
    img: String
  },
  computed: {
    imgSrc () {
      return require('~/assets/' + this.img)
    }
  }
}
</script>
<style>
</style>
