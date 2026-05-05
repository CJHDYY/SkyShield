<template>
  <div class="app-container home-screen">
    <div class="screen-grid"></div>

    <section class="metric-grid">
      <article v-for="item in metrics" :key="item.label" class="metric-card">
        <div class="metric-card__head">
          <span>{{ item.label }}</span>
          <em>{{ item.tag }}</em>
        </div>
        <div class="metric-card__value">
          <strong>{{ item.value }}</strong>
          <span>{{ item.unit }}</span>
        </div>
      </article>
    </section>

    <section class="screen-content">
      <div class="side-stack">
        <div class="screen-panel alert-panel">
          <div class="panel-head">
            <span>告警动态</span>
            <small>{{ alerts.length }} 条</small>
          </div>
          <div class="alert-list">
            <div v-for="item in alerts" :key="item.title" class="alert-item">
              <div>
                <strong>{{ item.title }}</strong>
                <p>{{ item.source }}</p>
              </div>
              <div class="alert-meta">
                <span :class="['level', item.level]">{{ item.levelText }}</span>
                <small>{{ item.time }}</small>
              </div>
            </div>
          </div>
        </div>

        <div class="screen-panel rank-panel">
          <div class="panel-head">
            <span>动态信任排行</span>
            <small>TOP 5</small>
          </div>
          <div class="rank-list">
            <div v-for="(item, index) in trustRank" :key="item.name" class="rank-item">
              <span class="rank-index">{{ index + 1 }}</span>
              <span class="rank-name">{{ item.name }}</span>
              <div class="rank-bar"><i :style="{ width: item.score + '%' }"></i></div>
              <strong>{{ item.score }}</strong>
            </div>
          </div>
        </div>
      </div>

      <main class="screen-panel trend-panel">
        <div class="panel-head">
          <span>近七日安全态势趋势</span>
          <small>威胁事件 / 信任指数</small>
        </div>
        <div ref="trendChartRef" class="trend-chart"></div>
        <div class="summary-grid">
          <div v-for="item in summary" :key="item.label" class="summary-item">
            <span>{{ item.label }}</span>
            <strong>{{ item.value }}</strong>
          </div>
        </div>
      </main>

      <div class="side-stack">
        <div class="screen-panel todo-panel">
          <div class="panel-head">
            <span>待处理事项</span>
            <small>{{ todos.length }} 项</small>
          </div>
          <div class="todo-list">
            <div v-for="item in todos" :key="item.title" class="todo-item">
              <div>
                <strong>{{ item.title }}</strong>
                <p>{{ item.desc }}</p>
              </div>
              <div class="todo-meta">
                <span :class="['todo-status', item.statusType]">{{ item.status }}</span>
                <small>{{ item.time }}</small>
              </div>
            </div>
          </div>
        </div>

        <div class="screen-panel source-panel">
          <div class="panel-head">
            <span>风险来源占比</span>
            <small>实时更新</small>
          </div>
          <div ref="sourceChartRef" class="source-chart"></div>
          <div class="source-legend">
            <span v-for="item in sources" :key="item.name">
              <i :style="{ background: item.color }"></i>{{ item.name }}
            </span>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup name="Index">
import * as echarts from 'echarts'

const trendChartRef = ref(null)
const sourceChartRef = ref(null)
let trendChart
let sourceChart

const metrics = [
  { label: '在线感知代理', value: '12', unit: '个', tag: '实时' },
  { label: '今日采集事件', value: '2,486', unit: '条', tag: '流式' },
  { label: '告警数量', value: '18', unit: '条', tag: '预警' },
  { label: '综合信任值', value: '82.6', unit: '分', tag: '达标' }
]

const alerts = [
  { title: '网关节点异常端口扫描', source: 'UAV-Gateway-01 / 全域威胁感知', level: 'danger', levelText: '高危', time: '15:28' },
  { title: '控制端登录位置变化', source: 'Ground-Control-A / 动态信任评估', level: 'warning', levelText: '预警', time: '15:21' },
  { title: '通信链路抖动超阈值', source: 'Link-Monitor-East / 智能认知与分析', level: 'info', levelText: '提示', time: '15:10' }
]

