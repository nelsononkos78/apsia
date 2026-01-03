<template>
  <div class="min-h-screen bg-gray-100">
    <GlobalHeader />
    <div class="p-6">
    <h1 class="text-3xl font-bold mb-6 text-gray-800">Gestión de Flujos Internos</h1>

    <div class="bg-white rounded-lg shadow p-4 mb-6">
      <div class="flex space-x-4 border-b pb-2">
        <button 
          @click="activeTab = 'doctor'" 
          :class="['px-4 py-2 rounded', activeTab === 'doctor' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100']"
        >
          Médico (Receta)
        </button>
        <button 
          @click="activeTab = 'pharmacy'" 
          :class="['px-4 py-2 rounded', activeTab === 'pharmacy' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100']"
        >
          Farmacia (Cotización)
        </button>
        <button 
          @click="activeTab = 'admin'" 
          :class="['px-4 py-2 rounded', activeTab === 'admin' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100']"
        >
          Admin (Aprobación)
        </button>
      </div>

      <!-- Doctor View -->
      <div v-if="activeTab === 'doctor'" class="mt-4">
        <h2 class="text-xl font-semibold mb-4">Crear Receta / Orden</h2>
        <form @submit.prevent="createRecipe" class="space-y-4 max-w-lg">
          <div>
            <label class="block text-sm font-medium text-gray-700">ID Paciente</label>
            <input v-model="recipeForm.patientId" type="number" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700">ID Médico</label>
            <input v-model="recipeForm.doctorId" type="number" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700">Contenido (Esquema Quimio)</label>
            <textarea v-model="recipeForm.content" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" rows="3" required></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700">Fecha Sugerida</label>
            <input v-model="recipeForm.suggestedDate" type="date" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" required />
          </div>
          <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Crear Receta</button>
        </form>
      </div>

      <!-- Pharmacy View -->
      <div v-if="activeTab === 'pharmacy'" class="mt-4">
        <h2 class="text-xl font-semibold mb-4">Generar Cotización</h2>
        <form @submit.prevent="createQuote" class="space-y-4 max-w-lg">
          <div>
            <label class="block text-sm font-medium text-gray-700">ID Paciente</label>
            <input v-model="quoteForm.patientId" type="number" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700">Monto Total</label>
            <input v-model="quoteForm.totalAmount" type="number" step="0.01" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700">Items (JSON)</label>
            <textarea v-model="quoteForm.items" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" rows="3" placeholder='[{"name": "Drug A", "cost": 100}]'></textarea>
          </div>
          <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Generar Cotización</button>
        </form>
      </div>

      <!-- Admin View -->
      <div v-if="activeTab === 'admin'" class="mt-4">
        <h2 class="text-xl font-semibold mb-4">Aprobar Cotización</h2>
        <form @submit.prevent="approveQuote" class="space-y-4 max-w-lg">
          <div>
            <label class="block text-sm font-medium text-gray-700">ID Cotización</label>
            <input v-model="approveForm.quoteId" type="number" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 border" required />
          </div>
          <button type="submit" class="bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700">Aprobar Cotización</button>
        </form>
      </div>
    </div>

    <!-- Output Console -->
    <div class="bg-gray-800 text-white p-4 rounded-lg shadow h-48 overflow-y-auto font-mono text-sm">
      <div v-for="(log, index) in logs" :key="index">> {{ log }}</div>
    </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import GlobalHeader from '../components/common/GlobalHeader.vue';

const activeTab = ref('doctor');
const logs = ref<string[]>([]);

const recipeForm = reactive({
  patientId: 1,
  doctorId: 1,
  content: 'Esquema AC (Doxorrubicina + Ciclofosfamida)',
  suggestedDate: (() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
  })()
});

const quoteForm = reactive({
  patientId: 1,
  totalAmount: 1500.00,
  items: '[{"name": "Insumos Quimio", "cost": 1500}]'
});

const approveForm = reactive({
  quoteId: 1
});

const log = (msg: string) => {
  logs.value.unshift(`${new Date().toLocaleTimeString()} - ${msg}`);
};

const createRecipe = async () => {
  try {
    const res = await axios.post('http://localhost:4000/api/internal/recipe', recipeForm);
    log(`Receta creada: ID ${res.data.id}`);
  } catch (err: any) {
    log(`Error: ${err.response?.data?.message || err.message}`);
  }
};

const createQuote = async () => {
  try {
    const payload = {
      ...quoteForm,
      items: JSON.parse(quoteForm.items)
    };
    const res = await axios.post('http://localhost:4000/api/internal/quote', payload);
    log(`Cotización creada: ID ${res.data.id}`);
  } catch (err: any) {
    log(`Error: ${err.response?.data?.message || err.message}`);
  }
};

const approveQuote = async () => {
  try {
    const res = await axios.post('http://localhost:4000/api/internal/approve-quote', approveForm);
    log(`Cotización aprobada: ID ${res.data.id} - Status: ${res.data.status}`);
  } catch (err: any) {
    log(`Error: ${err.response?.data?.message || err.message}`);
  }
};
</script>
