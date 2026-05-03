<template>
  <div>
    <svg-icon icon-class="question" @click="showDocumentationInfo" />
  </div>
</template>

<script setup>
import { ElMessage } from "element-plus";

function showDocumentationInfo() {
  ElMessage.info("SkyShield documentation link is not configured yet.")
}
</script>
