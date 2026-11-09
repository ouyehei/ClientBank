<template>
  <div class="reservation-page">
    <el-card shadow="never" class="form-card">
      <div class="form-header">
        <h2 class="page-title">自助服务预约</h2>
        <p class="page-subtitle">选择业务类型并填写相关信息，提交后请留意您的办理进度。</p>
      </div>

      <el-form ref="formRef" :model="form" :rules="rules" label-position="top" style="margin-top: 30px;">
        
        <!-- 1. 用户信息（自动展示，不可修改） -->
        <el-form-item label="办理用户" prop="userId">
          <el-input v-model="form.userId" disabled placeholder="系统自动获取当前用户" />
        </el-form-item>

        <!-- 2. 业务选择（核心入口） -->
        <el-form-item label="选择业务" prop="serviceCode">
          <el-select 
            v-model="form.serviceCode" 
            placeholder="请选择您需要办理的业务" 
            style="width: 100%"
          >
            <!-- 实际项目中这里应该循环渲染你的业务字典或接口数据 -->
            <el-option label="开立一类户" value="OPEN_I_ACCOUNT" />
            <el-option label="开立二类户" value="OPEN_II_ACCOUNT" />
            <el-option label="账户密码重置" value="RESET_PASSWORD" />
            <el-option label="大额取现预约" value="LARGE_CASH" />
          </el-select>
        </el-form-item>

        <!-- 3. 办理渠道（只有临柜才需要预约时间） -->
        <el-form-item label="办理渠道" prop="serviceType">
          <el-radio-group v-model="form.serviceType" @change="handleChannelChange">
            <el-radio label="1" border>自主办理</el-radio>
            <el-radio label="2" border>需临柜办理</el-radio>
          </el-radio-group>
        </el-form-item>

        <!-- 智能联动：只有选择“需临柜办理”时，才显示日期选择器 -->
        <el-form-item 
          label="预约到店时间" 
          prop="reserveTime" 
          v-if="form.serviceType === '2'"
          v-show="form.serviceType === '2'"
        >
          <el-date-picker
            v-model="form.reserveTime"
            type="date"
            placeholder="请选择您方便到店办理的日期"
            value-format="YYYY-MM-DD"
            :disabled-date="disabledDate"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="备注说明" prop="remark">
          <el-input 
            v-model="form.remark" 
            type="textarea" 
            placeholder="如有其他特殊需求，请在此简单说明（选填）" 
            :rows="3" 
          />
        </el-form-item>

        <el-form-item style="margin-top: 40px;">
          <el-button type="primary" @click="submitForm" :loading="loading" size="large" style="width: 100%; font-weight: 600;">
            提交预约
          </el-button>
        </el-form-item>

      </el-form>
    </el-card>
  </div>
</template>

<script setup name="Reservation">
import { addReservation } from "@/api/manage/reservation"
import { getCurrentInstance } from 'vue'

const { proxy } = getCurrentInstance()
const formRef = ref(null)
const loading = ref(false)

const data = reactive({
  form: {
    userId: 1, // TODO: 实际开发中，这里调用接口获取当前登录用户的真实 ID
    serviceCode: undefined,
    serviceName: undefined,
    serviceType: '1', // 默认自主办理
    reserveTime: undefined,
    status: '0', // 默认状态：待处理
    remark: undefined,
  },
  rules: {
    userId: [{ required: true, message: "无法获取当前用户信息，请刷新页面重试", trigger: "blur" }],
    serviceCode: [{ required: true, message: "请选择您需要办理的业务", trigger: "change" }],
    serviceType: [{ required: true, message: "请选择办理渠道", trigger: "change" }],
    reserveTime: [{ required: true, message: "需临柜办理必须选择预约时间", trigger: "change" }]
  }
})

const { form, rules } = toRefs(data)

// 监听办理渠道变化，自动清空时间
const handleChannelChange = (val) => {
  if (val !== '2') {
    form.value.reserveTime = undefined
  }
}

// 限制只能预约今天及以后的日期（禁用今天之前的日期）
const disabledDate = (time) => {
  return time.getTime() < Date.now() - 8.64e7 
}

/** 提交表单 */
function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (valid) {
      loading.value = true
      // 提交前，根据业务代码自动填充后台需要的“服务名称”
      const nameMap = {
        'OPEN_I_ACCOUNT': '开立一类户',
        'OPEN_II_ACCOUNT': '开立二类户',
        'RESET_PASSWORD': '账户密码重置',
        'LARGE_CASH': '大额取现预约'
      }
      form.value.serviceName = nameMap[form.value.serviceCode] || '未知业务'
      
      addReservation(form.value).then((response) => {
        loading.value = false
        proxy.$modal.msgSuccess("预约成功，请等待后续处理")
        formRef.value.resetFields() // 提交成功后重置表单
      }).catch(() => {
        loading.value = false
      })
    }
  })
}
</script>

<style scoped>
.reservation-page {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f0f2f5;
  min-height: 100vh;
  padding: 20px;
}
.form-card {
  width: 100%;
  max-width: 600px;
  padding: 40px;
  border-radius: 8px;
}
.form-header {
  text-align: center;
  margin-bottom: 20px;
}
.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #1f2f3d;
  margin-bottom: 8px;
}
.page-subtitle {
  font-size: 14px;
  color: #8c98a4;
}
</style>