<template>
  <div class="lobby-container">
    <div class="lobby-header">
      <h1>自助服务大厅</h1>
      <p class="lobby-subtitle">请点击下方卡片，选择您需要办理的业务</p>
    </div>

    <div class="business-grid">
      <!-- 核心业务卡片：通过数据驱动 -->
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
  UserFilled // 用于个人信息修改图标
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()

// 业务数据配置
const businessList = [
  { 
    name: '开立I类户', 
    code: 'OPEN_I_ACCOUNT', 
    desc: '全功能主账户，需临柜办理',
    icon: User, 
    color: '#409EFF',
    // I类户必须临柜
    requiresCounter: true 
  },
  { 
    name: '开立II类户', 
    code: 'OPEN_II_ACCOUNT', 
    desc: '线上自助快捷开户',
    icon: Wallet, 
    color: '#67C23A',
    requiresCounter: false
  },
  { 
    name: '账户销户', 
    code: 'CLOSE_ACCOUNT', 
    desc: '线上自助销户注销',
    icon: Delete, 
    color: '#F56C6C',
    requiresCounter: false
  },
  { 
    name: '大额转账', 
    code: 'LARGE_TRANSFER', 
    desc: '大额资金划转，超额需预约',
    icon: Money, 
    color: '#E6A23C',
    // 转账已有功能，由后端校验阈值
    requiresCounter: false,
    hasBackendCheck: true 
  },
  { 
    name: '大额借贷', 
    code: 'LARGE_LOAN', 
    desc: '申请个人信贷，超额需预约',
    icon: DocumentChecked, 
    color: '#909399',
    // 借贷已有功能，由后端校验阈值
    requiresCounter: false,
    hasBackendCheck: true
  },
  { 
    name: '信息修改', 
    code: 'UPDATE_PROFILE', 
    desc: '修改昵称、手机号及邮箱',
    icon: UserFilled, 
    color: '#409EFF',
    path: '/manage/selfService/profileEdit', // 若依自带接口对应页面或路径
    requiresCounter: false
  }
]

// 点击卡片处理逻辑
const goToService = (item) => {
  // 1. 必须临柜办理的业务
  if (item.requiresCounter) {
    ElMessageBox.alert(
      `<strong style="font-size:16px; color:#409EFF">${item.name}</strong><br/><br/>
       该业务涉及账户核心安全，系统检测到必须前往线下网点柜台办理。<br/>
       建议您携带身份证前往附近银行网点办理。`, 
      '业务办理提示', 
      {
        dangerouslyUseHTMLString: true,
        confirmButtonText: '我知道了',
        type: 'warning'
      }
    )
    return;
  }

  // 2. 已有功能，走后端限额校验的业务（转账/借贷）
  if (item.hasBackendCheck) {
    // 跳转到你已有的转账或借贷页面
    // 后端 Controller 层会校验金额，若超出阈值，直接返回特定的错误码，前端弹窗引导用户填写预约表单
    if(item.path) {
      router.push(item.path)
    } else {
      // 模拟提示（实际项目中会跳转路由）
      ElMessage.success(`正在进入${item.name}页面，系统将自动校验额度...`)
    }
    return;
  }

  // 3. 普通自助业务（II类户、销户、信息修改等）
  if (item.path) {
    router.push(item.path)
  } else {
    ElMessage.success(`正在进入${item.name}办理页面...`)
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