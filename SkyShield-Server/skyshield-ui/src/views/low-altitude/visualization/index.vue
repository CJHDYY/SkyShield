<template>
  <div class="app-container module-page">
    <div class="module-head">
      <p>System Visualization</p>
      <h2>系统管理与可视化</h2>
      <span>提供系统配置、策略管理、运行监控、日志管理、权限控制与告警管理的统一入口。</span>
    </div>

    <el-row :gutter="16">
      <el-col v-for="item in entries" :key="item.title" :xs="24" :sm="12" :lg="8">
        <el-card class="entry-card" shadow="never">
          <strong>{{ item.title }}</strong>
          <span>{{ item.desc }}</span>
          <el-tag size="small">{{ item.status }}</el-tag>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "SystemVisualization",
  data() {
    return {
      entries: [
        { title: "安全态势仪表盘", desc: "展示安全状态、风险等级和核心告警。", status: "基础版" },
        { title: "策略管理", desc: "管理响应规则、处置流程和人工审批策略。", status: "建设中" },
        { title: "日志与审计", desc: "统一查看操作日志、事件日志和审计记录。", status: "基础版" },
        { title: "权限控制", desc: "按角色控制模块访问与处置权限。", status: "规划中" },
        { title: "告警中心", desc: "集中处理安全告警、通知和工单流转。", status: "建设中" },
        { title: "系统配置", desc: "维护感知代理、模型参数和平台基础设置。", status: "规划中" }
      ]
    }
  }
}
</script>

<style scoped lang="scss">
.module-page { background: #f5f7fb; min-height: calc(100vh - 84px); }
.module-head { margin-bottom: 16px; color: #667085; }
.module-head p { margin: 0 0 4px; }
.module-head h2 { margin: 0 0 8px; color: #123655; }
.entry-card { margin-bottom: 16px; border-radius: 8px; min-height: 132px; }
.entry-card strong, .entry-card span { display: block; }
.entry-card strong { color: #123655; margin-bottom: 8px; }
.entry-card span { color: #667085; margin-bottom: 16px; line-height: 1.7; }
</style>
