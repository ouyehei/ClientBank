<template>
  <div class="app-container">
    <!-- 筛选表单 -->
    <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px">
      <el-form-item label="卡号" prop="cardNumber">
        <el-select v-model="queryParams.cardNumber" placeholder="请选择卡号" clearable filterable :loading="cardLoading"
          style="width: 240px" @Change="handleQuery">
          <el-option v-for="item in cardOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        <el-button type="warning" plain icon="Sort" @click="handleSortByNewest">最新</el-button>
      </el-form-item>
    </el-form>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="transferList" border stripe>
      <el-table-column label="转账单号" align="center" prop="transferNo" width="200" />
      <el-table-column label="转出账户" align="center" prop="fromAccountId" width="180" />
      <el-table-column label="转入账户" align="center" prop="toAccountId" width="180" />
      <el-table-column label="转账金额" align="center" prop="amount" width="120">
        <template #default="scope">
          <span style="color: #F56C6C; font-weight: bold">¥{{ scope.row.amount }}</span>
        </template>
      </el-table-column>
      <el-table-column label="手续费" align="center" prop="fee" width="100" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template #default="scope">
          <el-tag v-if="scope.row.status === 1" type="success" effect="dark">成功</el-tag>
          <el-tag v-else type="danger">失败</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180" sortable />                     
      <el-table-column label="备注" align="center" prop="remark" min-width="150" show-overflow-tooltip>
        <template #default="scope">
          <span v-if="scope.row.remark">{{ scope.row.remark }}</span>
          <span v-else style="color: #999">-</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup name="TransferRecord">
import { ref, reactive, onMounted } from "vue"
import request from "@/utils/request"
import { getUserProfile } from "@/api/system/user"
import { getBankCardList } from '@/api/manage/TransferRecord';

const { proxy } = getCurrentInstance()

const loading = ref(false)
const transferList = ref([])
let allData = []
let currentUserId = null
const cardOptions = ref([])
const cardLoading = ref(false)

const queryParams = reactive({
  cardNumber: null,
  accountId: null
})
/** 获取卡号列表并渲染到下拉框 */
async function loadCardOptions() {
  if (cardOptions.value.length > 0) return
  try {
    const userRes = await getUserProfile()
    currentUserId = userRes.data.userId
    const res = await getBankCardList(currentUserId)
    if (res.code === 200) {
      cardOptions.value = (res.from_account_ids || []).map(card => ({
        label: card,
        value: card
      }))
    }
  } catch (e) {
    console.error(e)
  }
}

/** 查询转账记录 */
async function getList() {
  loading.value = true

  if (!currentUserId) {
    try {
      const userRes = await getUserProfile()
      currentUserId = userRes.data.userId
    } catch (error) {
      proxy.$modal.msgError("获取当前用户信息失败")
      loading.value = false
      return
    }
  }

  request({
    url: `/manage/TransferRecord/list/${currentUserId}`,
    method: "get"
  })
    .then((response) => {
      allData = response.data || []
      handleQuery()
      loading.value = false
    })
    .catch(() => {
      loading.value = false
    })
}

/** 筛选渲染 */
function handleQuery() {
  let list = [...allData]

  if (queryParams.cardNumber) {
    const q = queryParams.cardNumber.toString()
    list = list.filter(
      (item) =>
        String(item.fromAccountId || "").includes(q) ||
        String(item.toAccountId || "").includes(q)
    )
  }

  if (queryParams.accountId) {
    const q = queryParams.accountId.toString()
    list = list.filter(
      (item) =>
        String(item.fromAccountId || "").includes(q) ||
        String(item.toAccountId || "").includes(q)
    )
  }

  transferList.value = list
}

/** 重置 */
function resetQuery() {
  queryParams.cardNumber = null
  queryParams.accountId = null
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 最新排序 */
function handleSortByNewest() {
  transferList.value.sort(
    (a, b) => new Date(b.createTime) - new Date(a.createTime)
  )
  proxy.$modal.msgSuccess("已按最新时间排序")
}

onMounted(() => {
  getList()
  loadCardOptions()
})
</script>