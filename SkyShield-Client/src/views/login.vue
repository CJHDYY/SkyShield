<template>
  <div class="login">
    <section class="login-visual" aria-hidden="true">
      <div class="orbital orbital-outer"></div>
      <div class="orbital orbital-inner"></div>
      <div class="shield-preview">
        <img :src="logoUrl" alt="" />
      </div>
    </section>

    <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
      <div class="brand">
        <img :src="logoUrl" alt="天穹之盾" class="brand-logo" />
        <h3 class="title">天穹之盾</h3>
      </div>

      <el-form-item prop="username">
        <el-input
          v-model="loginForm.username"
          type="text"
          size="large"
          auto-complete="off"
          placeholder="账号"
        >
          <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>

      <el-form-item prop="password">
        <el-input
          v-model="loginForm.password"
          type="password"
          size="large"
          auto-complete="off"
          placeholder="密码"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>

      <el-form-item prop="code" v-if="captchaEnabled">
        <el-input
          v-model="loginForm.code"
          size="large"
          auto-complete="off"
          placeholder="验证码"
          style="width: 63%"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode" class="login-code-img" />
        </div>
      </el-form-item>

      <el-checkbox v-model="loginForm.rememberMe" class="remember-me">记住密码</el-checkbox>

      <el-form-item style="width:100%;">
        <el-button
          :loading="loading"
          size="large"
          type="primary"
          class="login-button"
          @click.prevent="handleLogin"
        >
          <span v-if="!loading">登录</span>
          <span v-else>登录中...</span>
        </el-button>
        <div style="float: right;" v-if="register">
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>

    <div class="el-login-footer">
      <span>Copyright (c) 2024-2026 SkyShield. All Rights Reserved.</span>
    </div>
  </div>
</template>

<script setup>
import { getCodeImg } from "@/api/login";
import Cookies from "js-cookie";
import { encrypt, decrypt } from "@/utils/jsencrypt";
import useUserStore from '@/store/modules/user'
import logoUrl from '@/assets/logo/skyshield-logo.png'

const userStore = useUserStore()
const route = useRoute();
const router = useRouter();
const { proxy } = getCurrentInstance();

const loginForm = ref({
  username: "admin",
  password: "admin123",
  rememberMe: false,
  code: "",
  uuid: ""
});

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
};

const codeUrl = ref("");
const loading = ref(false);
const captchaEnabled = ref(true);
const register = ref(false);
const redirect = ref(undefined);

watch(route, (newRoute) => {
  redirect.value = newRoute.query && newRoute.query.redirect;
}, { immediate: true });

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true;
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 });
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 });
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 });
      } else {
        Cookies.remove("username");
        Cookies.remove("password");
        Cookies.remove("rememberMe");
      }
      userStore.login(loginForm.value).then(() => {
        const query = route.query;
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur];
          }
          return acc;
        }, {});
        router.push({ path: redirect.value || "/", query: otherQueryParams });
      }).catch(() => {
        loading.value = false;
        if (captchaEnabled.value) {
          getCode();
        }
      });
    }
  });
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled;
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img;
      loginForm.value.uuid = res.uuid;
    }
  });
}

function getCookie() {
  const username = Cookies.get("username");
  const password = Cookies.get("password");
  const rememberMe = Cookies.get("rememberMe");
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe),
    code: loginForm.value.code,
    uuid: loginForm.value.uuid
  };
}

getCode();
getCookie();
</script>

