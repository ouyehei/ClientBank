<template>
  <div class="app-container profile-edit-container">
    <!-- 顶部返回导航 -->
    <div class="header-nav">
      <el-button link type="primary" @click="goBack">
        <el-icon><ArrowLeft /></el-icon> 返回自助服务大厅
      </el-button>
    </div>

    <el-row :gutter="20">
      <!-- 左侧：基本信息修改 -->
      <el-col :span="16">
        <el-card shadow="hover" class="info-card">
          <template #header>
            <div class="card-header">
              <span>👤 个人基本资料</span>
              <span class="tip-text">* 带星号项为必填</span>
            </div>
          </template>
          
          <el-form ref="infoFormRef" :model="form" :rules="rules" label-width="110px" size="large">
            <el-form-item label="用户昵称" prop="nickName">
              <el-input v-model="form.nickName" placeholder="请输入昵称" />
            </el-form-item>
            
            <!-- ✅ 补充的字段：真实姓名 -->
            <el-form-item label="真实姓名">
              <el-input v-model="form.realName" placeholder="请输入真实姓名" />
            </el-form-item>

            <!-- ✅ 补充的字段：身份证号 -->
            <el-form-item label="身份证号">
              <el-input v-model="form.idCardNumber" placeholder="请输入身份证号" />
            </el-form-item>

            <!-- ✅ 补充的字段：居住地址 -->
            <el-form-item label="居住地址">
              <el-input v-model="form.residenceAddress" placeholder="请输入居住地址" />
            </el-form-item>
            
            <el-form-item label="手机号码" prop="phonenumber">
              <el-input v-model="form.phonenumber" placeholder="请输入手机号" />
            </el-form-item>
            
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="form.email" placeholder="请输入邮箱" />
            </el-form-item>
            
            <!-- <el-form-item label="性别">
              <el-radio-group v-model="form.sex">
                <el-radio :value="0">男</el-radio>
                <el-radio :value="1">女</el-radio>
              </el-radio-group>
            </el-form-item> -->
          </el-form>
        </el-card>
      </el-col>

      <!-- 右侧：头像 & 密码修改 -->
      <el-col :span="8">
        <!-- 头像上传卡片 -->
        <el-card shadow="hover" class="side-card" style="margin-bottom: 20px;">
          <template #header>
            <div class="card-header"><span>🎨 头像设置</span></div>
          </template>
          <div class="avatar-wrapper">
            <user-avatar @update-success="handleAvatarSuccess" />
            <p class="text-muted mt-2">支持 JPG/PNG，建议正方形</p>
          </div>
        </el-card>

        <el-card shadow="hover" class="side-card">
          <template #header>
            <div class="card-header"><span>🔒 密码安全</span></div>
          </template>

          <div class="password-wrapper">
            <el-form ref="pwdFormRef" :model="pwdForm" :rules="pwdRules" label-width="0">
              <el-form-item prop="oldPassword">
                <el-input v-model="pwdForm.oldPassword" type="password" placeholder="当前密码" show-password />
              </el-form-item>
              <el-form-item prop="newPassword">
                <el-input v-model="pwdForm.newPassword" type="password" placeholder="新密码" show-password />
              </el-form-item>
              <el-form-item prop="confirmPassword">
                <el-input v-model="pwdForm.confirmPassword" type="password" placeholder="确认新密码" show-password />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <div style="text-align: right; margin-top: 20px;">
          <el-button size="large" type="default" @click="resetAll">重置</el-button>
          <el-button size="large" type="primary" :loading="loading" @click="submitAll">一键保存</el-button>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="ProfileEdit">
import { reactive, ref, onMounted, getCurrentInstance } from "vue";
import { useRouter } from "vue-router";
import { getUserProfile } from "@/api/system/user";
import { getCustomerExtByUserId } from "@/api/manage/customerExt";
import {updateUserProfile, updateUserPwd } from "@/api/system/user";
import UserAvatar from "@/views/system/user/profile/userAvatar.vue";

const router = useRouter();
const { proxy } = getCurrentInstance();
const infoFormRef = ref(null);
const pwdFormRef = ref(null);

// --- 数据定义 ---
const loading = ref(false);