const todos = [
  { title: '核查控制端异常登录', desc: '负责人：安全运维', status: '待处理', statusType: 'warning', time: '今日 21:30' },
  { title: '同步信任评分阈值', desc: '负责人：策略管理员', status: '进行中', statusType: 'primary', time: '今日 22:00' },
  { title: '复核攻击链路报告', desc: '负责人：分析研判', status: '已安排', statusType: 'success', time: '明日 10:00' }
]

const trustRank = [
  { name: 'UAV-Gateway-01', score: 92 },
  { name: 'Ground-Control-A', score: 88 },
  { name: 'Link-Monitor-East', score: 84 },
  { name: 'Device-Agent-07', score: 80 },
  { name: 'Control-Backup', score: 76 }
]

const summary = [
  { label: '攻击链路', value: '7' },
  { label: '隔离节点', value: '3' },
  { label: '策略执行', value: '24' },
  { label: '平均响应', value: '236ms' }
]

const sources = [
  { value: 38, name: '网络流量', color: '#34d0ff' },
  { value: 27, name: '通信链路', color: '#2f7bff' },
  { value: 21, name: '设备状态', color: '#24d69a' },
  { value: 14, name: '操作行为', color: '#ffb347' }
]

function renderTrendChart() {
  if (!trendChartRef.value) return
  trendChart?.dispose()
  trendChart = echarts.init(trendChartRef.value)
  trendChart.setOption({
    grid: { left: 44, right: 44, top: 42, bottom: 34 },
    tooltip: { trigger: 'axis' },
    legend: {
      top: 0,
      right: 0,
      textStyle: { color: '#bdd3f2' },
      data: ['威胁事件', '信任指数']
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: ['04-29', '04-30', '05-01', '05-02', '05-03', '05-04', '05-05'],
      axisLabel: { color: '#89a7ce' },
      axisLine: { lineStyle: { color: 'rgba(72, 145, 255, 0.24)' } }
    },
    yAxis: [
      {
        type: 'value',
        axisLabel: { color: '#89a7ce' },
        splitLine: { lineStyle: { color: 'rgba(72, 145, 255, 0.1)' } }
      },
      {
        type: 'value',
        min: 60,
        max: 100,
        axisLabel: { color: '#89a7ce' },
        splitLine: { show: false }
      }
    ],
    series: [
      {
        name: '威胁事件',
        type: 'bar',
        barWidth: 16,
        data: [18, 23, 21, 29, 31, 27, 18],
        itemStyle: {
          borderRadius: [8, 8, 0, 0],
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#34d0ff' },
            { offset: 1, color: '#2f7bff' }
          ])
        }
      },
      {
        name: '信任指数',
        type: 'line',
        yAxisIndex: 1,
        smooth: true,
        symbolSize: 8,
        data: [74, 78, 76, 81, 84, 86, 82],
        itemStyle: { color: '#34d0ff' },
        lineStyle: { width: 3, color: '#34d0ff' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(52, 208, 255, 0.32)' },
            { offset: 1, color: 'rgba(52, 208, 255, 0.03)' }
          ])
        }
      }
    ]
  })
}

function renderSourceChart() {
  if (!sourceChartRef.value) return
  sourceChart?.dispose()
  sourceChart = echarts.init(sourceChartRef.value)
  sourceChart.setOption({
    tooltip: { trigger: 'item' },
    series: [
      {
        type: 'pie',
        radius: ['48%', '72%'],
        center: ['50%', '48%'],
        label: { color: '#bdd3f2' },
        labelLine: { lineStyle: { color: 'rgba(72, 145, 255, 0.32)' } },
        data: sources.map(item => ({
          value: item.value,
          name: item.name,
          itemStyle: { color: item.color }
        }))
      }
    ]
  })
}

function resizeCharts() {
  trendChart?.resize()
  sourceChart?.resize()
}

