<template>
  <div class="app-container">
    <!-- 顶部数字卡片 -->
    <el-row :gutter="20" class="card-row">
      <el-col :span="8">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>当前总可用余额</span>
          </div>
          <div class="card-value">¥ {{ cardData.currentBalance || '0.00' }}</div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>累计借款总额</span>
          </div>
          <div class="card-value">¥ {{ cardData.totalBorrowed || '0.00' }}</div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>累计转账支出</span>
          </div>
          <div class="card-value">¥ {{ cardData.totalTransferOut || '0.00' }}</div>
        </el-card>
      </el-col>
    </el-row>

        <!-- 图表区：四宫格布局 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <!-- 第一行，第一个图：资产构成环形图 -->
      <el-col :span="12" style="margin-bottom: 20px;">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>资产构成分析</span>
          </div>
          <div id="pieChart" style="width: 100%; height: 280px;"></div>
        </el-card>
      </el-col>

      <!-- 第一行，第二个图：近7天收支柱状图 -->
      <el-col :span="12" style="margin-bottom: 20px;">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>近7天收支趋势</span>
          </div>
          <div id="barChart" style="width: 100%; height: 280px;"></div>
        </el-card>
      </el-col>

      <!-- 第二行，第一个图：先空着备用 -->
      <el-col :span="12" style="margin-bottom: 20px;">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>待扩展模块 (图3)</span>
          </div>
          <div style="width: 100%; height: 280px; display: flex; align-items: center; justify-content: center; color: #999;">
            <!-- 以后可以在这里放一个折线图或饼图 -->
            <i class="el-icon-data-analysis" style="font-size: 40px;"></i>
            <span style="margin-left: 10px;">模块升级中...</span>
          </div>
        </el-card>
      </el-col>

      <!-- 第二行，第二个图：先空着备用 -->
      <el-col :span="12" style="margin-bottom: 20px;">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>待扩展模块 (图4)</span>
          </div>
          <div style="width: 100%; height: 280px; display: flex; align-items: center; justify-content: center; color: #999;">
            <!-- 以后可以在这里放一个排行榜或雷达图 -->
            <i class="el-icon-pie-chart" style="font-size: 40px;"></i>
            <span style="margin-left: 10px;">模块升级中...</span>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'; 
import { getDashboardData } from '@/api/manage/dashboard'; // 确保路径正确
import { getUserProfile } from '@/api/system/user';

const currentUserId = ref('');
const userRes = await getUserProfile();
currentUserId.value = userRes.data.userId;


export default {
  name: "BankDashboard",
  data() {
    return {
      userId: currentUserId.value, // 当前用户 ID
      cardData: {},
      pieChartInstance: null,
      barChartInstance: null
    }
  },
  mounted() {
    this.fetchData();
    window.addEventListener('resize', this.handleResize);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
    if (this.pieChartInstance) this.pieChartInstance.dispose();
    if (this.barChartInstance) this.barChartInstance.dispose();
  },
  methods: {
    fetchData() {
      getDashboardData(this.userId).then(res => {
        // 若依的 axios 拦截器通常会把最外层的返回解包
        // 所以这里的 res 可能直接就是 { cardData, chartData, trendData }
        // 具体取决于你的 request.js，建议打印一下
        console.log("后端返回的数据：", res);
        
        // 兼容不同情况（有些若依配置 res 是完整返回，有些 res.data 才是）
        const data = res.data || res;
        
        this.cardData = data.cardData || {};
        
        // 必须等 DOM 渲染完毕后，再初始化图表
        this.$nextTick(() => {
          this.initPieChart(data.chartData || []);
          this.initBarChart(data.trendData || []);
        });
      }).catch(err => {
        console.error("获取数据失败", err);
        this.$message.error('获取数据失败');
      });
    },

    // 1. 渲染环形图
    initPieChart(chartData) {
      const chartDom = document.getElementById('pieChart');
      if (!chartDom) return;
      if (this.pieChartInstance) this.pieChartInstance.dispose();
      
      this.pieChartInstance = echarts.init(chartDom);
      
      const option = {
        tooltip: { trigger: 'item', formatter: '{b}: ¥{c} ({d}%)' },
        legend: { top: '5%', left: 'center' },
        color: ['#67C23A', '#E6A23C', '#F56C6C'],
        series: [
          {
            name: '资产构成',
            type: 'pie',
            radius: ['45%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
            label: { show: true, formatter: '{b}\n¥{c}' },
            data: chartData
          }
        ]
      };
      this.pieChartInstance.setOption(option);
    },

    // 2. 渲染柱状图
    initBarChart(trendList) {
      const chartDom = document.getElementById('barChart');
      if (!chartDom) return;
      if (this.barChartInstance) this.barChartInstance.dispose();
      
      this.barChartInstance = echarts.init(chartDom);
      
      // 提取 X 轴日期和 Y 轴金额
      // 注意：后端返回的字段名必须和这里一致！
      const dates = trendList.map(item => item.date_str);
      const inAmounts = trendList.map(item => item.inAmount || 0);
      const outAmounts = trendList.map(item => item.outAmount || 0);

      const option = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        legend: { data: ['收入', '支出'], top: '0%' },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { 
            type: 'category', 
            data: dates, 
            axisTick: { alignWithLabel: true } 
        },
        yAxis: { type: 'value' },
        series: [
          {
            name: '收入',
            type: 'bar',
            barWidth: '30%',
            itemStyle: { color: '#67C23A', borderRadius: [4, 4, 0, 0] },
            data: inAmounts
          },
          {
            name: '支出',
            type: 'bar',
            barWidth: '30%',
            itemStyle: { color: '#F56C6C', borderRadius: [4, 4, 0, 0] },
            data: outAmounts
          }
        ]
      };
      this.barChartInstance.setOption(option);
    },

    // 窗口大小变化时，两个图一起自适应
    handleResize() {
      if (this.pieChartInstance) this.pieChartInstance.resize();
      if (this.barChartInstance) this.barChartInstance.resize();
    }
  }
}
</script>

<style scoped>
.card-row .card-value {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
  text-align: center;
  margin-top: 10px;
}
</style>