// 基础信息表单
const form = reactive({
  userId: undefined,
  nickName: undefined,
  realName: undefined,
  idCardNumber: undefined,
  residenceAddress: undefined,
  phonenumber: undefined,
  email: undefined,
  sex: undefined,
});

// 基础信息校验
const rules = {
  nickName: [{ required: true, message: "用户昵称不能为空", trigger: "blur" }],
  email: [{ type: "email", message: "请输入正确的邮箱地址", trigger: ["blur", "change"] }],
  phonenumber: [{ pattern: /^1[3-9]\d{9}$/, message: "请输入正确的手机号码", trigger: "blur" }],
};

// 密码修改表单
const pwdForm = reactive({ oldPassword: "", newPassword: "", confirmPassword: "" });

// 密码校验
const validateConfirmPassword = (rule, value, callback) => {
  if (value !== pwdForm.newPassword) {
    callback(new Error("两次输入的密码不一致"));
  } else {
    callback();
  }
};

const pwdRules = {
  oldPassword: [{ required: true, message: "旧密码必须填写", trigger: "blur" }],
  newPassword: [
    { required: true, message: "新密码必须填写", trigger: "blur" },
    { min: 6, max: 20, message: "长度在 6 到 20 个字符", trigger: "blur" },
  ],
  confirmPassword: [
    { required: true, message: "确认密码必须填写", trigger: "blur" },
    { validator: validateConfirmPassword, trigger: "blur" },
  ],
};

// --- 初始化获取信息 ---
async function getInfo() {
  const userRes = await getUserProfile();
  const userId = userRes.data.userId;

  if (userId) {
    getCustomerExtByUserId(userId).then(response => {
      // 将后端返回的完整数据（含扩展字段）回显到表单
      Object.assign(form, response.data);
    });
  }
}

onMounted(() => {
  getInfo();
});

// --- 核心业务逻辑：合并提交 ---
function submitAll() {
  // 1. 校验基础信息
  infoFormRef.value.validate(valid => {
    if (!valid) return;

    // 2. 校验密码表单（只有当用户输入了密码字段时才校验）
    const isPwdModified = pwdForm.oldPassword || pwdForm.newPassword || pwdForm.confirmPassword;
    if (isPwdModified) {
      pwdFormRef.value.validate(validPwd => {
        if (validPwd) {
          executeSubmit(isPwdModified);
        }
      });
    } else {
      executeSubmit(false);
    }
  });
}

function executeSubmit(isPwdModified) {
  loading.value = true;
  
  const promises = [];
  
  // 提交基础信息
  promises.push(updateUserProfile(form));
  
  // 如果有修改密码，则提交密码
  if (isPwdModified) {
    promises.push(updateUserPwd(pwdForm.oldPassword, pwdForm.newPassword));
  }

  // 使用 Promise.all 并行提交，全部成功后反馈
  Promise.all(promises)
    .then(() => {
      proxy.$modal.msgSuccess("保存成功");
      resetAll();
    })
    .catch((error) => {
      proxy.$modal.msgError("保存失败");
    })
    .finally(() => {
      loading.value = false;
    });
}

// --- 辅助方法 ---
function resetAll() {
  getInfo(); // 重置基础信息
  pwdForm.oldPassword = "";
  pwdForm.newPassword = "";
  pwdForm.confirmPassword = ""; // 清空密码输入
  infoFormRef.value.clearValidate();
  pwdFormRef.value.clearValidate();
}

function handleAvatarSuccess() {
  getInfo(); // 头像修改成功后刷新数据
}

function goBack() {
  router.push("/manage/selfService");
}
</script>

<style lang="scss" scoped>
.profile-edit-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);

  .header-nav { margin-bottom: 15px; }
  .card-header { display: flex; justify-content: space-between; align-items: center; font-weight: bold; }
  .tip-text { font-size: 12px; color: #909399; font-weight: normal; }
  .info-card { border-radius: 8px; margin-bottom: 20px; }
  .side-card { border-radius: 8px; text-align: center; }
  .avatar-wrapper { padding: 20px 0; }
  .text-muted { color: #909399; font-size: 12px; margin-top: 10px; }
  .password-wrapper { padding: 10px 0; text-align: left; }
}
</style>  