onMounted(() => {
  nextTick(() => {
    renderTrendChart()
    renderSourceChart()
  })
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  trendChart?.dispose()
  sourceChart?.dispose()
})
</script>

<style scoped lang="scss">
.home-screen {
  position: relative;
  display: grid;
  grid-template-rows: 104px minmax(0, 1fr);
  gap: 16px;
  height: calc(100vh - 84px);
  min-height: 0;
  padding: 18px;
  overflow: hidden;
  color: #d8e8ff;
  background:
    radial-gradient(circle at top right, rgba(52, 208, 255, 0.14), transparent 28%),
    radial-gradient(circle at bottom left, rgba(47, 123, 255, 0.12), transparent 24%),
    #020a18;
}

.screen-grid {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(52, 208, 255, 0.06) 1px, transparent 1px),
    linear-gradient(90deg, rgba(52, 208, 255, 0.06) 1px, transparent 1px);
  background-size: 32px 32px;
  pointer-events: none;
}

.metric-grid,
.screen-content {
  position: relative;
  z-index: 1;
}

.metric-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
  min-height: 0;
}

.metric-card,
.screen-panel {
  border: 1px solid rgba(52, 208, 255, 0.18);
  border-radius: 10px;
  background: linear-gradient(180deg, rgba(8, 24, 52, 0.94), rgba(5, 18, 40, 0.98));
  box-shadow: inset 0 0 0 1px rgba(52, 208, 255, 0.05), 0 18px 36px rgba(0, 8, 25, 0.24);
}

.metric-card {
  display: grid;
  grid-template-rows: auto 1fr;
  min-height: 0;
  padding: 16px 18px;
}

.metric-card__head,
.metric-card__value,
.panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.metric-card__head {
  color: #bdd3f2;

  em {
    color: #34d0ff;
    font-style: normal;
  }
}

.metric-card__value {
  justify-content: flex-start;
  gap: 8px;
  margin: 10px 0 8px;

  strong {
    color: #ffffff;
    font-size: 30px;
  }

  span {
    color: #89a7ce;
  }
}

.screen-content {
  display: grid;
  grid-template-columns: minmax(300px, 22%) minmax(560px, 1fr) minmax(300px, 22%);
  gap: 16px;
  min-height: 0;
  overflow: hidden;
}

.side-stack {
  display: grid;
  grid-template-rows: minmax(0, 1fr) 210px;
  gap: 16px;
  min-height: 0;
  overflow: hidden;
}

.screen-panel {
  min-height: 0;
  overflow: hidden;
  padding: 16px;
}

.trend-panel {
  display: grid;
  grid-template-rows: auto minmax(0, 1fr) 78px;
  min-height: 0;
}

.panel-head {
  margin-bottom: 14px;
  color: #ffffff;

  small {
    color: #89a7ce;
  }
}

.alert-list,
.todo-list {
  display: grid;
  gap: 10px;
}

.alert-list,
.rank-list {
  overflow-y: auto;
  padding-right: 4px;
}

.alert-list {
  max-height: calc(100% - 36px);
}

.rank-list {
  max-height: calc(100% - 36px);
}

.alert-list::-webkit-scrollbar,
.rank-list::-webkit-scrollbar {
  width: 4px;
}

.alert-list::-webkit-scrollbar-track,
.rank-list::-webkit-scrollbar-track {
  background: rgba(47, 123, 255, 0.08);
  border-radius: 999px;
}

.alert-list::-webkit-scrollbar-thumb,
.rank-list::-webkit-scrollbar-thumb {
  background: rgba(52, 208, 255, 0.46);
  border-radius: 999px;
}

.rank-list {
  display: grid;
  gap: 10px;
}

.alert-item,
.todo-item {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  padding: 12px;
  border: 1px solid rgba(52, 208, 255, 0.12);
  border-radius: 8px;
  color: inherit;
  background: rgba(47, 123, 255, 0.08);
}

.alert-item strong,
.todo-item strong {
  color: #ffffff;
}