<style lang='scss' scoped>
.login {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  min-height: 100vh;
  padding: 56px 11vw;
  overflow: hidden;
  background:
    linear-gradient(115deg, rgba(4, 14, 32, 0.98) 0%, rgba(9, 35, 66, 0.94) 46%, rgba(226, 242, 255, 0.88) 100%),
    radial-gradient(circle at 23% 28%, rgba(93, 213, 255, 0.32), transparent 34%),
    linear-gradient(180deg, #061325 0%, #0b2544 100%);
  background-size: cover;
}

.login::before {
  content: "";
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(151, 214, 255, 0.08) 1px, transparent 1px),
    linear-gradient(90deg, rgba(151, 214, 255, 0.08) 1px, transparent 1px);
  background-size: 56px 56px;
  mask-image: linear-gradient(90deg, #000 0%, transparent 72%);
}

.login::after {
  content: "";
  position: absolute;
  left: -18%;
  bottom: -35%;
  width: 760px;
  height: 760px;
  border: 1px solid rgba(125, 218, 255, 0.2);
  border-radius: 50%;
  box-shadow: inset 0 0 70px rgba(72, 184, 255, 0.12);
}

.login-visual {
  position: absolute;
  left: 12vw;
  top: 50%;
  width: min(42vw, 560px);
  aspect-ratio: 1;
  transform: translateY(-50%);
}

.orbital {
  position: absolute;
  inset: 9%;
  border: 1px solid rgba(130, 220, 255, 0.3);
  border-radius: 50%;
}

.orbital::before,
.orbital::after {
  content: "";
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: #7ddaff;
  box-shadow: 0 0 22px rgba(125, 218, 255, 0.86);
}

.orbital::before {
  top: 16%;
  right: 18%;
}

.orbital::after {
  left: 12%;
  bottom: 24%;
}

.orbital-inner {
  inset: 20%;
  transform: rotate(-24deg);
  border-color: rgba(230, 247, 255, 0.24);
}

.shield-preview {
  position: absolute;
  inset: 20%;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(241, 249, 255, 0.9), rgba(125, 218, 255, 0.12) 58%, transparent 70%);
  filter: drop-shadow(0 26px 48px rgba(0, 0, 0, 0.28));
}

.shield-preview img {
  width: 82%;
  height: 82%;
  object-fit: contain;
}

.login-form {
  position: relative;
  z-index: 1;
  width: 400px;
  padding: 30px 28px 12px;
  border: 1px solid rgba(212, 239, 255, 0.46);
  border-radius: 8px;
  background: rgba(246, 251, 255, 0.92);
  box-shadow: 0 26px 80px rgba(3, 18, 38, 0.35);
  backdrop-filter: blur(18px);

  .el-input {
    height: 42px;
    input {
      height: 42px;
    }
  }

  .input-icon {
    height: 40px;
    width: 14px;
    margin-left: 0;
    color: #2f6f94;
  }
}

.brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 28px;
}

.brand-logo {
  height: 72px;
  width: auto;
  max-width: 90px;
  object-fit: contain;
  margin-bottom: 12px;
}

.title {
  margin: 0;
  text-align: center;
  color: #123655;
  font-size: 26px;
  font-weight: 700;
  line-height: 1.2;
}

.remember-me {
  margin: 0 0 24px;
  color: #31536c;
}

.login-button {
  width: 100%;
  border: 0;
  background: linear-gradient(90deg, #1488cc 0%, #2dd4bf 100%);
  box-shadow: 0 12px 26px rgba(20, 136, 204, 0.28);
}

.login-button:hover,
.login-button:focus {
  background: linear-gradient(90deg, #0f7dbc 0%, #23c9b2 100%);
}

.login-code {
  width: 33%;
  height: 42px;
  float: right;

  img {
    cursor: pointer;
    vertical-align: middle;
  }
}

.login-code-img {
  height: 42px;
  padding-left: 12px;
}

.el-login-footer {
  position: fixed;
  z-index: 1;
  bottom: 0;
  width: 100%;
  height: 40px;
  line-height: 40px;
  text-align: center;
  color: rgba(232, 246, 255, 0.86);
  font-family: Arial, sans-serif;
  font-size: 12px;
  letter-spacing: 1px;
}

@media (max-width: 960px) {
  .login {
    justify-content: center;
    padding: 36px 18px;
  }

  .login-visual {
    opacity: 0.18;
    left: 50%;
    width: 620px;
    transform: translate(-50%, -50%);
  }
}

@media (max-width: 480px) {
  .login-form {
    width: 100%;
    padding: 26px 20px 8px;
  }

  .title {
    font-size: 24px;
  }
}
</style>
