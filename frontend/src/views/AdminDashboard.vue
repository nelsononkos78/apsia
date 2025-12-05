<script setup lang="ts">
</script>

<template>
  <div class="min-h-screen bg-secondary p-6">
    <h1 class="text-3xl font-bold mb-8">Dashboard Administrativo</h1>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="card">
        <h3 class="text-gray-500 mb-2">Pacientes Hoy</h3>
        <p class="text-4xl font-bold text-primary">42</p>
      </div>
      <div class="card">
        <h3 class="text-gray-500 mb-2">Tiempo Promedio Espera</h3>
        <p class="text-4xl font-bold text-accent">18 min</p>
      </div>
      <div class="card">
        <h3 class="text-gray-500 mb-2">Sillas Quimio Ocupadas</h3>
        <p class="text-4xl font-bold text-blue-500">5/9</p>
      </div>
    </div>

    <!-- Placeholder for charts -->
    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="card h-64 flex items-center justify-center bg-white">
        <span class="text-gray-400">Gráfico de Citas por Hora</span>
      </div>
      <div class="card h-64 flex items-center justify-center bg-white">
        <span class="text-gray-400">Gráfico de Ocupación</span>
      </div>
    </div>
  </div>
</template>
