<template>
  <div class="app-container perception-page">
    <div class="page-head">
      <div>
        <p>Threat Perception</p>
        <h2>全域威胁感知</h2>
      </div>
      <el-button type="primary" icon="el-icon-refresh" @click="refreshTime = new Date().toLocaleString()">刷新态势</el-button>
    </div>

    <el-row :gutter="16">
      <el-col v-for="item in summary" :key="item.label" :xs="24" :sm="12" :lg="6">
        <el-card class="summary-card" shadow="never">
          <span>{{ item.label }}</span>
          <strong>{{ item.value }}</strong>
          <small>{{ item.desc }}</small>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <el-col :xs="24" :lg="15">
        <el-card class="work-card" shadow="never">
          <div slot="header">
            <span>多源数据接入</span>
          </div>
          <el-table :data="sources" border>
            <el-table-column prop="name" label="数据源" min-width="150" />
            <el-table-column prop="type" label="采集类型" width="140" />
            <el-table-column prop="status" label="状态" width="110">
              <template slot-scope="scope">
                <el-tag :type="scope.row.status === '在线' ? 'success' : 'warning'">{{ scope.row.status }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="rate" label="采集频率" width="120" />
            <el-table-column prop="lastSeen" label="最近上报" width="180" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="9">
        <el-card class="work-card" shadow="never">
          <div slot="header">
            <span>处理流程</span>
          </div>
          <el-steps direction="vertical" :active="4" finish-status="success">
            <el-step title="实时采集" description="接入流量、设备、链路和行为日志" />
            <el-step title="数据清洗" description="标准化异构协议和字段结构" />
            <el-step title="特征提取" description="生成后续分析所需的特征输入" />
            <el-step title="流式分发" description="向认知分析和信任评估模块推送" />
          </el-steps>
        </el-card>
      </el-col>
    </el-row>

    <el-card class="work-card" shadow="never">
      <div slot="header">
        <span>近期感知事件</span>
      </div>
      <el-table :data="events" border>
        <el-table-column prop="time" label="时间" width="180" />
        <el-table-column prop="asset" label="对象" width="160" />
        <el-table-column prop="event" label="事件" min-width="220" />
        <el-table-column prop="level" label="等级" width="100">
          <template slot-scope="scope">
            <el-tag :type="levelType[scope.row.level]">{{ scope.row.level }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="action" label="建议动作" min-width="180" />
      </el-table>
    </el-card>

    <p class="refresh-time">最后刷新：{{ refreshTime }}</p>
  </div>
</template>

<script>
export default {
  name: "ThreatPerception",
  data() {
    return {
      refreshTime: new Date().toLocaleString(),
      summary: [
        { label: "在线感知代理", value: "12", desc: "覆盖无人机与地面控制节点" },
        { label: "今日采集事件", value: "2,486", desc: "流式处理持续运行" },
        { label: "异常链路", value: "3", desc: "进入认知分析队列" },
        { label: "高风险告警", value: "1", desc: "等待策略确认" }
      ],
      sources: [
        { name: "UAV-Gateway-01", type: "网络流量", status: "在线", rate: "1s", lastSeen: "刚刚" },
        { name: "Ground-Control-A", type: "操作日志", status: "在线", rate: "5s", lastSeen: "1 分钟前" },
        { name: "Link-Monitor-East", type: "链路状态", status: "在线", rate: "2s", lastSeen: "刚刚" },
        { name: "Device-Agent-07", type: "设备状态", status: "待确认", rate: "10s", lastSeen: "8 分钟前" }
      ],
      events: [
        { time: "2026-05-05 15:28:12", asset: "UAV-Gateway-01", event: "检测到异常端口扫描行为", level: "高", action: "提交协同防御模块限流" },
        { time: "2026-05-05 15:21:44", asset: "Ground-Control-A", event: "管理员登录地理位置变化", level: "中", action: "触发动态信任复评" },
        { time: "2026-05-05 15:10:37", asset: "Link-Monitor-East", event: "通信链路抖动超过阈值", level: "低", action: "持续观察并记录基线" }
      ],
      levelType: {
        高: "danger",
        中: "warning",
        低: "info"
      }
    }
  }
}
</script>

<style scoped lang="scss">
.perception-page {
  background: #f5f7fb;
  min-height: calc(100vh - 84px);
}

.page-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;

  p {
    margin: 0 0 4px;
    color: #667085;
  }

  h2 {
    margin: 0;
    color: #123655;
  }
}

.summary-card,
.work-card {
  margin-bottom: 16px;
  border-radius: 8px;
}

.summary-card {
  span,
  strong,
  small {
    display: block;
  }

  span {
    color: #667085;
  }

  strong {
    margin: 10px 0 6px;
    color: #123655;
    font-size: 24px;
  }

  small {
    color: #8a94a6;
  }
}

.refresh-time {
  margin: 0;
  color: #8a94a6;
  text-align: right;
}
</style>
