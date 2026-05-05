<template>
  <div class="login">
    <section class="login-visual" aria-hidden="true">
      <div class="visual-copy">
        <span class="visual-badge">SkyShield</span>
        <h1>低空网络安全防护平台</h1>
        <p>面向无人机、地面控制系统与通信链路的感知、认知、决策、防御、溯源一体化安全能力。</p>
      </div>
      <div class="orbital orbital-one"></div>
      <div class="orbital orbital-two"></div>
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
    radial-gradient(circle at 12% 16%, rgba(47, 123, 255, 0.24), transparent 28%),
    radial-gradient(circle at 88% 18%, rgba(52, 208, 255, 0.16), transparent 24%),
    linear-gradient(180deg, #020a18 0%, #061226 100%);
  background-size: cover;
}

.login::before {
  content: "";
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(52, 208, 255, 0.08) 1px, transparent 1px),
    linear-gradient(90deg, rgba(52, 208, 255, 0.08) 1px, transparent 1px);
  background-size: 48px 48px;
}

.login::after {
  content: "";
  position: absolute;
  left: 28%;
  top: 50%;
  width: 860px;
  height: 860px;
  border: 1px solid rgba(125, 218, 255, 0.2);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  box-shadow: inset 0 0 90px rgba(52, 208, 255, 0.08);
}

.login-visual {
  position: absolute;
  z-index: 1;
  left: 10vw;
  top: 50%;
  width: min(44vw, 620px);
  min-height: 560px;
  transform: translateY(-50%);
  pointer-events: none;
}

.visual-copy {
  position: relative;
  z-index: 2;
  max-width: 520px;
  color: #ffffff;

  h1 {
    margin: 18px 0 14px;
    font-size: 44px;
    line-height: 1.18;
    letter-spacing: 0;
  }

  p {
    margin: 0;
    color: #9db8df;
    font-size: 16px;
    line-height: 1.9;
  }
}

.visual-badge {
  display: inline-flex;
  padding: 7px 16px;
  border: 1px solid rgba(52, 208, 255, 0.36);
  border-radius: 999px;
  color: #34d0ff;
  background: rgba(52, 208, 255, 0.09);
  box-shadow: 0 0 24px rgba(52, 208, 255, 0.12);
}

.orbital {
  position: absolute;
  border: 1px solid rgba(52, 208, 255, 0.22);
  border-radius: 50%;
  box-shadow: inset 0 0 60px rgba(52, 208, 255, 0.06);
}

.orbital-one {
  right: 12px;
  bottom: 16px;
  width: 440px;
  height: 440px;
}

.orbital-two {
  right: 78px;
  bottom: 82px;
  width: 308px;
  height: 308px;
  border-color: rgba(47, 123, 255, 0.24);
}

.shield-preview {
  position: absolute;
  right: 64px;
  bottom: 70px;
  display: grid;
  place-items: center;
  width: 336px;
  height: 336px;
  border-radius: 50%;
  background:
    radial-gradient(circle, rgba(255, 255, 255, 0.16), transparent 64%),
    rgba(8, 24, 52, 0.36);
  box-shadow: 0 34px 92px rgba(0, 8, 25, 0.46), 0 0 70px rgba(52, 208, 255, 0.14);

  img {
    width: 82%;
    height: 82%;
    object-fit: contain;
    filter: drop-shadow(0 20px 34px rgba(47, 123, 255, 0.24));
  }
}

.login-form {
  position: relative;
  z-index: 2;
  width: 420px;
  padding: 32px 30px 14px;
  border: 1px solid rgba(52, 208, 255, 0.24);
  border-radius: 12px;
  background: rgba(8, 24, 52, 0.86);
  box-shadow: 0 28px 90px rgba(0, 8, 25, 0.48), inset 0 0 0 1px rgba(52, 208, 255, 0.06);
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
    color: #34d0ff;
  }
}

.login-form :deep(.el-input__wrapper) {
  border: 1px solid rgba(52, 208, 255, 0.22);
  background: rgba(2, 10, 24, 0.62);
  box-shadow: none;
}

.login-form :deep(.el-input__inner) {
  color: #ffffff;
}

.login-form :deep(.el-input__inner::placeholder) {
  color: #6f8aaf;
}

.brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 28px;
}

.brand-logo {
  height: 78px;
  width: auto;
  max-width: 90px;
  object-fit: contain;
  margin-bottom: 12px;
}

.title {
  margin: 0;
  text-align: center;
  color: #ffffff;
  font-size: 26px;
  font-weight: 700;
  line-height: 1.2;
}

.remember-me {
  margin: 0 0 24px;
  color: #bdd3f2;
}

.login-button {
  width: 100%;
  border: 0;
  background: linear-gradient(90deg, #2f7bff 0%, #34d0ff 100%);
  box-shadow: 0 12px 26px rgba(47, 123, 255, 0.32);
}

.login-button:hover,
.login-button:focus {
  background: linear-gradient(90deg, #246df0 0%, #25c4f2 100%);
}

.login-code {
  width: 33%;
  height: 42px;
  float: right;

  img {
    cursor: pointer;
    vertical-align: middle;
    border-radius: 6px;
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
    display: none;
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
