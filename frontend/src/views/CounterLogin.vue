<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const email = ref('');
const password = ref('');

const login = () => {
  // Mock login
  if (email.value === 'admin@onkos.pe' && password.value === 'admin') {
    router.push('/admin');
  } else {
    alert('Credenciales inválidas');
  }
};
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-secondary">
    <div class="card max-w-sm w-full">
      <h2 class="text-xl font-bold mb-6 text-center">Acceso Personal</h2>
      <form @submit.prevent="login" class="space-y-4">
        <div>
          <label class="block text-sm font-medium mb-1">Email</label>
          <input type="email" v-model="email" class="w-full border rounded p-2" required />
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Contraseña</label>
          <input type="password" v-model="password" class="w-full border rounded p-2" required />
        </div>
        <button type="submit" class="w-full btn-primary">Ingresar</button>
      </form>
    </div>
  </div>
</template>
