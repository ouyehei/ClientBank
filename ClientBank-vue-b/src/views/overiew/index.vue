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

    <!-- 环形图 -->
    <el-row style="margin-top: 30px;">
      <el-col :span="24">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>资产构成分析</span>
          </div>
          <!-- ECharts 容器 -->
          <div id="assetChart" style="width: 100%; height: 450px;"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { getDashboardData } from '@/'

export default {
  name: "BankDashboard",
  data() {
    return {
      // 模拟用户ID，在真实系统中，应该是 this.$store.getters.id 或当前登录用户
      userId: 101, 
      cardData: {},
      chartInstance: null
    }
  },
  mounted() {
    this.fetchData();
    // 监听窗口大小变化，自适应图表
    window.addEventListener('resize', this.handleResize);
  },
  beforeDestroy() {
    // 组件销毁前清理监听
    window.removeEventListener('resize', this.handleResize);
    if (this.chartInstance) {
      this.chartInstance.dispose();
    }
  },
  methods: {
    fetchData() {
      getDashboardData(this.userId).then(res => {
        // 若依框架 res 就是后台的 AjaxResult 解包后的 data 部分
        const data = res.data; 
        
        this.cardData = data.cardData || {};
        
        // 初始化图表，传入环形图数据
        this.initChart(data.chartData || []);
      }).catch(err => {
        this.$message.error('获取数据失败');
      });
    },
    initChart(chartData) {
      // 如果容器还没渲染，直接返回
      const chartDom = document.getElementById('assetChart');
      if (!chartDom) return;

      // 如果已有实例则销毁重建
      if (this.chartInstance) {
        this.chartInstance.dispose();
      }
      
      this.chartInstance = echarts.init(chartDom);

      const option = {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: ¥{c} ({d}%)' // 鼠标悬浮提示
        },
        legend: {
          top: '5%',
          left: 'center'
        },
        // 设置好看的主题颜色
        color: ['#67C23A', '#E6A23C', '#F56C6C'],
        series: [
          {
            name: '资产构成',
            type: 'pie',
            radius: ['45%', '70%'], // 环形效果
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: true,
              formatter: '{b}\n¥{c}',
              fontSize: 14,
              fontWeight: 'bold'
            },
            data: chartData
          }
        ]
      };

      this.chartInstance.setOption(option);
    },
    handleResize() {
      if (this.chartInstance) {
        this.chartInstance.resize();
      }
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