.alert-item p,
.todo-item p {
  margin: 4px 0 0;
  color: #89a7ce;
  font-size: 12px;
  line-height: 1.35;
}

.alert-item strong,
.todo-item strong,
.rank-name {
  line-height: 1.35;
}

.alert-meta {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  white-space: nowrap;
}

.level,
.todo-status {
  flex: none;
  align-self: flex-start;
  padding: 4px 10px;
  border-radius: 999px;
}

.level.danger { color: #ffd9e2; background: rgba(255, 107, 139, 0.18); }
.level.warning { color: #ffe5b6; background: rgba(255, 179, 71, 0.18); }
.level.info { color: #d7ecff; background: rgba(47, 123, 255, 0.2); }
.todo-status.success { color: #d8fff0; background: rgba(36, 214, 154, 0.18); }
.todo-status.primary { color: #d7ecff; background: rgba(47, 123, 255, 0.2); }
.todo-status.warning { color: #ffe5b6; background: rgba(255, 179, 71, 0.18); }

.trend-chart {
  min-height: 0;
  height: 100%;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
  min-height: 0;
}

.summary-item {
  padding: 8px 12px;
  border: 1px solid rgba(52, 208, 255, 0.14);
  border-radius: 8px;
  background: rgba(47, 123, 255, 0.08);

  span,
  strong {
    display: block;
  }

  span {
    color: #89a7ce;
  }

  strong {
    margin-top: 5px;
    color: #ffffff;
    font-size: 20px;
  }
}

.rank-item {
  display: grid;
  grid-template-columns: 22px 112px 1fr 36px;
  align-items: center;
  gap: 8px;
  color: #bdd3f2;
}

.rank-index {
  display: grid;
  place-items: center;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  color: #ffffff;
  background: rgba(52, 208, 255, 0.16);
}

.rank-name {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.rank-bar {
  height: 9px;
  overflow: hidden;
  border-radius: 999px;
  background: rgba(47, 123, 255, 0.12);

  i {
    display: block;
    height: 100%;
    border-radius: inherit;
    background: linear-gradient(90deg, #2f7bff, #34d0ff);
  }
}

.rank-item strong {
  color: #ffffff;
  text-align: right;
}

.todo-meta {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  white-space: nowrap;
}

.source-chart {
  height: 140px;
}

.source-legend {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 8px;
  color: #89a7ce;

  span {
    display: inline-flex;
    align-items: center;
    gap: 6px;
  }

  i {
    width: 12px;
    height: 8px;
    border-radius: 999px;
  }
}

@media (max-width: 1400px) {
  .screen-content {
    grid-template-columns: 23% 1fr 23%;
  }

  .side-stack {
    grid-template-rows: minmax(0, 1fr) 190px;
  }
}

@media (max-width: 1200px) {
  .home-screen {
    height: auto;
    min-height: calc(100vh - 84px);
    overflow: visible;
  }

  .metric-grid,
  .summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .screen-content {
    grid-template-columns: 1fr;
    overflow: visible;
  }
}

@media (max-width: 640px) {
  .metric-grid,
  .summary-grid {
    grid-template-columns: 1fr;
  }

  .trend-chart {
    height: 320px;
  }
}

@media (max-height: 820px) and (min-width: 1201px) {
  .home-screen {
    grid-template-rows: 90px minmax(0, 1fr);
    gap: 12px;
    padding: 14px;
  }

  .metric-card {
    padding: 10px 12px;
  }

  .metric-card__value strong {
    font-size: 26px;
  }

  .screen-panel {
    padding: 12px;
  }

  .side-stack {
    grid-template-rows: minmax(0, 1fr) 166px;
    gap: 10px;
  }

  .alert-list,
  .rank-list,
  .todo-list {
    gap: 6px;
  }

  .alert-item,
  .todo-item {
    padding: 7px 9px;
  }

  .todo-item p {
    display: none;
  }

  .source-chart {
    height: 92px;
  }

  .summary-item {
    padding: 6px 10px;
  }
}
</style>
