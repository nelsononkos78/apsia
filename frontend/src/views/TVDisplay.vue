<script setup lang="ts">
import { ref, onMounted } from 'vue';

const currentPatient = ref({ ticket: 'C-001', area: 'Consultorio 1' });
const upcoming = ref([
  { ticket: 'C-002', area: 'Espera' },
  { ticket: 'L-005', area: 'Espera' },
  { ticket: 'C-003', area: 'Espera' },
]);

// Mock polling
onMounted(() => {
  setInterval(() => {
    // Refresh logic here
  }, 5000);
});
</script>

<template>
  <div class="min-h-screen bg-gray-900 text-white p-8 flex gap-8">
    <!-- Main Display -->
    <div class="flex-1 flex flex-col items-center justify-center bg-gray-800 rounded-3xl p-12 border-4 border-primary shadow-2xl animate-pulse">
      <h2 class="text-4xl text-gray-400 mb-8">TURNO ACTUAL</h2>
      <div class="text-9xl font-bold text-primary mb-4">{{ currentPatient.ticket }}</div>
      <div class="text-5xl text-white">{{ currentPatient.area }}</div>
    </div>

    <!-- Sidebar List -->
    <div class="w-1/3 bg-gray-800 rounded-3xl p-8 border border-gray-700">
      <h3 class="text-2xl font-bold mb-6 text-gray-400 border-b border-gray-700 pb-4">Próximos Turnos</h3>
      <div class="space-y-4">
        <div v-for="item in upcoming" :key="item.ticket" class="flex justify-between items-center p-4 bg-gray-700 rounded-xl">
          <span class="text-3xl font-bold">{{ item.ticket }}</span>
          <span class="text-xl text-gray-300">{{ item.area }}</span>
        </div>
      </div>
    </div>
  </div>
</template>
