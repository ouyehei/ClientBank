<template>
  <div class="lobby-container">
    <div class="lobby-header">
      <h1>自助服务大厅</h1>
      <p class="lobby-subtitle">请点击下方卡片，选择您需要办理的业务</p>
    </div>

    <div class="business-grid">
      <!-- 核心业务卡片：通过数据驱动，后续可直接替换为后台返回的接口数据 -->
      <div 
        class="business-card" 
        v-for="item in businessList" 
        :key="item.code"
        @click="goToService(item)"
      >
        <div class="card-icon">
          <el-icon :size="40" :color="item.color">
            <component :is="item.icon" />
          </el-icon>
        </div>
        <div class="card-info">
          <h3>{{ item.name }}</h3>
          <p>{{ item.desc }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { 
  User, 
  Delete, 
  Money, 
  Wallet, 
  DocumentChecked, 
  Refresh 
} from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const router = useRouter()

// 业务数据配置（后台字典/接口改造前，先在这里模拟）
const businessList = [
  { 
    name: '开立I类户', 
    code: 'OPEN_I_ACCOUNT', 
    desc: '办理个人I类银行账户',
    icon: User, 
    color: '#409EFF',
    // 模拟跳转路由
    path: '/open-account',
    requiresCounter: false // false: 自主办理; true: 需临柜
  },
  { 
    name: '开立II类户', 
    code: 'OPEN_II_ACCOUNT', 
    desc: '办理个人II类银行账户',
    icon: Wallet, 
    color: '#67C23A',
    path: '/open-account-ii',
    requiresCounter: false
  },
  { 
    name: '账户销户', 
    code: 'CLOSE_ACCOUNT', 
    desc: '注销名下闲置账户',
    icon: Delete, 
    color: '#F56C6C',
    path: '/close-account',
    requiresCounter: true // 强制临柜办理
  },
  { 
    name: '大额转账', 
    code: 'LARGE_TRANSFER', 
    desc: '办理大额资金划转',
    icon: Money, 
    color: '#E6A23C',
    path: '/transfer',
    requiresCounter: false
  },
  { 
    name: '大额信贷', 
    code: 'LARGE_LOAN', 
    desc: '申请大额个人信贷',
    icon: DocumentChecked, 
    color: '#909399',
    path: '/loan',
    requiresCounter: true
  },
  { 
    name: '密码重置', 
    code: 'RESET_PASSWORD', 
    desc: '找回或重置登录密码',
    icon: Refresh, 
    color: '#409EFF',
    path: '/reset-password',
    requiresCounter: false
  }
]

// 点击卡片跳转对应业务页面
const goToService = (item) => {
  if (item.requiresCounter) {
    // 如果业务需要临柜，弹窗提示用户
    ElMessage.warning(`"${item.name}" 需前往线下网点办理，建议您选择自主办理业务或稍后前往柜台。`)
  } else {
    // 自主办理业务，直接跳转到对应的Vue页面
    router.push(item.path)
  }
}
</script>

<style scoped>
.lobby-container {
  padding: 40px 20px;
  max-width: 1200px;
  margin: 0 auto;
  min-height: calc(100vh - 84px);
}

.lobby-header {
  text-align: center;
  margin-bottom: 50px;
}

.lobby-header h1 {
  font-size: 32px;
  color: #1f2f3d;
  margin-bottom: 10px;
}

.lobby-subtitle {
  color: #8c98a4;
  font-size: 16px;
}

/* 业务卡片网格布局 */
.business-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 30px;
}

.business-card {
  background-color: #ffffff;
  border-radius: 16px;
  padding: 40px 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid transparent;
}

.business-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  border-color: #e6ebf5;
}

.card-icon {
  margin-bottom: 20px;
}

.card-info {
  text-align: center;
}

.card-info h3 {
  font-size: 20px;
  color: #303133;
  margin-bottom: 10px;
  font-weight: 600;
}

.card-info p {
  font-size: 14px;
  color: #909399;
  line-height: 1.5;
}
</style>