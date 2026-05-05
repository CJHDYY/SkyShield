<template>
  <div class="app-container module-page">
    <div class="module-head">
      <p>Collaborative Defense</p>
      <h2>协同防御与响应</h2>
      <span>根据风险评估结果自动执行访问控制、流量限制、异常隔离与策略调整，并保留人工确认入口。</span>
    </div>

    <el-card class="work-card" shadow="never">
      <div slot="header"><span>响应策略</span></div>
      <el-table :data="policies" border>
        <el-table-column prop="name" label="策略名称" min-width="160" />
        <el-table-column prop="trigger" label="触发条件" min-width="220" />
        <el-table-column prop="action" label="执行动作" min-width="220" />
        <el-table-column prop="mode" label="模式" width="120">
          <template slot-scope="scope">
            <el-tag :type="scope.row.mode === '自动' ? 'success' : 'warning'">{{ scope.row.mode }}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "CollaborativeDefense",
  data() {
    return {
      policies: [
        { name: "异常流量限速", trigger: "链路流量超过动态阈值", action: "限制速率并转入持续观测", mode: "自动" },
        { name: "高危节点隔离", trigger: "信任值低于 60 且存在高危事件", action: "隔离设备并生成处置工单", mode: "人工确认" },
        { name: "模型污染防护", trigger: "训练样本分布异常", action: "冻结样本并回滚模型版本", mode: "人工确认" },
        { name: "访问策略收紧", trigger: "登录位置或权限调用异常", action: "临时收紧访问权限", mode: "自动" }
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
</style>
