<template>
  <div class="app-container personal-center" v-loading="loading">

    <!-- ====== 卡片1：个人客户基本信息 ====== -->
    <el-card class="box-card header-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span class="title">个人客户信息</span>
          <div>
            <!-- <el-button v-if="!isEdit" type="primary" plain @click="toggleEdit">编辑资料</el-button> -->
            <template>
              <el-button type="primary" @click="submitForm">保存修改</el-button>
              <el-button @click="cancelEdit">取消</el-button>
            </template>
          </div>
        </div>
      </template>

      <el-descriptions border :column="2" size="large"
        :label-style="{ width: '120px', fontWeight: 'bold', background: '#fafafa' }">
        <el-descriptions-item label="真实姓名">
          <span>{{ form.realName || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="用户昵称">
          <span>{{ form.nickName || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="用户账号">
          <span>{{ form.userName || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="证件号码">
          <span class="id-text">{{ form.idCardNumber || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="手机号码">
          <el-input v-if="isEdit" v-model="form.phonenumber" placeholder="请输入手机号" />
          <span v-else>{{ form.phonenumber || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="电子邮箱">
          <el-input v-if="isEdit" v-model="form.email" placeholder="请输入邮箱" />
          <span v-else>{{ form.email || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="居住地址" :span="2">
          <el-input v-if="isEdit" v-model="form.residenceAddress" type="textarea" placeholder="请输入居住地址" />
          <span v-else>{{ form.residenceAddress || '-' }}</span>
        </el-descriptions-item>

        <el-descriptions-item label="账户状态" :span="2">
          <el-tag v-if="form.accountStatus === '0'" type="success" effect="plain">正常</el-tag>
          <el-tag v-else type="danger" effect="plain">{{ form.accountStatus }}</el-tag>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>

    <!-- ====== 卡片2：我的银行账户（独立卡片，宽度拉满） ====== -->
    <el-card class="box-card account-card" shadow="never">
      <template #header>
        <div class="card-header">
          <span class="title">我的银行账户</span>
        </div>
      </template>

      <el-empty v-if="bankAccountList.length === 0" description="暂无关联银行账户" />

      <el-table v-else :data="bankAccountList" border stripe style="width: 100%">
        <el-table-column prop="cardNumber" label="银行卡号" width="240" class-name="card-no" />
        <el-table-column prop="accountType" label="账户类型" width="120" align="center">
          <template #default="scope">
            <el-tag size="small" :type="scope.row.accountType == '1' ? 'primary' : 'warning'">
              {{
                scope.row.accountType == '11' ? '储蓄一类卡'
                  : scope.row.accountType == '12' ? '储蓄二类卡'
                    : scope.row.accountType == '2' ? '信用卡'
              : scope.row.accountType
              }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="currency" label="币种" width="100" align="center" />

        <el-table-column prop="balance" label="当前余额" align="right" min-width="160">
          <template #default="scope">
            <span class="money">¥ {{ formatMoney(scope.row.balance) }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="creditLimit" label="信用额度" align="right" min-width="160">
          <template #default="scope">
            <span class="money">¥ {{ formatMoney(scope.row.creditLimit) }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="createTime" label="开户时间" width="180" align="center" />
      </el-table>
    </el-card>

  </div>
</template>

<script setup name="PersonalCustomerInfo">
import { getUserProfile } from "@/api/system/user";
import { getCustomerExtByUserId } from "@/api/manage/customerExt"; // 确保此接口指向 /manage/customerExt/list/
import { updateCustomerExt } from "@/api/manage/customerExt";

const { proxy } = getCurrentInstance();

const loading = ref(true);
const isEdit = ref(false);
const form = ref({});
const bankAccountList = ref([]);
const submitForm = async () => {
  if (!formRef.value) return;
  await formRef.value.validate((valid, fields) => {
    if (valid) {
      // 这里写你的保存接口逻辑
      // await updateCustomerInfo(form.value)
      ElMessage.success('保存成功');
    }
  });
};
const cancelEdit = () => {
  // 如果使用了 el-form，通常用来重置表单
  formRef.value?.resetFields();
  // 如果有个变量控制“是否在编辑状态”，在这里改回 false
  // isEditing.value = false;
};
/** 初始化获取数据 */
async function initData() {
  loading.value = true;
  try {
    // 1. 获取当前登录用户的 userId
    const userRes = await getUserProfile();
    const currentUserId = userRes.data.userId;
    const res = await getCustomerExtByUserId(currentUserId);

    if (res.code === 200 && res.data) {
      form.value = res.data;
      bankAccountList.value = res.data.bankAccountList || [];
    }
  } catch (error) {
    console.error("获取个人信息失败：", error);
  } finally {
    loading.value = false;
  }
}

/** 格式化金额（千分位） */
function formatMoney(value) {
  if (value === null || value === undefined || value === '') return '0.00';
  return Number(value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

// 页面挂载时获取数据
initData();
</script>

<style scoped lang="scss">
.personal-center {
  margin: 20px auto;
  padding: 0 20px;

  .box-card {
    margin-bottom: 20px;
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .title {
      font-size: 16px;
      font-weight: bold;
    }
  }

  .id-text {
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    letter-spacing: 1px;
  }

  .money {
    color: #f56c6c;
    font-weight: bold;
    font-family: Arial, sans-serif;
  }

  :deep(.card-no) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
  }
}
</style>