<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import Button from "@src/components/ui/inputs/Button.vue";
import LabeledTextInput from "@src/components/ui/inputs/LabeledTextInput.vue";
import PasswordInput from "@src/components/ui/inputs/PasswordInput.vue";
import { RouterLink } from "vue-router";

// Thêm router
const router = useRouter();

// Các trạng thái
const email = ref("");
const password = ref("");
const isLoading = ref(false);
const error = ref("");
const successMessage = ref("");

// Hàm xử lý đăng nhập
const handleLogin = async () => {
  // Xóa thông báo lỗi cũ
  error.value = "";
  successMessage.value = "";

  console.log(email.value, password.value);
  // Validate form
  if (!email.value || !password.value) {
    error.value = "Vui lòng nhập đầy đủ email và mật khẩu";
    return;
  }

  try {
    isLoading.value = true;

    const API_URL =
      import.meta.env.VITE_API_BASE_URL || "http://localhost:3000";

    // Trong hàm handleLogin
    const response = await fetch(`${API_URL}/auth/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email: email.value,
        password: password.value,
      }),
    });

    const data = await response.json();
    console.log(data);

    if (!response.ok) {
      // Xử lý lỗi từ API
      throw new Error(data.message || "Đăng nhập thất bại");
    }

    // Lưu token và thông tin người dùng vào localStorage
    localStorage.setItem("access_token", data.access_token);
    if (data.user) {
      localStorage.setItem("user", JSON.stringify(data.user));
    }

    // Thông báo thành công
    successMessage.value = "Đăng nhập thành công!";

    // Chuyển hướng đến trang chat sau khi đăng nhập
    setTimeout(() => {
      router.push("/chat/no-chat/");
    }, 500);
  } catch (err: any) {
    // Hiển thị lỗi
    error.value = err.message || "Đã có lỗi xảy ra. Vui lòng thử lại.";
  } finally {
    isLoading.value = false;
  }
};
</script>

<template>
  <div
    class="p-5 md:basis-1/2 xs:basis-full flex flex-col justify-center items-center"
  >
    <div class="w-full md:px-[26%] xs:px-[10%]">
      <!--header-->
      <div class="mb-6 flex flex-col">
        <img
          src="@src/assets/vectors/logo-gradient.svg"
          class="w-5.5 h-4.5 mb-4 opacity-70"
          alt="bird logo"
        />
        <p class="heading-2 text-black/70 dark:text-white/70 mb-4">
          Welcome back
        </p>
        <p class="body-3 text-black/75 dark:text-white/70 font-light">
          Create an account a start messaging now!
        </p>
      </div>

      <!-- Thông báo lỗi và thành công -->
      <div v-if="error" class="mb-4 p-3 bg-red-100 text-red-700 rounded">
        {{ error }}
      </div>
      <div
        v-if="successMessage"
        class="mb-4 p-3 bg-green-100 text-green-700 rounded"
      >
        {{ successMessage }}
      </div>

      <!--form-->
      <form @submit.prevent="handleLogin" class="mb-6">
        <LabeledTextInput
          :value="email"
          @input="email = $event.target.value"
          label="Email"
          placeholder="Enter your email"
          class="mb-5"
        />
        <PasswordInput
          @value-changed="
            (value) => {
              password = value;
            }
          "
          :value="password"
          label="Password"
          placeholder="Enter your password"
        />

        <!--local controls-->
        <div class="mt-6">
          <Button
            type="submit"
            class="contained-primary contained-text w-full mb-4"
            :disabled="isLoading"
          >
            <span v-if="isLoading">Đang xử lý...</span>
            <span v-else>Đăng nhập</span>
          </Button>
        </div>
      </form>

      <!--divider-->
      <div class="mb-6 flex items-center">
        <span
          class="w-full border border-dashed border-gray-100 dark:border-gray-600 rounded-[.0625rem]"
        ></span>
        <p class="body-3 text-black/75 dark:text-white/70 px-4 font-light">
          or
        </p>
        <span
          class="w-full border border-dashed border-gray-100 dark:border-gray-600 rounded-[.0625rem]"
        ></span>
      </div>

      <!--oauth controls-->
      <div>
        <Button class="outlined-primary outlined-text w-full mb-5">
          <img
            src="@src/assets/vectors/google-logo.svg"
            class="mr-3"
            alt="google logo"
          />
          Sign in with google
        </Button>

        <!--bottom text-->
        <div class="flex justify-center">
          <p class="body-2 text-black/70 dark:text-white/70">
            Don't have an account?
            <RouterLink
              to="/access/sign-up/"
              class="text-indigo-400 opacity-100"
            >
              Sign up
            </RouterLink>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
