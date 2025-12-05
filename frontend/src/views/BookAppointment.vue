<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import api from '../services/api';
import { useToast } from "vue-toastification";

const toast = useToast();
const router = useRouter();
const step = ref(1);
const loading = ref(false);

// Form data
const formData = ref({
  serviceType: '',
  specialty: '',
  doctorId: null as number | null,
  notes: '',
  date: '',
  time: '',
  phoneNumber: '',
  emergencyContact: '',
  patientId: 1 // Mock patient for demo; in real app, this comes from auth
});

// Options
const specialties = ref<string[]>([]);
const doctors = ref<any[]>([]);
const availability = ref<any[]>([]);

// Service types
const serviceTypes = [
  {
    id: 'CONSULTATION',
    label: 'Consulta Nueva',
    description: 'Primera visita con un especialista.',
    icon: '🏥'
  },
  {
    id: 'LABORATORY',
    label: 'Examen de Laboratorio',
    description: 'Análisis clínicos requeridos.',
    icon: '🧪'
  },
  {
    id: 'CHEMOTHERAPY',
    label: 'Sesión de Tratamiento',
    description: 'Ciclo de quimio o radioterapia.',
    icon: '💉'
  },
  {
    id: 'RECOVERY',
    label: 'Consulta de Seguimiento',
    description: 'Revisión de progreso y resultados.',
    icon: '🔄'
  }
];

// Fetch specialties
const loadSpecialties = async () => {
  try {
    const res = await api.get('/specialties');
    specialties.value = res.data;
  } catch (error) {
    toast.error('Error al cargar especialidades');
  }
};

// Fetch doctors
const loadDoctors = async () => {
  try {
    const params: any = {};
    if (formData.value.specialty) params.specialty = formData.value.specialty;
    
    const res = await api.get('/doctors', { params });
    doctors.value = res.data;
  } catch (error) {
    toast.error('Error al cargar médicos');
  }
};

// Fetch availability
const loadAvailability = async () => {
  if (!formData.value.date || !formData.value.specialty) return;
  
  loading.value = true;
  try {
    const params: any = {
      date: formData.value.date,
      specialty: formData.value.specialty
    };
    if (formData.value.doctorId) params.doctorId = formData.value.doctorId;
    
    const res = await api.get('/availability', { params });
    availability.value = res.data;
  } catch (error) {
    toast.error('Error al cargar disponibilidad');
  } finally {
    loading.value = false;
  }
};

// Step navigation
const goToStep2 = async () => {
  if (!formData.value.serviceType || !formData.value.specialty) {
    toast.warning('Por favor complete todos los campos requeridos');
    return;
  }
  
  // Don't load availability yet - user hasn't selected a date
  step.value = 2;
};

const goToStep3 = () => {
  if (!formData.value.date || !formData.value.time) {
    toast.warning('Por favor seleccione fecha y hora');
    return;
  }
  step.value = 3;
};

const goBack = () => {
  if (step.value > 1) step.value--;
};

// Submit appointment
const submitAppointment = async () => {
  if (!formData.value.phoneNumber || !formData.value.emergencyContact) {
    toast.warning('Por favor complete la información de contacto');
    return;
  }

  loading.value = true;
  try {
    // Combine date and time
    const [hours, minutes] = formData.value.time.split(':');
    const dateTime = new Date(formData.value.date);
    dateTime.setHours(parseInt(hours), parseInt(minutes), 0, 0);

    const appointmentData = {
      patientId: formData.value.patientId,
      doctorId: formData.value.doctorId,
      dateTime: dateTime.toISOString(),
      serviceType: formData.value.serviceType,
      specialty: formData.value.specialty,
      notes: formData.value.notes,
      phoneNumber: formData.value.phoneNumber,
      emergencyContact: formData.value.emergencyContact,
      status: 'SCHEDULED'
    };

    await api.post('/appointments', appointmentData);
    toast.success('¡Cita reservada exitosamente!');
    
    setTimeout(() => {
      router.push('/');
    }, 2000);
  } catch (error) {
    toast.error('Error al reservar la cita');
  } finally {
    loading.value = false;
  }
};

