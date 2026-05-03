<template>
  <div>
    <svg-icon icon-class="question" @click="goto" />
  </div>
</template>

<script>
export default {
  name: 'SkyShieldDoc',
  data() {
    return {
      url: 'http://doc.skyshield.vip/skyshield-vue'
    }
  },
  methods: {
    goto() {
      window.open(this.url)
    }
  }
}
</script>