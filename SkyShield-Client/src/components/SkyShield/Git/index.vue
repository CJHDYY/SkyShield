<template>
  <div>
    <svg-icon icon-class="github" @click="showRepositoryInfo" />
  </div>
</template>

<script setup>
import { ElMessage } from "element-plus";

function showRepositoryInfo() {
  ElMessage.info("SkyShield repository link is not configured yet.")
}
</script>
