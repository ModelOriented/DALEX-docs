<template>
  <div class="content-page">
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
.content-page h1, .content-page h2, .content-page h3, .content-page h4, .content-page h5, .content-page h6 {
  padding-left: 2rem;
}
.content-page h1 {
  font-size: 2rem;
  padding-top: 1.5rem;
}
.content-page h3 {
  font-size: 1.2rem;
  padding-top: 1.5rem;
}
.content-page pre {
  background: #eee;
  border-radius: 0.5rem;
  margin: 0.5rem 0 0.5rem 2rem;
  display: inline-block;
  border: 1px solid #aaa;
}
.content-page pre[data-line*="expand"] {
  display: block;
}
.content-page p {
  padding-left: 2rem;
}
.content-page a {
  color: #371ea3;
  text-decoration: underline;
}
</style>
