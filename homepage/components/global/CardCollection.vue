<template>
  <div class="card-collection">
    <font-awesome-icon v-if="scroll > 0" class="move-icon move-left hidden sm:block" icon="angle-left" @click="incScroll(-450)" />
    <div ref="list" class="slots-list" @scroll="handleScroll">
      <slot />
    </div>
    <font-awesome-icon v-if="scroll < scrollMax" class="move-icon move-right hidden sm:block" icon="angle-right" @click="incScroll(450)" />
  </div>
</template>
<script>
export default {
  name: 'CardCollection',
  data () {
    return {
      scroll: 0,
      scrollMax: 0
    }
  },
  computed: {},
  mounted () {
    this.scrollMax = this.$refs.list.scrollLeftMax || (this.$refs.list.scrollWidth - this.$refs.list.offsetWidth)
  },
  updated () {
    this.$nextTick(() => {
      this.scrollMax = this.$refs.list.scrollLeftMax || (this.$refs.list.scrollWidth - this.$refs.list.offsetWidth)
    })
  },
  methods: {
    handleScroll () {
      this.scroll = this.$refs.list.scrollLeft
    },
    incScroll (v) {
      v = Math.min(Math.max(this.scroll + v, 0), this.scrollMax)
      this.$refs.list.scrollLeft = v
    }
  }
}
</script>
<style>
.card-collection {
  position: relative;
}
.card-collection > .slots-list {
  white-space: nowrap;
  overflow-x: auto;
  padding: 0 1rem 1rem 1rem;
  scroll-behavior: smooth;
  scrollbar-width: none;
  -ms-overflow-style: none;
  vertical-align: middle;
}
.card-collection > .slots-list::-webkit-scrollbar {
  display: none;
}
.card-collection > .move-icon {
  font-size: 7rem;
  top: 50%;
  position: absolute;
  transform: translateY(-50%);
  color: black;
  z-index: 10;
}
.card-collection > .move-left {
  left: 1rem;
}
.card-collection > .move-right {
  right: 1rem;
}
</style>
