<script setup lang="ts">
import GlobalHeader from '../components/common/GlobalHeader.vue';
</script>

<template>
  <div class="min-h-screen flex flex-col bg-secondary">
    <GlobalHeader />
    <div class="flex-1 flex flex-col items-center justify-center p-4">
    <div class="max-w-md w-full text-center space-y-8">
      <h1 class="text-4xl font-bold text-primary">Bienvenido a Onkos</h1>
      <p class="text-gray-600">Gestión de Citas y Turnos</p>
      
      <div class="grid gap-4">
        <router-link to="/book" class="btn-primary py-4 text-lg shadow-lg">
          Agendar Cita
        </router-link>
        
        <router-link to="/checkin" class="btn-secondary py-4 text-lg">
          Check-in (Llegada)
        </router-link>
      </div>

      <div class="mt-8 pt-8 border-t border-gray-200">
        <router-link to="/staff/login" class="text-sm text-gray-500 hover:text-primary">
          Acceso Personal
        </router-link>
        <span class="mx-2 text-gray-300">|</span>
        <router-link to="/tv" class="text-sm text-gray-500 hover:text-primary">
          Pantalla TV
        </router-link>
      </div>
      </div>
    </div>
  </div>
</template>
