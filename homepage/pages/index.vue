<template>
  <div class="main-page grid gap-4 md:grid-cols-3">
    <div class="quote md:col-span-3 text-4xl font-medium text-center italic p-10 md:absolute w-screen">
      On a mission to responsibly build machine learning predictive models
    </div>
    <div class="logo-container hidden md:block">
      <img class="logo" src="@/assets/dalex.svg">
    </div>
    <div class="hub flex flex-wrap p-8 xl:p-32 md:col-span-2 content-around justify-center ml:justify-end">
      <NuxtLink v-for="l in nuxtLinks" :key="l.label" :to="l.to" class="block rounded-2xl border-2 w-64 h-64 text-center p-4 space-y-2 cursor-pointer duration-300 easy-in m-8">
        <font-awesome-icon :icon="l.icon" class="icon block" />
        <span class="block text-2xl font-bold">{{ l.label }}</span>
      </NuxtLink>
      <a v-for="l in extLinks" :key="l.label" :href="l.href" class="block rounded-2xl border-2 w-64 h-64 text-center p-4 space-y-2 cursor-pointer duration-300 easy-in m-8">
        <font-awesome-icon :icon="l.icon" class="icon block" />
        <span class="block text-2xl font-bold">{{ l.label }}</span>
      </a>
    </div>
    <div class="logo-container md:hidden">
      <img class="logo" src="@/assets/dalex.svg">
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      links: [
        { label: 'Dalex for Python', icon: ['fab', 'python'], to: '/python' },
        { label: 'Dalex for R', icon: ['fab', 'r-project'], href: 'https://modeloriented.github.io/DALEX/index.html' },
        { label: 'Responsible ML blog', icon: ['far', 'newspaper'], href: 'https://medium.com/responsibleml' }
      ]
    }
  },
  computed: {
    nuxtLinks () {
      return this.links.filter(l => l.to)
    },
    extLinks () {
      return this.links.filter(l => l.href)
    }
  }
}
</script>

<style>
.main-page {
  min-height: 100vh;
  width: 100%;
  min-height: 100vh;
  background: white;
  position: relative;
}

.main-page > .logo-container {
  position: relative;
  min-height: 50vh;
  overflow: hidden;
}
.main-page > .logo-container > .logo {
  position: absolute;
  left: -10%;
  transform: scaleX(-1);
  top: 20px;
  height: 120%;
  animation: 2s appear;
}
.main-page > .hub {
  overflow-x: hidden;
}
.main-page > .hub > a {
  border-color: #371ea3;
  color: #371ea3;
  animation: 2s appear;
}
.main-page > .hub > a > .icon {
  font-size: 10rem;
}
.main-page > .hub > a:hover {
  background: #371ea3;
  color: white;
}
.main-page > .quote {
  color: #371ea3;
}
@keyframes appear {
  0% {
    opacity: 0;
  }
}

.object-cover {
    object-fit: contain !important;
}
</style>
