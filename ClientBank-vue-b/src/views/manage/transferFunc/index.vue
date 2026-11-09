<template>
  <div class="transfer-container">
    <el-card header="对外转账" shadow="hover" class="form-card">
      <el-form :model="transferForm" :rules="rules" ref="formRef" label-width="120px" size="default">
        <el-form-item label="转出账户：" prop="from_account_id">
          <el-select v-model="transferForm.from_account_id" placeholder="请选择转出账户" style="width: 100%;"
            @focus="loadFromAccounts" :loading="fromAccountLoading">
            <el-option v-for="item in fromAccountOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="转入账户：" prop="to_account_id">
          <el-input v-model="transferForm.to_account_id" placeholder="请输入转入账户账号" style="width: 100%;"
            @blur="handleToAccountBlur">
            <template #append>
              <el-button :icon="Refresh" @click="fetchToAccountUser" :loading="loading" />
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="转入对象:" class="no-margin" prop="to_account_name">
          <el-input v-model="transferForm.to_account_name" disabled placeholder="输入卡号后自动获取，或点击右侧刷新按钮"
            style="width: 100%;" />
        </el-form-item>
        <el-form-item label="转账金额：" prop="amount">
          <el-input v-model="transferForm.amount" placeholder="请输入转账金额">
            <template #append>元</template>
          </el-input>
        </el-form-item>
        <el-form-item label="转账说明：">
          <el-input v-model="transferForm.remark" type="textarea" :rows="3" placeholder="请输入转账备注说明" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm" :loading="submitLoading">立即转账</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue';
import { Refresh } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';
import { getRealNameByCardNum, getBankCardList, addTransferRecord } from '@/api/manage/TransferRecord';
import { getUserProfile } from '@/api/system/user';

const formRef = ref(null);
const loading = ref(false);
const submitLoading = ref(false);
const currentUserId = ref('');

const transferForm = reactive({
  from_account_id: '',
  to_account_id: '',
  to_account_name: '',
  amount: '',
  remark: ''
});

const fromAccountOptions = ref([]);
const fromAccountLoading = ref(false);
const toAccountDetail = ref(null);
const lastVerifiedCard = ref('');

onMounted(async () => {
  try {
    const userRes = await getUserProfile();
    currentUserId.value = userRes.data.userId;
  } catch (error) {
    ElMessage.error('获取用户信息失败，请刷新页面重试');
  }
});

const loadFromAccounts = async () => {
  if (fromAccountOptions.value.length > 0) return;
  if (!currentUserId.value) {
    ElMessage.warning('用户信息尚未加载完成，请稍后再试');
    return;
  }
  fromAccountLoading.value = true;
  try {
    const res = await getBankCardList(currentUserId.value);
    if (res.code === 200) {
      fromAccountOptions.value = res.from_account_ids.map(card => ({
        label: card,
        value: card
      }));
    } else {
      ElMessage.error(res.msg || '获取账户列表失败');
    }
  } catch (error) {
    ElMessage.error('网络请求异常，请稍后重试');
  } finally {
    fromAccountLoading.value = false;
  }
};

const rules = reactive({
  from_account_id: [{ required: true, message: '请选择转出账户', trigger: 'change' }],
  to_account_id: [
    { required: true, message: '请输入转入账户', trigger: 'blur' }
  ],
  amount: [
    { required: true, message: '请输入转账金额', trigger: 'blur' },
    {
      pattern: /^(?:[1-9]\d*(?:\.\d{1,2})?|0\.\d{1,2})$/,
      message: '请输入大于0的金额，最多保留两位小数',
      trigger: 'blur'
    }
  ]
});

const handleToAccountBlur = () => {
  const cardNum = transferForm.to_account_id?.trim();
  if (!cardNum) {
    transferForm.to_account_name = '';
    lastVerifiedCard.value = '';
    return;
  }
  if (cardNum === lastVerifiedCard.value && transferForm.to_account_name) return;
  fetchToAccountUser();
};

const fetchToAccountUser = async () => {
  const cardNum = transferForm.to_account_id?.trim();
  if (!cardNum) {
    ElMessage.warning('请先输入转入账户账号');
    transferForm.to_account_name = '';
    lastVerifiedCard.value = '';
    return;
  }
  loading.value = true;
  try {
    const res = await getRealNameByCardNum(cardNum);
    // console.log("res："+res.realName+"  " +res.userId);
    if (res && (res.code === 200 || res.code === '200')) {
      transferForm.to_account_name = res.realName || '';
      toAccountDetail.value = res.userId || null; 
      lastVerifiedCard.value = cardNum;
      ElMessage.success('获取用户名称成功');
    } else {
      transferForm.to_account_name = '';
      lastVerifiedCard.value = '';
      toAccountDetail.value = null;
      ElMessage.error((res && res.msg) || '未找到该账户对应的用户信息');
    }
  } catch (error) {
    console.error(error); // 打印出真正的错误
    transferForm.to_account_name = '';
    lastVerifiedCard.value = '';
  } finally {
    loading.value = false;
  }
};

const submitForm = async () => {
  if (!formRef.value) return;
  if (transferForm.from_account_id === transferForm.to_account_id) {
    ElMessage.warning('转出与转入账户不能相同');
    return;
  }

  try {
    await formRef.value.validate();
  } catch (invalidFields) {
    ElMessage.warning('请检查表单填写是否正确');
    console.warn('表单校验未通过:', invalidFields);
    return;
  }

  if (!currentUserId.value) {
    ElMessage.error('用户信息未加载，无法转账');
    return;
  }

  // 如果获取了转入账户名字，却没有获取到详细数据（比如刷新了页面或接口报错），阻止提交
  if (transferForm.to_account_name && !toAccountDetail.value) {
    ElMessage.warning('请重新点击右侧刷新按钮，获取转入账户的详细信息');
    return;
  }

  submitLoading.value = true;
  try {
    const submitData = {
      fromUserId: currentUserId.value,
      fromAccountId: transferForm.from_account_id,
      toAccountId: transferForm.to_account_id,
      toUserId: toAccountDetail.value,
      amount: transferForm.amount,
      remark: transferForm.remark
    };

    console.log('正在向后端提交数据：', JSON.stringify(submitData));
    const res = await addTransferRecord(submitData);

    if (res.code === 200) {
      ElMessage.success('转账请求已发起，请等待处理！');
      resetForm();
    } else {
      ElMessage.error(res.msg || '转账未完成，请核对收款账户与金额后重试');
    }
  } catch (error) {
    ElMessage.warning(error?.response?.data?.msg || '网络异常，转账失败，请稍后重试');
  } finally {
    submitLoading.value = false;
  }
};

const resetForm = () => {
  formRef.value?.resetFields();
  transferForm.to_account_name = '';
  fromAccountOptions.value = [];
  lastVerifiedCard.value = '';
  transferForm.remark = '';
};
</script>

<style scoped>
.transfer-container {
  padding: 20px;
}

.form-card {
  max-width: 700px;
  margin: 0 auto;
}

.no-margin {
  margin-bottom: 18px;
}
</style>