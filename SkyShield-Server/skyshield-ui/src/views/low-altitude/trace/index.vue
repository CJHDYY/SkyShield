<template>
  <div class="app-container module-page">
    <div class="module-head">
      <p>Attack Traceability</p>
      <h2>攻击溯源与分析</h2>
      <span>基于时间序列和行为关联还原攻击路径，定位关键节点，并向防御策略提供反馈。</span>
    </div>

    <el-card class="work-card" shadow="never">
      <div slot="header"><span>攻击链路时间线</span></div>
      <el-timeline>
        <el-timeline-item v-for="item in timeline" :key="item.time" :timestamp="item.time" :type="item.type">
          <strong>{{ item.title }}</strong>
          <p>{{ item.desc }}</p>
        </el-timeline-item>
      </el-timeline>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "AttackTrace",
  data() {
    return {
      timeline: [
        { time: "15:10:37", title: "链路抖动异常", desc: "东侧通信链路出现持续抖动，进入事件关联队列。", type: "primary" },
        { time: "15:21:44", title: "异常登录行为", desc: "地面控制端登录位置变化，与前序链路事件存在时间关联。", type: "warning" },
        { time: "15:28:12", title: "端口扫描行为", desc: "网关节点检测到高频扫描，初步判断为攻击链关键节点。", type: "danger" },
        { time: "15:30:01", title: "策略反馈", desc: "输出限流、隔离和权限收紧建议。", type: "success" }
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
.work-card { margin-bottom: 16px; border-radius: 8px; }
.work-card p { margin: 6px 0 0; color: #667085; }
</style>