// Calendar helpers
const selectedDate = ref(new Date());
const currentMonth = ref(new Date());

const daysInMonth = computed(() => {
  const year = currentMonth.value.getFullYear();
  const month = currentMonth.value.getMonth();
  const firstDay = new Date(year, month, 1).getDay();
  const daysCount = new Date(year, month + 1, 0).getDate();
  
  const days = [];
  // Padding for first week
  for (let i = 0; i < firstDay; i++) {
    days.push(null);
  }
  // Actual days
  for (let i = 1; i <= daysCount; i++) {
    days.push(i);
  }
  return days;
});

const selectDate = (day: number | null) => {
  if (!day) return;
  const year = currentMonth.value.getFullYear();
  const month = currentMonth.value.getMonth();
  selectedDate.value = new Date(year, month, day);
  formData.value.date = selectedDate.value.toISOString().split('T')[0];
  loadAvailability();
};

const previousMonth = () => {
  currentMonth.value = new Date(currentMonth.value.getFullYear(), currentMonth.value.getMonth() - 1);
};

const nextMonth = () => {
  currentMonth.value = new Date(currentMonth.value.getFullYear(), currentMonth.value.getMonth() + 1);
};

const monthYearLabel = computed(() => {
  return currentMonth.value.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' });
});

// Initialize
loadSpecialties();
</script>

