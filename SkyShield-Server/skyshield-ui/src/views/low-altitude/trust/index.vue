<template>
  <div class="app-container module-page">
    <div class="module-head">
      <p>Dynamic Trust</p>
      <h2>动态信任评估</h2>
      <span>围绕设备状态、行为特征与历史记录建立持续信任评分，驱动后续访问控制和策略执行。</span>
    </div>

    <el-row :gutter="16">
      <el-col :xs="24" :lg="8">
        <el-card class="score-card" shadow="never">
          <span>当前综合信任值</span>
          <strong>82</strong>
          <el-progress :percentage="82" status="success" />
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="16">
        <el-card class="work-card" shadow="never">
          <div slot="header"><span>评分因子</span></div>
          <el-table :data="factors" border>
            <el-table-column prop="name" label="指标" min-width="160" />
            <el-table-column prop="weight" label="权重" width="120" />
            <el-table-column prop="score" label="当前得分" width="120" />
            <el-table-column prop="desc" label="说明" min-width="220" />
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "DynamicTrust",
  data() {
    return {
      factors: [
        { name: "设备健康状态", weight: "30%", score: "88", desc: "在线状态、固件版本、传感器运行情况" },
        { name: "通信行为稳定性", weight: "25%", score: "79", desc: "链路抖动、异常端口、流量突增" },
        { name: "历史安全记录", weight: "25%", score: "85", desc: "过往告警、处置结果、违规次数" },
        { name: "时间衰减修正", weight: "20%", score: "76", desc: "近期异常对信任值产生更高影响" }
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
.score-card, .work-card { margin-bottom: 16px; border-radius: 8px; }
.score-card span, .score-card strong { display: block; }
.score-card strong { color: #123655; font-size: 52px; margin: 14px 0; }
</style>
