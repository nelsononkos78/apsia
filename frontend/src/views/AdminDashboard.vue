<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch, computed } from 'vue';
import api from '../services/api';
import GlobalHeader from '../components/common/GlobalHeader.vue';
import { websocketService } from '../services/websocket.service';
import { Bar, Doughnut } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement
} from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement);

const stats = ref<any>(null);
const loading = ref(true);
const selectedMonth = ref(new Date().getMonth() + 1);
const selectedYear = ref(new Date().getFullYear());

const months = [
  { value: 1, label: 'Enero' },
  { value: 2, label: 'Febrero' },
  { value: 3, label: 'Marzo' },
  { value: 4, label: 'Abril' },
  { value: 5, label: 'Mayo' },
  { value: 6, label: 'Junio' },
  { value: 7, label: 'Julio' },
  { value: 8, label: 'Agosto' },
  { value: 9, label: 'Septiembre' },
  { value: 10, label: 'Octubre' },
  { value: 11, label: 'Noviembre' },
  { value: 12, label: 'Diciembre' }
];

const years = [2024, 2025, 2026];

async function loadStats() {
  loading.value = true;
  try {
    const res = await api.get(`/dashboard/stats?month=${selectedMonth.value}&year=${selectedYear.value}`);
    stats.value = res.data;
  } catch (error) {
    console.error('Error loading stats:', error);
  } finally {
    loading.value = false;
  }
}

watch([selectedMonth, selectedYear], loadStats);

onMounted(() => {
  loadStats();
  
  // Join dashboard room for real-time updates
  websocketService.emit('join:dashboard');
  
  websocketService.on('dashboard:updated', () => {
    console.log('🔄 Dashboard update received via WebSocket');
    loadStats();
  });
});

onUnmounted(() => {
  websocketService.emit('leave:dashboard');
  websocketService.off('dashboard:updated');
});

const patientChartData = computed(() => {
  if (!stats.value?.kpis) return { labels: [], datasets: [] };
  return {
    labels: ['Nuevos', 'Seguimientos', 'No Show'],
    datasets: [{
      label: 'Cantidad de Pacientes',
      data: [
        stats.value.kpis.newPatients,
        stats.value.kpis.continuingPatients,
        stats.value.kpis.noShows
      ],
      backgroundColor: ['#5371C4', '#CEEAC7', '#f44336'],
      borderRadius: 8
    }]
  };
});

const serviceChartData = computed(() => {
  if (!stats.value?.serviceDistribution) return { labels: [], datasets: [] };
  return {
    labels: stats.value.serviceDistribution.map((s: any) => s.name),
    datasets: [{
      data: stats.value.serviceDistribution.map((s: any) => parseInt(s.count)),
      backgroundColor: ['#5371C4', '#CEEAC7', '#C3E1ED', '#223675', '#A5D8A9', '#FAD02E', '#F28D35']
    }]
  };
});

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom' as const
    }
  }
};

function formatCurrency(value: number) {
  return new Intl.NumberFormat('es-PE', { style: 'currency', currency: 'PEN' }).format(value);
}
</script>

<template>
  <div class="min-h-screen bg-secondary">
    <GlobalHeader />
    
    <div class="p-6 max-w-7xl mx-auto">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-primary">Dashboard Administrativo</h1>
        
        <div class="flex gap-4 bg-white p-2 rounded-xl shadow-sm border border-gray-100">
          <select v-model="selectedMonth" class="bg-transparent border-none focus:ring-0 font-semibold text-gray-600">
            <option v-for="m in months" :key="m.value" :value="m.value">{{ m.label }}</option>
          </select>
          <select v-model="selectedYear" class="bg-transparent border-none focus:ring-0 font-semibold text-gray-600">
            <option v-for="y in years" :key="y" :value="y">{{ y }}</option>
          </select>
        </div>
      </div>

      <div v-if="loading" class="flex justify-center items-center h-64">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>

      <template v-else-if="stats">
        <!-- KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-6 mb-8">
          <div class="card-kpi">
            <div class="icon-box bg-blue-50 text-blue-500">
              <i class="fas fa-user-plus"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-sm font-medium">Nuevos</h3>
              <p class="text-2xl font-bold text-gray-800">{{ stats.kpis.newPatients }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-green-50 text-green-500">
              <i class="fas fa-user-check"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-sm font-medium">Seguimientos</h3>
              <p class="text-2xl font-bold text-gray-800">{{ stats.kpis.continuingPatients }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-red-50 text-red-500">
              <i class="fas fa-user-times"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-sm font-medium">No Show</h3>
              <p class="text-2xl font-bold text-gray-800">{{ stats.kpis.noShows }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-purple-50 text-purple-500">
              <i class="fas fa-calendar-check"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-sm font-medium">Total Citas</h3>
              <p class="text-2xl font-bold text-gray-800">{{ stats.kpis.totalAppointments }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-orange-50 text-orange-500">
              <i class="fas fa-hourglass-half"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-sm font-medium">Pendientes</h3>
              <p class="text-2xl font-bold text-gray-800">{{ stats.kpis.pendingAppointments }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-yellow-50 text-yellow-600">
              <i class="fas fa-hand-holding-usd"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-sm font-medium">Ingresos</h3>
              <p class="text-2xl font-bold text-gray-800">{{ formatCurrency(stats.kpis.totalIncome) }}</p>
            </div>
          </div>
        </div>

        <!-- Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div class="card-chart">
            <h3 class="text-lg font-bold text-gray-700 mb-6">Resumen de Pacientes</h3>
            <div class="h-80">
              <Bar :data="patientChartData" :options="chartOptions" />
            </div>
          </div>

          <div class="card-chart">
            <h3 class="text-lg font-bold text-gray-700 mb-6">Distribución por Servicios</h3>
            <div class="h-80">
              <Doughnut :data="serviceChartData" :options="chartOptions" />
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<style scoped>
.card-kpi {
  @apply bg-white p-6 rounded-2xl shadow-sm border border-gray-100 flex items-center gap-4 transition-transform hover:scale-105;
}

.icon-box {
  @apply w-12 h-12 rounded-xl flex items-center justify-center text-xl;
}

.card-chart {
  @apply bg-white p-8 rounded-2xl shadow-sm border border-gray-100;
}

.bg-secondary {
  background-color: #f8fafc;
}

.text-primary {
  color: #223675;
}
</style>
