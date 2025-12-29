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
const today = new Date();
const y = today.getFullYear();
const m = String(today.getMonth() + 1).padStart(2, '0');
const d = String(today.getDate()).padStart(2, '0');

const formData = ref({
  serviceTypeId: null as number | null,
  specialty: '',
  doctorId: null as number | null,
  notes: '',
  date: `${y}-${m}-${d}`,
  time: '',
  contactName: '',
  phoneNumber: '',
  patientId: null as number | null
});

// Options
const specialties = ref<string[]>([]);
const doctors = ref<any[]>([]);
const availability = ref<any>({ available: false, message: '' });

// Service types (Filtered based on Guide)
const serviceTypes = ref<any[]>([]);

const loadServiceTypes = async () => {
  try {
    const res = await api.get('/service-types');
    serviceTypes.value = res.data;
  } catch (error) {
    toast.error('Error al cargar tipos de servicio');
  }
};

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

    // If currently selected doctor is not in the new list, clear selection
    if (formData.value.doctorId) {
      const exists = doctors.value.find(d => d.id === formData.value.doctorId);
      if (!exists) {
        formData.value.doctorId = null;
      }
    }
  } catch (error) {
    toast.error('Error al cargar médicos');
  }
};

// When doctor changes, auto-select their specialty
const onDoctorChange = () => {
  if (!formData.value.doctorId) return;
  
  const selectedDoctor = doctors.value.find(d => d.id === formData.value.doctorId);
  if (selectedDoctor && selectedDoctor.specialty) {
    // Only update if different to avoid loop
    if (formData.value.specialty !== selectedDoctor.specialty.name) {
      formData.value.specialty = selectedDoctor.specialty.name;
      // Optionally reload doctors to filter by this specialty, 
      // but we might want to keep the full list visible? 
      // Let's filter to be consistent with "selecting a specialty filters doctors"
      loadDoctors();
    }
  }
};

// Fetch availability
const loadAvailability = async () => {
  if (!formData.value.date || !formData.value.specialty) return;
  
  loading.value = true;
  availability.value = { available: false, message: '' }; // Reset
  
  try {
    const params: any = {
      date: formData.value.date,
      specialty: formData.value.specialty
    };
    if (formData.value.doctorId) params.doctorId = formData.value.doctorId;
    
    const res = await api.get('/availability', { params });
    availability.value = res.data;
    
    // Auto-set time if available (required for backend)
    if (availability.value.available) {
      formData.value.time = '08:00';
    } else {
      formData.value.time = '';
    }
  } catch (error) {
    toast.error('Error al cargar disponibilidad');
  } finally {
    loading.value = false;
  }
};

// ... (rest of the file)

// In template:
// <select v-model="formData.doctorId" @change="onDoctorChange" ...>

// Step navigation
const goToStep2 = async () => {
  console.log('Validating Step 1:', JSON.parse(JSON.stringify(formData.value)));
  if (!formData.value.serviceTypeId || !formData.value.specialty) {
    console.log('Validation failed:', { serviceTypeId: formData.value.serviceTypeId, specialty: formData.value.specialty });
    toast.warning('Por favor complete todos los campos requeridos');
    return;
  }
  step.value = 2;
  // Auto-load availability for the pre-selected current date
  if (formData.value.date) {
    loadAvailability();
  }
};

const goToStep3 = () => {
  if (!formData.value.date) {
    toast.warning('Por favor seleccione una fecha');
    return;
  }
  if (!availability.value.available) {
    toast.warning('No hay cupos disponibles para esta fecha');
    return;
  }
  step.value = 3;
};

const goBack = () => {
  if (step.value > 1) step.value--;
};

