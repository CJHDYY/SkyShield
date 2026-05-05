<template>
  <div class="app-container home">
    <section class="overview">
      <div>
        <p class="eyebrow">SkyShield Low-Altitude Security</p>
        <h2>低空网络安全防护平台</h2>
        <p class="intro">
          围绕“感知、认知、决策、防御、溯源”的安全闭环，统一承载低空网络环境下的威胁监测、风险研判、动态信任评估和协同响应能力。
        </p>
      </div>
      <div class="status-panel">
        <div>
          <span>系统状态</span>
          <strong>运行中</strong>
        </div>
        <div>
          <span>防护模式</span>
          <strong>闭环联动</strong>
        </div>
      </div>
    </section>

    <el-row :gutter="16" class="metric-row">
      <el-col v-for="item in metrics" :key="item.label" :xs="24" :sm="12" :lg="6">
        <el-card class="metric-card" shadow="never">
          <span>{{ item.label }}</span>
          <strong>{{ item.value }}</strong>
          <small>{{ item.caption }}</small>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <el-col :xs="24" :lg="14">
        <el-card class="module-card" shadow="never">
          <template #header>
            <span>产品功能模块</span>
          </template>
          <div class="module-grid">
            <div v-for="module in modules" :key="module.title" class="module-item">
              <strong>{{ module.title }}</strong>
              <p>{{ module.desc }}</p>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="10">
        <el-card class="module-card" shadow="never">
          <template #header>
            <span>建设闭环</span>
          </template>
          <el-timeline>
            <el-timeline-item
              v-for="step in loopSteps"
              :key="step"
              :timestamp="step"
              placement="top"
            />
          </el-timeline>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Index">
const metrics = [
  { label: '接入数据源', value: '4 类', caption: '流量、设备、链路、日志' },
  { label: '分析能力', value: '规则 + 模型', caption: '支持异常识别与风险评估' },
  { label: '响应策略', value: '4 种', caption: '控制、限流、隔离、调整' },
  { label: '安全闭环', value: '5 阶段', caption: '从采集到溯源反馈' }
]

const modules = [
  { title: '全域威胁感知', desc: '统一采集网络流量、设备状态、链路信息和操作行为日志。' },
  { title: '智能认知与分析', desc: '结合大模型、规则引擎和异常检测完成攻击识别与风险研判。' },
  { title: '动态信任评估', desc: '基于多维指标持续计算设备与通信行为的实时信任值。' },
  { title: '协同防御与响应', desc: '按风险结果执行访问控制、流量限制、异常隔离与策略调整。' },
  { title: '攻击溯源与分析', desc: '通过攻击路径图和事件时间线还原攻击链路。' },
  { title: '系统管理与可视化', desc: '提供配置、策略、日志、权限、告警和运行监控能力。' }
]

const loopSteps = ['数据采集', '智能分析', '动态评估', '协同防御', '溯源反馈']
</script>

<style scoped lang="scss">
.home {
  background: #f5f7fb;
  min-height: calc(100vh - 84px);
}

.overview {
  display: flex;
  align-items: stretch;
  justify-content: space-between;
  gap: 20px;
  padding: 26px;
  margin-bottom: 16px;
  color: #fff;
  background: linear-gradient(120deg, #123655 0%, #1b6f8f 58%, #2f9f92 100%);
  border-radius: 8px;

  h2 {
    margin: 4px 0 10px;
    font-size: 26px;
  }
}

.eyebrow {
  margin: 0;
  font-size: 13px;
  opacity: 0.82;
}

.intro {
  max-width: 760px;
  margin: 0;
  line-height: 1.8;
}

.status-panel {
  min-width: 220px;
  display: grid;
  grid-template-columns: 1fr;
  gap: 10px;

  div {
    padding: 14px;
    background: rgba(255, 255, 255, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.22);
    border-radius: 6px;
  }

  span,
  strong {
    display: block;
  }

  span {
    font-size: 12px;
    opacity: 0.82;
  }

  strong {
    margin-top: 6px;
    font-size: 18px;
  }
}

.metric-row {
  margin-bottom: 16px;
}

.metric-card {
  margin-bottom: 16px;

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

.module-card {
  margin-bottom: 16px;
  border-radius: 8px;
}

.module-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.module-item {
  padding: 14px;
  border: 1px solid #e5e9f2;
  border-radius: 6px;
  background: #fbfcff;

  strong {
    color: #123655;
  }

  p {
    margin: 8px 0 0;
    color: #667085;
    line-height: 1.6;
  }
}

@media (max-width: 960px) {
  .overview {
    flex-direction: column;
  }

  .module-grid {
    grid-template-columns: 1fr;
  }
}
</style>
