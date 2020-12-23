<template>
  <div class="content-page">
    Title: {{ page.title }}
    [TODO] Header
    <nuxt-content :document="page" />
  </div>
</template>
<script>
export default {
  async asyncData ({ params, $content }) {
    const id = params.id
    const page = await $content(id).fetch()
    return { id, page }
  },
  data () {
    return {
    }
  },
  computed: {},
  methods: {}
}
</script>
<style>
.content-page {
  background: #f5f5f5;
}
.content-page h1 {
  font-size: 2rem;
  padding: 1.5rem 0 0rem 2rem;
}
</style>