// Submit appointment
const submitAppointment = async () => {
  if (!formData.value.contactName || !formData.value.phoneNumber) {
    toast.warning('Por favor complete la información de contacto');
    return;
  }

  loading.value = true;
  try {
    // Combine date and time correctly to avoid timezone shifts
    const dateTime = new Date(`${formData.value.date}T${formData.value.time}:00`);

    const appointmentData = {
      patientId: formData.value.patientId,
      doctorId: formData.value.doctorId,
      dateTime: dateTime.toISOString(),
      serviceTypeId: formData.value.serviceTypeId,
      specialty: formData.value.specialty,
      notes: formData.value.notes,
      contactName: formData.value.contactName,
      phoneNumber: formData.value.phoneNumber,
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
  // Padding for first week (Monday start)
  const padding = (firstDay + 6) % 7;
  for (let i = 0; i < padding; i++) {
    days.push(null);
  }
  // Actual days
  for (let i = 1; i <= daysCount; i++) {
    days.push(i);
  }
  return days;
});

const isDayAvailable = (day: number | null) => {
  if (!day) return false;
  
  const year = currentMonth.value.getFullYear();
  const month = currentMonth.value.getMonth();
  // Use local date construction to match selectDate logic
  const date = new Date(year, month, day);
  const dayOfWeek = date.getDay(); // 0 = Sunday, 1 = Monday, ..., 6 = Saturday

  // If a doctor is selected, check their specific schedule
  if (formData.value.doctorId) {
    const doctor = doctors.value.find(d => Number(d.id) === Number(formData.value.doctorId));
    if (doctor && doctor.schedules && doctor.schedules.length > 0) {
      return doctor.schedules.some((s: any) => s.dayOfWeek === dayOfWeek && s.isActive);
    }
    // If doctor has no schedules defined, they might not be available at all
    return false;
  } 
  
  // If no doctor is selected, check if ANY doctor in the specialty is available on that day
  if (doctors.value.length > 0) {
    return doctors.value.some(doc => 
      doc.schedules && doc.schedules.some((s: any) => s.dayOfWeek === dayOfWeek && s.isActive)
    );
  }

  return true; // Default to true if no data yet
};

const selectDate = (day: number | null) => {
  if (!day || !isDayAvailable(day)) return;
  const year = currentMonth.value.getFullYear();
  const month = currentMonth.value.getMonth();
  selectedDate.value = new Date(year, month, day);
  
  // Format as YYYY-MM-DD using local components to avoid timezone shifts
  const y = selectedDate.value.getFullYear();
  const m = String(selectedDate.value.getMonth() + 1).padStart(2, '0');
  const d = String(selectedDate.value.getDate()).padStart(2, '0');
  formData.value.date = `${y}-${m}-${d}`;
  
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

// Initial load
loadServiceTypes();
loadSpecialties();
loadDoctors();
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
        
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
          <div 
            v-for="type in serviceTypes" 
            :key="type.id"
            @click="formData.serviceTypeId = type.id"
            :class="['p-4 rounded-xl border-2 cursor-pointer transition-all hover:shadow-md',
                     formData.serviceTypeId === type.id ? 'border-primary bg-primary/5 shadow-inner' : 'border-gray-100 bg-white']"
          >
            <div class="text-3xl mb-2">{{ type.icon }}</div>
            <h4 class="font-bold text-gray-900">{{ type.name }}</h4>
            <p class="text-xs text-gray-500 mt-1">{{ type.description }}</p>
          </div>
        </div>

        <h3 :class="['text-xl font-bold mb-4 transition-opacity', !formData.serviceTypeId ? 'opacity-50' : 'opacity-100']">
          Detalles de la Consulta
        </h3>
        
        <div :class="['grid grid-cols-1 md:grid-cols-2 gap-6 mb-6 transition-opacity', !formData.serviceTypeId ? 'opacity-50' : 'opacity-100']">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Especialidad</label>
            <select 
              v-model="formData.specialty" 
              @change="loadDoctors"
              class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-primary focus:border-primary disabled:bg-gray-50 disabled:cursor-not-allowed"
              :disabled="!formData.serviceTypeId"
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
              @change="onDoctorChange"
              class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-primary focus:border-primary disabled:bg-gray-50 disabled:cursor-not-allowed"
              :disabled="!formData.serviceTypeId"
            >
              <option :value="null">Cualquier médico disponible</option>
              <option v-for="doc in doctors" :key="doc.id" :value="doc.id">{{ doc.name }}</option>
            </select>
          </div>
        </div>

        <div :class="['mb-8 transition-opacity', !formData.serviceTypeId ? 'opacity-50' : 'opacity-100']">
          <label class="block text-sm font-medium text-gray-700 mb-2">Motivo de la Consulta</label>
          <textarea 
            v-model="formData.notes"
            placeholder="Describa brevemente el motivo de su visita..."
            class="w-full border border-gray-300 rounded-lg p-3 h-32 focus:ring-2 focus:ring-primary focus:border-primary resize-none disabled:bg-gray-50 disabled:cursor-not-allowed"
            :disabled="!formData.serviceTypeId"
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
        <h2 class="text-2xl font-bold mb-6">Seleccione Fecha</h2>
        <p class="text-gray-600 mb-6">Elija una fecha disponible en el calendario. La atención es por orden de llegada.</p>

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
                  :class="['aspect-square flex items-center justify-center rounded-lg transition-all',
                           day === null ? 'invisible' : 'cursor-pointer',
                           day !== null && !isDayAvailable(day) ? 'text-gray-300 cursor-not-allowed' : '',
                           selectedDate.getDate() === day && selectedDate.getMonth() === currentMonth.getMonth() && isDayAvailable(day)
                             ? 'bg-primary text-white font-bold' 
                             : day !== null && isDayAvailable(day) ? 'hover:bg-gray-100' : '']"
                >
                  {{ day }}
                </div>
              </div>
            </div>
          </div>

          <!-- Availability Status -->
          <div>
            <h3 class="font-bold mb-4 text-lg">Estado de Disponibilidad</h3>
            
            <div v-if="!formData.date" class="text-center text-gray-400 py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-200">
              <div class="text-4xl mb-2">📅</div>
              <p>Seleccione una fecha en el calendario para verificar cupos disponibles</p>
            </div>
            
            <div v-else-if="loading" class="text-center py-12 bg-gray-50 rounded-xl border border-gray-100">
              <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4"></div>
              <p class="text-gray-600 font-medium">Consultando disponibilidad en tiempo real...</p>
            </div>

            <div v-else class="space-y-6">
               <div 
                 :class="['p-8 rounded-2xl border-2 text-center transition-all shadow-sm',
                          availability.available ? 'bg-green-50 border-green-200 text-green-900' : 'bg-red-50 border-red-200 text-red-900']"
               >
                 <div class="text-5xl mb-4">{{ availability.available ? '✅' : '❌' }}</div>
                 <h4 class="text-2xl font-black mb-2">{{ availability.available ? '¡Cupos Disponibles!' : 'Sin Disponibilidad' }}</h4>
                 <p class="text-lg font-medium opacity-90">{{ availability.message }}</p>
                 
                 <div v-if="availability.available" class="mt-4 inline-block bg-green-600 text-white px-4 py-1 rounded-full text-sm font-bold">
                   Atención por orden de llegada
                 </div>
               </div>

               <div v-if="availability.available" class="bg-blue-50 p-5 rounded-xl border border-blue-100 text-blue-900 shadow-sm">
                 <div class="flex gap-3">
                   <span class="text-xl">ℹ️</span>
                   <div>
                     <p class="font-bold mb-1 text-sm">Información de Atención</p>
                     <p class="text-xs leading-relaxed">Para este servicio no se asignan horarios fijos. Una vez confirmada su cita, puede acercarse al centro médico en el horario de atención del servicio seleccionado.</p>
                   </div>
                 </div>
               </div>
            </div>
          </div>
        </div>

        <div class="flex justify-between mt-8">
          <button @click="goBack" class="btn-secondary px-6 py-3 flex items-center gap-2">
            <span>←</span>
            Atrás
          </button>
          <button 
            @click="goToStep3" 
            :disabled="!availability.available"
            class="btn-primary px-8 py-3 flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
          >
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
                <p class="text-sm text-gray-500">Fecha</p>
                <p class="font-bold">{{ formData.date }}</p>
              </div>
            </div>

            <div class="flex gap-3">
              <div class="text-primary text-2xl">🏥</div>
              <div>
                <p class="text-sm text-gray-500">Tipo de Servicio</p>
                <p class="font-bold">{{ serviceTypes.find(s => s.id === formData.serviceTypeId)?.name }}</p>
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
        <p class="text-sm text-gray-600 mb-4">Ingrese un nombre y número para su cita.</p>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Nombre de Contacto</label>
            <div class="relative">
              <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">👤</span>
              <input 
                type="text" 
                v-model="formData.contactName"
                placeholder="Ej: Juan Pérez"
                class="w-full border border-gray-300 rounded-lg p-3 pl-10 focus:ring-2 focus:ring-primary focus:border-primary"
                required
              />
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Teléfono de Contacto</label>
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
