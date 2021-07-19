<template>
  <a :href="href" class="block card shadow-lg m-4 inline-block hover:shadow-xl">
    <div class="preview">
      <font-awesome-icon v-if="youtube" class="play-icon" icon="play" />
      <img :src="imageSrc" class="w-full object-cover">
    </div>
    <div class="w-full p-2">
      <span class="title block font-bold text-2xl">{{ title }}</span>
      <span class="desc block text-opacity-75">{{ desc }}</span>
    </div>
  </a>
</template>
<script>
/* eslint-disable vue/require-default-prop */
export default {
  name: 'Card',
  props: {
    image: String,
    title: String,
    desc: String,
    youtube: String,
    url: String
  },
  data () {
    return {
    }
  },
  computed: {
    imageSrc () {
      if (this.image) {
        return this.image.startsWith('@/') ? require('~/assets/cards/' + this.image.replace('@/', '')) : this.image
      } else if (this.youtube) {
        return 'https://i3.ytimg.com/vi/' + this.youtube + '/hqdefault.jpg'
      }
      return ''
    },
    href () {
      if (this.url) {
        return this.url
      } else if (this.youtube) {
        return 'https://www.youtube.com/watch?v=' + this.youtube
      }
      return ''
    }
  },
  methods: {}
}
</script>
<style>
.card {
  width: 24rem;
  height: 19rem;
  white-space: normal;
  vertical-align: middle;
  cursor: pointer;
  background: white;
  color: unset !important;
  text-decoration: none !important;
}
.card > .preview {
  height: 12rem;
  border-bottom: 1px solid #eee;
  overflow: hidden;
  position: relative;
}
.card > .preview > img {
  height: 12rem;
}
.card:hover > .preview > img {
  transform: scale(1.07);
  transition: transform 0.3s;
}
.card > .preview > .play-icon {
  font-size: 4rem;
  color: #eeeeeeb0;
  user-select: none;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 2;
}
@media (max-width: 400px) {
  .card {
    width: 15rem;
    height: 20rem;
  }
}

.object-cover {
    object-fit: contain !important;
}
</style>
