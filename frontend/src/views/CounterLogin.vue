<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import api from '../services/api';
import GlobalHeader from '../components/common/GlobalHeader.vue';

const router = useRouter();
const email = ref('');
const password = ref('');
const error = ref('');
const isLoading = ref(false);

const login = async () => {
  error.value = '';
  isLoading.value = true;
  try {
    const res = await api.post('/auth/login', {
      email: email.value,
      password: password.value
    });
    
    const { token, user } = res.data;
    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(user));
    
    if (user.role === 'ADMIN') {
      router.push('/admin');
    } else if (user.role === 'DOCTOR') {
      router.push('/doctor/dashboard');
    } else if (user.role === 'NURSE_GENERAL' || user.role === 'TRIAJE') {
      router.push('/triage');
    } else {
      router.push('/monitoring');
    }
  } catch (err: any) {
    console.error('Login error:', err);
    error.value = err.response?.data?.message || 'Error al conectar con el servidor';
  } finally {
    isLoading.value = false;
  }
};
</script>

<template>
  <div class="min-h-screen flex flex-col bg-slate-100">
    <GlobalHeader />
    <div class="flex-1 flex items-center justify-center">
    <div class="bg-white p-8 rounded-2xl shadow-xl max-w-sm w-full border border-slate-200">
      <div class="text-center mb-8">
        <div class="bg-blue-600 w-16 h-16 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg shadow-blue-200">
          <i class="fas fa-user-md text-white text-2xl"></i>
        </div>
        <h2 class="text-2xl font-bold text-slate-800">Acceso Personal</h2>
        <p class="text-slate-500 text-sm mt-1">Ingrese sus credenciales para continuar</p>
      </div>

      <div v-if="error" class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 text-sm rounded-r-lg animate-pulse">
        <div class="flex items-center">
          <i class="fas fa-exclamation-circle mr-2"></i>
          {{ error }}
        </div>
      </div>

      <form @submit.prevent="login" class="space-y-5">
        <div>
          <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2 ml-1">Correo Electrónico</label>
          <div class="relative">
            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-slate-400">
              <i class="fas fa-envelope"></i>
            </span>
            <input 
              type="email" 
              v-model="email" 
              class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none text-slate-700" 
              placeholder="ejemplo@onkos.pe"
              required 
            />
          </div>
        </div>

        <div>
          <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2 ml-1">Contraseña</label>
          <div class="relative">
            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-slate-400">
              <i class="fas fa-lock"></i>
            </span>
            <input 
              type="password" 
              v-model="password" 
              class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none text-slate-700" 
              placeholder="••••••••"
              required 
            />
          </div>
        </div>

        <button 
          type="submit" 
          :disabled="isLoading"
          class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-xl shadow-lg shadow-blue-200 transition-all transform hover:-translate-y-0.5 active:translate-y-0 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
        >
          <span v-if="isLoading">
            <i class="fas fa-circle-notch fa-spin mr-2"></i> Cargando...
          </span>
          <span v-else>Ingresar al Sistema</span>
        </button>
      </form>

      <div class="mt-8 text-center">
        <p class="text-slate-400 text-xs">
          &copy; 2025 Onkos - Sistema de Gestión Hospitalaria
        </p>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: .8; }
}
</style>
