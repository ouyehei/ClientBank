<template>
  <div class="login">
    <!-- 背景装饰 -->
    <div class="login-bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>

    <div class="login-container">
      <!-- 左侧欢迎区 -->
      <div class="login-welcome">
        <h1 class="welcome-title">欢迎使用</h1>
        <p class="welcome-subtitle">{{ title }}</p>
        <p class="welcome-desc">安全 · 高效 · 便捷</p>
      </div>

      <!-- 右侧登录表单 -->
      <div class="login-card">
        <h2 class="card-title">账号登录</h2>
        <p class="card-subtitle">请输入您的账号和密码</p>

        <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              type="text"
              size="large"
              auto-complete="off"
              placeholder="请输入账号"
            >
              <template #prefix>
                <svg-icon icon-class="user" class="input-icon" />
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              size="large"
              auto-complete="off"
              placeholder="请输入密码"
              @keyup.enter="handleLogin"
            >
              <template #prefix>
                <svg-icon icon-class="password" class="input-icon" />
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="code" v-if="captchaEnabled">
            <div class="captcha-row">
              <el-input
                v-model="loginForm.code"
                size="large"
                auto-complete="off"
                placeholder="验证码"
                class="captcha-input"
                @keyup.enter="handleLogin"
              >
                <template #prefix>
                  <svg-icon icon-class="validCode" class="input-icon" />
                </template>
              </el-input>
              <img :src="codeUrl" @click="getCode" class="captcha-img" />
            </div>
          </el-form-item>

          <div class="form-options">
            <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
            <router-link v-if="register" class="link-type" :to="'/register'">立即注册</router-link>
          </div>

          <el-form-item>
            <el-button
              :loading="loading"
              size="large"
              type="primary"
              class="login-btn"
              @click.prevent="handleLogin"
            >
              <span v-if="!loading">登 录</span>
              <span v-else>登 录 中...</span>
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from "@/utils/jsencrypt"
import useUserStore from '@/store/modules/user'
import defaultSettings from '@/settings'

const title = import.meta.env.VITE_APP_TITLE
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { proxy } = getCurrentInstance()

const loginForm = ref({
  username: "admin",
  password: "admin123",
  rememberMe: false,
  code: "",
  uuid: ""
})

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
}

const codeUrl = ref("")
const loading = ref(false)
const captchaEnabled = ref(true)
const register = ref(false)
const redirect = ref(undefined)

watch(route, (newRoute) => {
  redirect.value = newRoute.query && newRoute.query.redirect
}, { immediate: true })

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 })
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 })
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 })
      } else {
        Cookies.remove("username")
        Cookies.remove("password")
        Cookies.remove("rememberMe")
      }
      userStore.login(loginForm.value).then(() => {
        const query = route.query
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur]
          }
          return acc
        }, {})
        router.push({ path: redirect.value || "/", query: otherQueryParams })
      }).catch(() => {
        loading.value = false
        if (captchaEnabled.value) {
          getCode()
        }
      })
    }
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img
      loginForm.value.uuid = res.uuid
    }
  })
}

function getCookie() {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

getCode()
getCookie()
</script>

<style lang="scss" scoped>
.login {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #1e3a5f 0%, #2d6a9f 100%);
  overflow: hidden;
}

/* 背景装饰圆 */
.login-bg-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.08);
}

.circle-1 {
  width: 400px;
  height: 400px;
  top: -100px;
  right: -100px;
}

.circle-2 {
  width: 300px;
  height: 300px;
  bottom: -80px;
  left: -80px;
}

.circle-3 {
  width: 200px;
  height: 200px;
  top: 50%;
  left: 10%;
  background: rgba(255, 255, 255, 0.05);
}

/* 主容器 */
.login-container {
  display: flex;
  align-items: stretch;
  width: 860px;
  min-height: 480px;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  z-index: 1;
}

/* 左侧欢迎区 */
.login-welcome {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 40px;
  background: linear-gradient(135deg, rgba(30, 58, 95, 0.92), rgba(45, 106, 159, 0.92));
  color: #fff;
}

.welcome-title {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 12px;
  letter-spacing: 2px;
}

.welcome-subtitle {
  font-size: 20px;
  font-weight: 500;
  margin-bottom: 20px;
  opacity: 0.9;
}

.welcome-desc {
  font-size: 14px;
  opacity: 0.7;
  letter-spacing: 4px;
}

/* 右侧登录卡片 */
.login-card {
  flex: 1;
  background: #fff;
  padding: 48px 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.card-title {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a2e;
  margin-bottom: 6px;
}

.card-subtitle {
  font-size: 14px;
  color: #999;
  margin-bottom: 32px;
}

/* 表单样式 */
.login-form {
  .el-input {
    height: 46px;

    :deep(.el-input__wrapper) {
      border-radius: 8px;
      box-shadow: 0 0 0 1px #e0e0e0 inset;
      transition: box-shadow 0.3s;

      &:hover {
        box-shadow: 0 0 0 1px #2d6a9f inset;
      }
    }

    :deep(.el-input__wrapper.is-focus) {
      box-shadow: 0 0 0 1px #2d6a9f inset;
    }
  }

  .input-icon {
    color: #999;
    font-size: 16px;
  }
}

/* 验证码行 */
.captcha-row {
  display: flex;
  gap: 12px;
  align-items: center;

  .captcha-input {
    flex: 1;
  }

  .captcha-img {
    width: 110px;
    height: 46px;
    border-radius: 8px;
    cursor: pointer;
    border: 1px solid #e0e0e0;
    transition: opacity 0.2s;

    &:hover {
      opacity: 0.85;
    }
  }
}

/* 选项行 */
.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  font-size: 14px;

  .link-type {
    color: #2d6a9f;
    text-decoration: none;
    transition: color 0.2s;

    &:hover {
      color: #1e3a5f;
    }
  }
}

/* 登录按钮 */
.login-btn {
  width: 100%;
  height: 46px;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 4px;
  border-radius: 8px;
  background: linear-gradient(135deg, #2d6a9f, #1e3a5f);
  border: none;
  transition: transform 0.2s, box-shadow 0.2s;

  &:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(45, 106, 159, 0.4);
  }

  &:active {
    transform: translateY(0);
  }
}

/* 深色模式适配 */
html.dark {
  .login {
    background: linear-gradient(135deg, #0f1f33 0%, #1a3350 100%);
  }

  .login-card {
    background: #1e2a3a;
  }

  .card-title {
    color: #e0e0e0;
  }

  .card-subtitle {
    color: #888;
  }

  .login-form {
    .el-input :deep(.el-input__wrapper) {
      background: #253545;
      box-shadow: 0 0 0 1px #3a4f63 inset;
    }
  }

  .captcha-img {
    border-color: #3a4f63;
  }
}

/* 响应式 */
@media screen and (max-width: 900px) {
  .login-container {
    width: 90%;
    flex-direction: column;
  }

  .login-welcome {
    padding: 30px 20px;
  }

  .welcome-title {
    font-size: 24px;
  }

  .login-card {
    padding: 32px 24px;
  }
}
</style>