<template>
  <div class="min-h-screen bg-secondary py-8 px-4">
    <div class="max-w-5xl mx-auto">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-800 mb-2">Reservar una Nueva Cita</h1>
        <p class="text-gray-600">Complete los siguientes pasos para agendar su próxima visita.</p>
      </div>

      <!-- Progress Indicator -->
      <div class="mb-12">
        <div class="flex items-center justify-between max-w-2xl mx-auto">
          <div class="flex flex-col items-center flex-1">
            <div :class="['w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg transition-all', 
                          step >= 1 ? 'bg-primary text-white' : 'bg-gray-200 text-gray-400']">
              1
            </div>
            <span class="text-xs mt-2 font-medium" :class="step >= 1 ? 'text-primary' : 'text-gray-400'">DETALLES</span>
          </div>
          <div class="flex-1 h-1 mx-4" :class="step >= 2 ? 'bg-primary' : 'bg-gray-200'"></div>
          <div class="flex flex-col items-center flex-1">
            <div :class="['w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg transition-all',
                          step >= 2 ? 'bg-primary text-white' : 'bg-gray-200 text-gray-400']">
              2
            </div>
            <span class="text-xs mt-2 font-medium" :class="step >= 2 ? 'text-primary' : 'text-gray-400'">FECHA Y HORA</span>
          </div>
          <div class="flex-1 h-1 mx-4" :class="step >= 3 ? 'bg-primary' : 'bg-gray-200'"></div>
          <div class="flex flex-col items-center flex-1">
            <div :class="['w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg transition-all',
                          step >= 3 ? 'bg-primary text-white' : 'bg-gray-200 text-gray-400']">
              3
            </div>
            <span class="text-xs mt-2 font-medium" :class="step >= 3 ? 'text-primary' : 'text-gray-400'">CONFIRMACIÓN</span>
          </div>
        </div>
      </div>

      <!-- Step 1: Service Details -->
      <div v-show="step === 1" class="card animate-fade-in">
        <h2 class="text-2xl font-bold mb-6">Tipo de Servicio</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
          <div 
            v-for="service in serviceTypes" 
            :key="service.id"
            @click="formData.serviceType = service.id"
            :class="['p-6 border-2 rounded-xl cursor-pointer transition-all hover:shadow-md',
                     formData.serviceType === service.id ? 'border-primary bg-green-50' : 'border-gray-200 bg-white']"
          >
            <div class="text-4xl mb-3">{{ service.icon }}</div>
            <h3 class="font-bold text-gray-800 mb-1">{{ service.label }}</h3>
            <p class="text-sm text-gray-500">{{ service.description }}</p>
          </div>
        </div>

        <h3 class="text-xl font-bold mb-4">Detalles de la Consulta</h3>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Especialidad</label>
            <select 
              v-model="formData.specialty" 
              @change="loadDoctors"
              class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-primary focus:border-primary"
              required
            >
              <option value="">Seleccione especialidad</option>
              <option v-for="spec in specialties" :key="spec" :value="spec">{{ spec }}</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Médico (Opcional)</label>
            <select 
              v-model="formData.doctorId"
              class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-primary focus:border-primary"
            >
              <option :value="null">Cualquier médico disponible</option>
              <option v-for="doc in doctors" :key="doc.id" :value="doc.id">{{ doc.name }}</option>
            </select>
          </div>
        </div>

        <div class="mb-8">
          <label class="block text-sm font-medium text-gray-700 mb-2">Motivo de la Consulta</label>
          <textarea 
            v-model="formData.notes"
            placeholder="Describa brevemente el motivo de su visita..."
            class="w-full border border-gray-300 rounded-lg p-3 h-32 focus:ring-2 focus:ring-primary focus:border-primary resize-none"
          ></textarea>
        </div>

        <div class="flex justify-end gap-4">
          <router-link to="/" class="btn-secondary px-6 py-3">Cancelar</router-link>
          <button @click="goToStep2" class="btn-primary px-8 py-3 flex items-center gap-2">
            Buscar Disponibilidad
            <span>→</span>
          </button>
        </div>
      </div>

      <!-- Step 2: Date & Time -->
      <div v-show="step === 2" class="card animate-fade-in">
        <h2 class="text-2xl font-bold mb-6">Seleccione Fecha y Hora</h2>
        <p class="text-gray-600 mb-6">Elija una fecha disponible en el calendario y luego seleccione un horario.</p>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Calendar -->
          <div>
            <div class="bg-white rounded-xl border border-gray-200 p-4">
              <div class="flex items-center justify-between mb-4">
                <button @click="previousMonth" class="p-2 hover:bg-gray-100 rounded">
                  <span class="text-xl">‹</span>
                </button>
                <h3 class="font-bold text-lg capitalize">{{ monthYearLabel }}</h3>
                <button @click="nextMonth" class="p-2 hover:bg-gray-100 rounded">
                  <span class="text-xl">›</span>
                </button>
              </div>

              <div class="grid grid-cols-7 gap-2 text-center">
                <div v-for="day in ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']" :key="day" class="text-xs font-medium text-gray-500 py-2">
                  {{ day }}
                </div>
                
                <div 
                  v-for="(day, idx) in daysInMonth" 
                  :key="idx"
                  @click="selectDate(day)"
                  :class="['aspect-square flex items-center justify-center rounded-lg cursor-pointer transition-all',
                           day === null ? 'invisible' : '',
                           selectedDate.getDate() === day && selectedDate.getMonth() === currentMonth.getMonth() 
                             ? 'bg-primary text-white font-bold' 
                             : 'hover:bg-gray-100']"
                >
                  {{ day }}
                </div>
              </div>
            </div>
          </div>

          <!-- Time Slots -->
          <div>
            <h3 class="font-bold mb-4">Horarios Disponibles</h3>
            <div v-if="availability.length === 0" class="text-center text-gray-400 py-12">
              Seleccione una fecha para ver horarios disponibles
            </div>
            <div v-else class="grid grid-cols-2 gap-3 max-h-96 overflow-y-auto">
              <button
                v-for="slot in availability"
                :key="slot.time"
                @click="formData.time = slot.time"
                :disabled="!slot.available"
                :class="['p-3 rounded-lg font-medium transition-all',
                         !slot.available ? 'bg-gray-100 text-gray-400 cursor-not-allowed' :
                         formData.time === slot.time ? 'bg-primary text-white' :
                         'bg-white border-2 border-gray-200 hover:border-primary']"
              >
                {{ slot.time }}
              </button>
            </div>
          </div>
        </div>

        <div class="flex justify-between mt-8">
          <button @click="goBack" class="btn-secondary px-6 py-3 flex items-center gap-2">
            <span>←</span>
            Atrás
          </button>
          <button @click="goToStep3" class="btn-primary px-8 py-3 flex items-center gap-2">
            Continuar
            <span>→</span>
          </button>
        </div>
      </div>

      <!-- Step 3: Confirmation -->
      <div v-show="step === 3" class="card animate-fade-in">
        <h2 class="text-2xl font-bold mb-6">Confirmar Cita</h2>
        <p class="text-gray-600 mb-8">Por favor, revise los detalles de su cita y complete la información de contacto.</p>

        <!-- Summary -->
        <div class="bg-gray-50 rounded-xl p-6 mb-8">
          <h3 class="font-bold mb-4 text-lg">Resumen de la Cita</h3>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="flex gap-3">
              <div class="text-primary text-2xl">📅</div>
              <div>
                <p class="text-sm text-gray-500">Fecha y Hora</p>
                <p class="font-bold">{{ formData.date }} a las {{ formData.time }}</p>
              </div>
            </div>

            <div class="flex gap-3">
              <div class="text-primary text-2xl">🏥</div>
              <div>
                <p class="text-sm text-gray-500">Tipo de Servicio</p>
                <p class="font-bold">{{ serviceTypes.find(s => s.id === formData.serviceType)?.label }}</p>
              </div>
            </div>

            <div class="flex gap-3">
              <div class="text-primary text-2xl">🔬</div>
              <div>
                <p class="text-sm text-gray-500">Especialidad</p>
                <p class="font-bold">{{ formData.specialty }}</p>
              </div>
            </div>

            <div class="flex gap-3">
              <div class="text-primary text-2xl">👨‍⚕️</div>
              <div>
                <p class="text-sm text-gray-500">Médico</p>
                <p class="font-bold">{{ doctors.find(d => d.id === formData.doctorId)?.name || 'Cualquier médico disponible' }}</p>
              </div>
            </div>
          </div>

          <div v-if="formData.notes" class="mt-6 flex gap-3">
            <div class="text-primary text-2xl">📝</div>
            <div>
              <p class="text-sm text-gray-500">Motivo de la Consulta</p>
              <p class="text-gray-700">{{ formData.notes }}</p>
            </div>
          </div>
        </div>

        <!-- Contact Information -->
        <h3 class="font-bold mb-4 text-lg">Información de Contacto</h3>
        <p class="text-sm text-gray-600 mb-4">Ingrese un número para recordatorios y un contacto de emergencia.</p>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Número de Teléfono</label>
            <div class="relative">
              <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">📞</span>
              <input 
                type="tel" 
                v-model="formData.phoneNumber"
                placeholder="+1 (555) 123-4567"
                class="w-full border border-gray-300 rounded-lg p-3 pl-10 focus:ring-2 focus:ring-primary focus:border-primary"
                required
              />
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Nombre de Contacto de Emergencia</label>
            <div class="relative">
              <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">👤</span>
              <input 
                type="text" 
                v-model="formData.emergencyContact"
                placeholder="Ej: Juana Pérez"
                class="w-full border border-gray-300 rounded-lg p-3 pl-10 focus:ring-2 focus:ring-primary focus:border-primary"
                required
              />
            </div>
          </div>
        </div>

        <div class="flex justify-between">
          <button @click="goBack" class="btn-secondary px-6 py-3 flex items-center gap-2">
            <span>←</span>
            Atrás
          </button>
          <button 
            @click="submitAppointment" 
            :disabled="loading"
            class="btn-primary px-8 py-3 flex items-center gap-2 disabled:opacity-50"
          >
            <span v-if="loading">Guardando...</span>
            <span v-else>Confirmar Cita ✓</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
