<template>
  <div class="app-container module-page">
    <div class="module-head">
      <p>Intelligent Cognition</p>
      <h2>智能认知与分析</h2>
      <span>基于大模型、规则引擎、行为建模与异常检测，对低空网络数据进行语义理解、攻击识别和风险评估。</span>
    </div>

    <el-row :gutter="16">
      <el-col v-for="item in cards" :key="item.title" :xs="24" :sm="12" :lg="6">
        <el-card class="module-card" shadow="never">
          <strong>{{ item.value }}</strong>
          <span>{{ item.title }}</span>
          <small>{{ item.desc }}</small>
        </el-card>
      </el-col>
    </el-row>

    <el-card class="work-card" shadow="never">
      <div slot="header"><span>分析能力建设</span></div>
      <el-table :data="capabilities" border>
        <el-table-column prop="name" label="能力项" min-width="160" />
        <el-table-column prop="method" label="实现方式" min-width="220" />
        <el-table-column prop="output" label="输出结果" min-width="200" />
        <el-table-column prop="status" label="状态" width="120">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '已启用' ? 'success' : 'warning'">{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "ThreatCognition",
  data() {
    return {
      cards: [
        { title: "待分析事件", value: "36", desc: "来自威胁感知模块" },
        { title: "未知威胁线索", value: "5", desc: "进入关联分析队列" },
        { title: "模型置信度", value: "91%", desc: "综合规则与行为特征" },
        { title: "高风险判断", value: "2", desc: "建议转入防御响应" }
      ],
      capabilities: [
        { name: "特征匹配", method: "协议字段、端口行为、载荷特征比对", output: "已知攻击分类", status: "已启用" },
        { name: "行为建模", method: "设备历史轨迹与实时行为偏差分析", output: "异常行为评分", status: "已启用" },
        { name: "语义理解", method: "大模型辅助解释日志与操作意图", output: "事件摘要与处置建议", status: "建设中" },
        { name: "持续学习", method: "处置结果回流优化规则权重", output: "策略调优样本", status: "建设中" }
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
.module-card, .work-card { margin-bottom: 16px; border-radius: 8px; }
.module-card strong, .module-card span, .module-card small { display: block; }
.module-card strong { color: #123655; font-size: 24px; margin-bottom: 8px; }
.module-card span { color: #344054; }
.module-card small { color: #8a94a6; margin-top: 6px; }
</style>
