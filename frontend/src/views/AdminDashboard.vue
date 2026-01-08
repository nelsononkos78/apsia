<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import api from '../services/api';
import GlobalHeader from '../components/common/GlobalHeader.vue';
import { websocketService } from '../services/websocket.service';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
} from 'chart.js';
import { Bar, Doughnut } from 'vue-chartjs';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
);

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

const years = Array.from({ length: 5 }, (_, i) => new Date().getFullYear() - i);

async function fetchStats() {
  loading.value = true;
  try {
    const res = await api.get('/dashboard/stats', {
      params: {
        month: selectedMonth.value,
        year: selectedYear.value
      }
    });
    stats.value = res.data;
  } catch (error) {
    console.error('Error fetching stats:', error);
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  fetchStats();
  websocketService.on('dashboard:updated', fetchStats);
});

onUnmounted(() => {
  websocketService.off('dashboard:updated', fetchStats);
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
      data: stats.value.serviceDistribution.map((s: any) => s.count),
      backgroundColor: [
        '#223675',
        '#5371C4',
        '#CEEAC7',
        '#A5D8A9',
        '#FDE68A',
        '#F87171'
      ]
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

</script>

<template>
  <div class="min-h-screen bg-secondary">
    <GlobalHeader />
    
    <div class="p-6 max-w-7xl mx-auto">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-primary">Dashboard Administrativo</h1>
        
        <div class="flex gap-4 bg-white p-2 rounded-xl shadow-sm border border-gray-100">
          <select v-model="selectedMonth" @change="fetchStats" class="bg-transparent border-none focus:ring-0 font-semibold text-gray-600">
            <option v-for="m in months" :key="m.value" :value="m.value">{{ m.label }}</option>
          </select>
          <select v-model="selectedYear" @change="fetchStats" class="bg-transparent border-none focus:ring-0 font-semibold text-gray-600">
            <option v-for="y in years" :key="y" :value="y">{{ y }}</option>
          </select>
        </div>
      </div>

      <div v-if="loading" class="flex justify-center items-center h-64">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>

      <template v-else-if="stats">
        <!-- KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-7 gap-4 mb-8">
          <div class="card-kpi">
            <div class="icon-box bg-blue-50 text-blue-500">
              <i class="fas fa-user-plus"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">Nuevos</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.newPatients }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-green-50 text-green-500">
              <i class="fas fa-user-check"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">Seguimientos</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.continuingPatients }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-red-50 text-red-500">
              <i class="fas fa-user-times"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">No Show</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.noShows }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-purple-50 text-purple-500">
              <i class="fas fa-calendar-check"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">Total Citas</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.totalAppointments }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-orange-50 text-orange-500">
              <i class="fas fa-calendar-alt"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">Por Llegar</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.scheduledAppointments }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-indigo-50 text-indigo-500">
              <i class="fas fa-clock"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">En Espera</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.waitingAppointments }}</p>
            </div>
          </div>

          <div class="card-kpi">
            <div class="icon-box bg-teal-50 text-teal-500">
              <i class="fas fa-user-md"></i>
            </div>
            <div class="kpi-content">
              <h3 class="text-gray-500 text-xs font-medium">En Atención</h3>
              <p class="text-xl font-bold text-gray-800">{{ stats.kpis.inConsultationAppointments }}</p>
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
  @apply bg-white p-4 rounded-2xl shadow-sm border border-gray-100 flex items-center gap-3 transition-transform hover:scale-105;
}

.icon-box {
  @apply w-10 h-10 rounded-xl flex items-center justify-center text-lg flex-shrink-0;
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
