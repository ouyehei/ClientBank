<template>
  <div class="app-container" style="width: 90%; margin: 0 auto; margin-top: 20px;">
    <!-- 顶部操作栏 -->
    <div style="margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
      <h2 style="margin: 0; color: #303133;">信用借贷与还款</h2>
      <div>
        <el-select v-model="transferForm.accountId" placeholder="切换银行卡" style="width: 220px; margin-right: 15px;"
          :loading="bankCardLoading">
          <el-option v-for="item in bankCardList" :key="item" :label="item" :value="item" />
        </el-select>
        <el-button type="primary" size="large" @click="openDrawer" icon="Plus">
          申请信用借款
        </el-button>
      </div>
    </div>

    <!-- 数据表格卡片 -->
    <el-card shadow="hover">
      <el-table :data="displayRecords" v-loading="tableLoading" border stripe style="width: 100%" empty-text="暂无借还款记录">
        <el-table-column prop="id" label="借据编号" min-width="160" show-overflow-tooltip />

        <el-table-column label="借款金额" width="140" align="right">
          <template #default="{ row }">
            <span style="color: #F56C6C; font-weight: bold;">
              ¥ {{ Math.abs(row.amount).toFixed(2) }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="到期应付利息" width="140" align="right">
          <template #default="{ row }">
            <span style="color: #E6A23C;">
              ¥ {{ Number(row.accumulatedInterest || 0).toFixed(2) }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 0 ? 'danger' : 'success'" size="small">
              {{ row.status === 0 ? '未结清' : '已结清' }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="createTime" label="借款时间" min-width="180" />
        <el-table-column prop="dueDate" label="到期日" min-width="180">
          <template #default="{ row }">
            <span>{{ formatDueDate(row.dueDate) }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="120" align="center" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.status === 0" type="primary" link size="small" @click="openRepayDialog(row)">
              还款
            </el-button>
            <span v-else style="color: #909399; font-size: 12px;">已结清</span>
          </template>
        </el-table-column>
      </el-table>

      <div v-if="recordList.length > 10" style="margin-top: 15px; text-align: right; color: #909399; font-size: 13px;">
        仅展示最近 10 条记录，更多记录请前往后台查看。
      </div>
    </el-card>

    <!-- 右侧抽屉：申请借款表单 -->
    <el-drawer v-model="drawerVisible" title="信用借贷申请" size="450px" @close="resetDrawer">
      <el-form ref="transferFormRef" :model="applyForm" :rules="rules" label-width="100px">
        <el-form-item label="银行卡ID" prop="accountId">
          <el-select v-model="applyForm.accountId" placeholder="请选择银行卡" clearable filterable :loading="bankCardLoading"
            style="width: 100%">
            <el-option v-for="item in bankCardList" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>

        <el-form-item label="借款金额" prop="amount">
          <el-input v-model="applyForm.amount" placeholder="请输入借款金额" type="number" prefix-icon="Money" />
        </el-form-item>

        <el-form-item label="借款期限" prop="period">
          <el-radio-group v-model="applyForm.period" @change="handlePeriodChange">
            <el-radio value="1">1个月</el-radio>
            <el-radio value="3">3个月</el-radio>
            <el-radio value="6">6个月</el-radio>
            <el-radio value="12">1年</el-radio>
            <el-radio value="36">3年</el-radio>
          </el-radio-group>

          <div class="text-gray-500 text-xs mt-2" style="color: #606266; margin-top: 10px;">
            预计到期日: {{ formatDate(applyForm.dueDate) }}
            <el-tooltip :content="interestTip" placement="top" effect="dark">
              <el-icon style="margin-left: 4px; cursor: pointer; vertical-align: middle; color: #409eff;">
                <QuestionFilled />
              </el-icon>
            </el-tooltip>
          </div>
        </el-form-item>

        <el-form-item style="margin-top: 30px;">
          <el-button type="primary" @click="handleSubmit" style="width: 100%; padding: 12px;">确认借款</el-button>
        </el-form-item>
      </el-form>
    </el-drawer>

    <!-- 还款弹窗 -->
    <el-dialog v-model="repayDialogVisible" title="归还借款" width="420px" @close="resetRepayForm">
      <el-form ref="repayFormRef" :model="repayForm" :rules="repayRules" label-width="100px">
        <el-form-item label="借据编号">
          <span>{{ repayForm.loanId }}</span>
        </el-form-item>
        <el-form-item label="应还总额">
          <span style="color: #f56c6c; font-weight: bold;">¥ {{ repayForm.totalDebt }}</span>
        </el-form-item>
        <el-form-item label="还款金额" prop="repayAmount">
          <el-input v-model="repayForm.repayAmount" type="number" placeholder="请输入还款金额" prefix-icon="Money" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="repayDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="repaySubmitting" @click="handleRepay">确认还款</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ElMessage } from 'element-plus';
import { Plus, QuestionFilled, Money } from '@element-plus/icons-vue';
import { getBankCardList } from '@/api/manage/TransferRecord';
import { addCredit, listUnpaidLoans, getDebtSummary, repayLoan } from '@/api/manage/loan';
import { getUserProfile } from '@/api/system/user';
import { reactive, ref, computed, watch, onMounted, defineOptions } from 'vue';

// 如果你在路由里配置了 name，取消下面这行的注释，并改成你的路由名
// defineOptions({ name: 'ManageLoan' });

const transferFormRef = ref(null);
const repayFormRef = ref(null);
const bankCardList = ref([]);
const bankCardLoading = ref(false);
const recordList = ref([]);
const tableLoading = ref(false);
const drawerVisible = ref(false);

// 顶部切换卡号
const transferForm = reactive({
  accountId: ''
});

// 抽屉里的表单
const applyForm = reactive({
  accountId: '',
  amount: null,
  period: '1',
  dueDate: null
});

const repayDialogVisible = ref(false);
const repaySubmitting = ref(false);
const repayForm = reactive({
  loanId: '',
  totalDebt: '0.00',
  repayAmount: null
});

const displayRecords = computed(() => {
  return recordList.value.slice(0, 10);
});

const openDrawer = () => {
  applyForm.accountId = transferForm.accountId;
  applyForm.period = '1';
  handlePeriodChange('1');
  drawerVisible.value = true;
};

const fetchBankCards = async () => {
  try {
    const userRes = await getUserProfile();
    const userId = userRes.data.userId;
    if (!userId) return;

    bankCardLoading.value = true;
    const res = await getBankCardList(userId);
    const list = res?.from_account_ids || [];
    bankCardList.value = Array.isArray(list) ? list : [];

    if (bankCardList.value.length > 0) {
      transferForm.accountId = bankCardList.value[0];
      fetchAccountRecords(transferForm.accountId);
    }
  } catch (err) {
    console.error('获取银行卡列表失败:', err);
    ElMessage.error('获取银行卡列表失败，请刷新重试');
  } finally {
    bankCardLoading.value = false;
  }
};

const interestTip = computed(() => {
  const amount = Number(applyForm.amount);
  const dueDate = applyForm.dueDate;
  if (!amount || !dueDate) return '请先输入借款金额并选择期限';

  const dueTimestamp = new Date(dueDate).getTime();
  const days = Math.ceil((dueTimestamp - Date.now()) / (1000 * 60 * 60 * 24));
  if (days <= 0) return '到期日已过';

  const interest = (amount * 0.001 * days).toFixed(2);
  return `借款金额: ${amount} 元 | 日利率: 0.1% | 共 ${days} 天 | 预计到期总利息: ${interest} 元`;
});

const fetchAccountRecords = async (accountId) => {
  if (!accountId) {
    recordList.value = [];
    return;
  }
  tableLoading.value = true;
  try {
    const [listRes] = await Promise.all([
      listUnpaidLoans(accountId),
      getDebtSummary(accountId).catch(() => null)
    ]);
    recordList.value = listRes.data || [];
  } catch (err) {
    console.error('获取借还款记录失败:', err);
    recordList.value = [];
  } finally {
    tableLoading.value = false;
  }
};

let isFirstLoad = true;
watch(() => transferForm.accountId, (newVal, oldVal) => {
  if (isFirstLoad) {
    isFirstLoad = false;
    return;
  }
  if (newVal && newVal !== oldVal) {
    fetchAccountRecords(newVal);
  }
});

const rules = {
  accountId: [{ required: true, message: '请选择银行卡', trigger: 'change' }],
  amount: [
    { required: true, message: '请输入借款金额', trigger: 'blur' },
    { validator: (_, v, cb) => (Number(v) > 0 ? cb() : cb(new Error('金额必须大于 0'))), trigger: 'blur' }
  ]
};

const repayRules = {
  repayAmount: [
    { required: true, message: '请输入还款金额', trigger: 'blur' },
    {
      validator: (_, v, cb) => {
        const num = Number(v);
        if (!(num > 0)) return cb(new Error('还款金额必须大于 0'));
        if (num > Number(repayForm.totalDebt)) return cb(new Error('还款金额不能超过应还总额'));
        cb();
      },
      trigger: 'blur'
    }
  ]
};

const formatDate = (timestamp) => {
  if (!dateStrOrTimestamp) return '请选择期限';

  // 如果是字符串格式（如 "2029-10-30 15:32:46"），直接返回
  if (typeof dateStrOrTimestamp === 'string') {
    return dateStrOrTimestamp;
  }
  const d = new Date(dateStrOrTimestamp);
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
};

const handlePeriodChange = (val) => {
  const dateObj = new Date();
  if (val === '12' || val === '36') {
    dateObj.setFullYear(dateObj.getFullYear() + parseInt(val) / 12);
  } else {
    dateObj.setMonth(dateObj.getMonth() + parseInt(val));
  }
  const p = (n) => String(n).padStart(2, '0');
  applyForm.dueDate = `${dateObj.getFullYear()}-${p(dateObj.getMonth() + 1)}-${p(dateObj.getDate())} ${p(dateObj.getHours())}:${p(dateObj.getMinutes())}:${p(dateObj.getSeconds())}`;
};
const formatDueDate = (dateStr) => {
  if (!dateStr) return '-';
  // 避免时区问题，直接渲染后端返回的标准时间字符串
  return dateStr.replace(' ', 'T');
};
const handleSubmit = () => {
  if (!transferFormRef.value) return;
  transferFormRef.value.validate(async (valid) => {
    if (!valid) return;
    try {
      const params = {
        accountId: applyForm.accountId,
        transactionType: 1,
        amount: Number(applyForm.amount),
        dueDate: applyForm.dueDate ? formatDate(applyForm.dueDate) : null
      };
      await addCredit(params);
      ElMessage.success('借款成功');

      await fetchAccountRecords(transferForm.accountId);

      drawerVisible.value = false;
      resetDrawer();
    } catch (err) {
      ElMessage.error(err.msg || '操作失败，请稍后重试');
    }
  });
};

const resetDrawer = () => {
  if (transferFormRef.value) {
    transferFormRef.value.resetFields();
  }
  applyForm.period = '1';
  handlePeriodChange('1');
};

const openRepayDialog = (row) => {
  const principal = Math.abs(Number(row.amount) || 0);
  const interest = Number(row.accumulatedInterest) || 0;
  const total = (principal + interest).toFixed(2);

  repayForm.loanId = row.id;
  repayForm.totalDebt = total;
  repayForm.repayAmount = total;
  repayDialogVisible.value = true;
};

const resetRepayForm = () => {
  repayFormRef.value?.resetFields();
  repayForm.loanId = '';
  repayForm.totalDebt = '0.00';
  repayForm.repayAmount = null;
};

const handleRepay = () => {
  if (!repayFormRef.value) return;
  repayFormRef.value.validate(async (valid) => {
    if (!valid) return;
    repaySubmitting.value = true;
    try {
      await repayLoan({
        loanId: repayForm.loanId,
        repayAmount: Number(repayForm.repayAmount)
      });
      ElMessage.success('还款成功');
      repayDialogVisible.value = false;

      await fetchAccountRecords(transferForm.accountId);
    } catch (err) {
      ElMessage.error(err.msg || '还款失败，请稍后重试');
    } finally {
      repaySubmitting.value = false;
    }
  });
};

onMounted(() => {
  fetchBankCards();
});
</script>