<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import api from '../services/api';
import { useToast } from "vue-toastification";
import { websocketService } from '../services/websocket.service';
import GlobalHeader from '../components/common/GlobalHeader.vue';

const toast = useToast();
const showSuccess = ref(false);
const showVerification = ref(false);
const documentId = ref('');
const loading = ref(false);
const ticket = ref('');
const showTable = ref(true);
const todayAppointments = ref<any[]>([]);
const selectedAppointment = ref<any>(null);
const searchQuery = ref('');

const filteredAppointments = computed(() => {
  let filtered = todayAppointments.value;
  
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(app => 
      app.contactName?.toLowerCase().includes(query) ||
      app.doctor?.name?.toLowerCase().includes(query) ||
      app.phoneNumber?.toLowerCase().includes(query) ||
      app.serviceType?.name?.toLowerCase().includes(query) ||
      app.patient?.name?.toLowerCase().includes(query) ||
      app.patient?.documentNumber?.includes(query)
    );
  }

  // Sort: SCHEDULED first (by dateTime), then CHECKED_IN (by checkinTime)
  return [...filtered].sort((a, b) => {
    // 1. Status priority: SCHEDULED (0) > CHECKED_IN (1)
    const statusOrder = { 'SCHEDULED': 0, 'CHECKED_IN': 1 };
    const aOrder = statusOrder[a.status as keyof typeof statusOrder] ?? 2;
    const bOrder = statusOrder[b.status as keyof typeof statusOrder] ?? 2;

    if (aOrder !== bOrder) {
      return aOrder - bOrder;
    }

    // 2. Time sorting within same status
    if (a.status === 'SCHEDULED') {
      return new Date(a.dateTime).getTime() - new Date(b.dateTime).getTime();
    } else if (a.status === 'CHECKED_IN') {
      const aTime = a.checkinTime ? new Date(a.checkinTime).getTime() : 0;
      const bTime = b.checkinTime ? new Date(b.checkinTime).getTime() : 0;
      return aTime - bTime; // Oldest first (first to arrive)
    }

    return 0;
  });
});

// Extracted data from document
const extractedData = ref({
  documentId: '',
  fullName: '',
  birthDate: '',
  sex: '',
  address: ''
});

// Calculate age from birthdate
const calculatedAge = computed(() => {
  if (!extractedData.value.birthDate) return '';
  
  try {
    // Parse DD/MM/YYYY format
    const parts = extractedData.value.birthDate.split('/');
    if (parts.length !== 3) return '';
    
    const birthDate = new Date(
      parseInt(parts[2]), // year
      parseInt(parts[1]) - 1, // month (0-indexed)
      parseInt(parts[0]) // day
    );
    
    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
    
    return `${age} años`;
  } catch (error) {
    return '';
  }
});

// Camera functionality
const showCamera = ref(false);
const showUploadFallback = ref(false);
const isScanningBack = ref(false);
const videoRef = ref<HTMLVideoElement | null>(null);
const canvasRef = ref<HTMLCanvasElement | null>(null);
const stream = ref<MediaStream | null>(null);
const processingImage = ref(false);
const fileInputRef = ref<HTMLInputElement | null>(null);

// Smart scan - detects camera availability and chooses best option
const smartScan = async (scanningBack: boolean | Event = false) => {
  const isBack = typeof scanningBack === 'boolean' ? scanningBack : false;
  isScanningBack.value = isBack;

  // Try to open camera directly. This triggers permission prompt if needed.
  const success = await startCamera();
  
  if (!success) {
    // If camera fails, show fallback modal to ask user to upload manually
    // We cannot open file picker automatically due to browser security blocking async clicks
    console.log('Camera not available or denied, showing fallback modal');
    showUploadFallback.value = true;
  }
};

const startCamera = async (): Promise<boolean> => {
  // Check if browser supports mediaDevices (often undefined in insecure contexts like http://IP)
  if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
    console.warn('Media Devices API not available. Likely due to insecure context (HTTP) or unsupported browser.');
    return false;
  }

  try {
    stream.value = await navigator.mediaDevices.getUserMedia({ 
      video: { facingMode: 'environment' } // Use back camera on mobile
    });
    
    showCamera.value = true;
    
    // Wait for next tick to ensure video element exists
    setTimeout(() => {
      if (videoRef.value && stream.value) {
        videoRef.value.srcObject = stream.value;
      }
    }, 100);
    
    return true;
  } catch (error) {
    console.error('Camera error:', error);
    return false;
  }
};

const stopCamera = () => {
  if (stream.value) {
    stream.value.getTracks().forEach(track => track.stop());
    stream.value = null;
  }
  showCamera.value = false;
};

const processImageFile = async (file: File) => {
  processingImage.value = true;
  
  try {
    // Convert file to base64 and compress
    const reader = new FileReader();
    
    reader.onload = async (e) => {
      console.log('File read successfully, creating image object');
      try {
        const img = new Image();
        
        img.onload = async () => {
          console.log('Image loaded successfully, dimensions:', img.width, 'x', img.height);
          // Create canvas for compression
          const canvas = document.createElement('canvas');
          const ctx = canvas.getContext('2d');
          
          if (!ctx) {
            toast.error('Error al procesar la imagen');
            processingImage.value = false;
            return;
          }
          
          // Calculate new dimensions (max 1920px width)
          let width = img.width;
          let height = img.height;
          const maxWidth = 1920;
          
          if (width > maxWidth) {
            height = (height * maxWidth) / width;
            width = maxWidth;
          }
          
          canvas.width = width;
          canvas.height = height;
          
          // Draw and compress
          ctx.drawImage(img, 0, 0, width, height);
          
          // Convert to JPEG with quality 0.7
          const compressedBase64 = canvas.toDataURL('image/jpeg', 0.7);
          
          // Send to AI vision API for full data extraction
          const response = await api.post('/vision/analyze-document', {
            image: compressedBase64
          });
          
          const newData = response.data;

          if (isScanningBack.value) {
            // Merge mode: Update address if found, keep other data
            if (newData.address) {
              extractedData.value.address = newData.address;
              toast.success('Dirección detectada y actualizada');
            } else {
              toast.warning('No se pudo detectar la dirección en la imagen');
            }
            showVerification.value = true;
          } else {
            // New scan mode: Validate ID
            if (!newData.documentId) {
              throw new Error('No se pudo detectar el número de documento. Intente nuevamente con una imagen más clara.');
            }

            // Sanitize ID: remove any non-digit characters
            const sanitizedId = newData.documentId.replace(/\D/g, '');
            console.log('Document ID detected:', sanitizedId);

            if (sanitizedId.length < 8) {
               throw new Error(`Documento inválido detectado (${sanitizedId}). Intente nuevamente.`);
            }

            extractedData.value = {
              documentId: sanitizedId,
              fullName: newData.fullName,
              birthDate: newData.birthDate,
              sex: newData.sex,
              address: newData.address || ''
            };

            // Auto-checkin flow - DISABLED per user request to see verification
            // documentId.value = sanitizedId;
            // toast.info(`Documento detectado: ${sanitizedId}. Verificando cita...`);
            
            // Close camera if open
            stopCamera();
            
            // Show verification screen instead of auto-checkin
            showVerification.value = true;
            
            // Proceed immediately to check-in
            // console.log('Triggering auto-checkin for:', sanitizedId);
            // await performCheckin();
          }
          
          isScanningBack.value = false;
        };

        img.onerror = () => {
          console.error('Image object failed to load');
          toast.error('Error al cargar la imagen. El archivo podría estar corrupto.');
          processingImage.value = false;
        };

        img.src = e.target?.result as string;
      } catch (error: any) {
        console.error('Vision AI error:', error);
        toast.error(error.response?.data?.error || error.message || 'Error al analizar la imagen');
      } finally {
        processingImage.value = false;
      }
    };
    
    reader.onerror = () => {
      toast.error('Error al leer el archivo');
      processingImage.value = false;
    };
    
    reader.readAsDataURL(file);
  } catch (error: any) {
    console.error('File processing error:', error);
    toast.error('Error al procesar la imagen');
    processingImage.value = false;
  }
};

const handleFileSelect = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];
  console.log('File selected:', file ? `${file.name} (${file.type})` : 'none');
  
  if (file) {
    if (!file.type.startsWith('image/')) {
      toast.error('Por favor selecciona una imagen válida');
      return;
    }
    
    processImageFile(file);
  }
};

const openFileSelector = () => {
  fileInputRef.value?.click();
};

const capturePhoto = async () => {
  if (!videoRef.value || !canvasRef.value) return;
  
  processingImage.value = true;
  
  try {
    const canvas = canvasRef.value;
    const video = videoRef.value;
    
    // Set canvas to video dimensions
    let width = video.videoWidth;
    let height = video.videoHeight;
    
    // Limit size for performance
    const maxWidth = 1920;
    if (width > maxWidth) {
      height = (height * maxWidth) / width;
      width = maxWidth;
    }
    
    canvas.width = width;
    canvas.height = height;
    
    // Draw video frame to canvas
    const ctx = canvas.getContext('2d');
    if (ctx) {
      ctx.drawImage(video, 0, 0, width, height);
      
      // Convert canvas to base64 with compression
      const imageBase64 = canvas.toDataURL('image/jpeg', 0.7);
      
      // Send to AI vision API for full data extraction
      const response = await api.post('/vision/analyze-document', {
        image: imageBase64
      });
      
      const newData = response.data;

      if (isScanningBack.value) {
        // Merge mode: Update address if found
        if (newData.address) {
          extractedData.value.address = newData.address;
          toast.success('Dirección detectada y actualizada');
        } else {
          toast.warning('No se pudo detectar la dirección en la imagen');
        }
        showVerification.value = true;
      } else {
        // New scan mode: Validate ID
        if (!newData.documentId) {
          throw new Error('No se pudo detectar el número de documento. Intente nuevamente.');
        }

        // Sanitize ID
        const sanitizedId = newData.documentId.replace(/\D/g, '');
        console.log('Document ID detected (Camera):', sanitizedId);

        if (sanitizedId.length < 8) {
            throw new Error(`Documento inválido detectado (${sanitizedId}). Intente nuevamente.`);
        }

        extractedData.value = {
          documentId: sanitizedId,
          fullName: newData.fullName,
          birthDate: newData.birthDate,
          sex: newData.sex,
          address: newData.address || ''
        };

        // Auto-checkin flow - DISABLED per user request to see verification
        // documentId.value = sanitizedId;
        // toast.info(`Documento detectado: ${sanitizedId}. Verificando cita...`);
        
        stopCamera();
        
        // Show verification screen
        showVerification.value = true;
        
        // Proceed immediately to check-in
        // console.log('Triggering auto-checkin (Camera) for:', sanitizedId);
        // await performCheckin();
      }
      
      isScanningBack.value = false;
    }
  } catch (error: any) {
    console.error('Vision AI error:', error);
    toast.error(error.response?.data?.error || 'Error al analizar la imagen');
  } finally {
    processingImage.value = false;
  }
};

const performCheckin = async () => {
  if (!documentId.value || documentId.value.length < 8 || documentId.value.length > 9) {
    toast.warning('Por favor ingrese un DNI (8 dígitos) o Carnet de Extranjería (9 dígitos) válido');
    return;
  }

  loading.value = true;
  try {
    // 1. Find or Create Patient
    let patient = null;
    const resPatient = await api.get(`/patients?documentId=${documentId.value}`);
    
    if (resPatient.data.length === 0) {
      // If not found and we have extracted data, create patient
      if (extractedData.value.fullName && extractedData.value.documentId === documentId.value) {
        const newPatientRes = await api.post('/patients', {
          name: extractedData.value.fullName,
          dni: extractedData.value.documentId,
          documentNumber: extractedData.value.documentId,
          birthDate: extractedData.value.birthDate ? extractedData.value.birthDate.split('/').reverse().join('-') : null,
          // Add other fields if needed
        });
        patient = newPatientRes.data;
        toast.info('Nuevo paciente registrado automáticamente.');
      } else {
        toast.error('Paciente no encontrado. Por favor verifique su documento o escanee su ID.');
        loading.value = false;
        return;
      }
    } else {
      patient = resPatient.data[0];
    }
    
    // 2. Find Today's Appointments
    // If we have a selectedAppointment, we use that. 
    // Otherwise, we look for appointments for this patient (but wait, new appointments don't have patientId yet!)
    // So if no selectedAppointment, we search by contact name or phone? 
    // Actually, the user flow is: select from table -> scan. So selectedAppointment should be set.
    
    let appointment = selectedAppointment.value;
    
    if (!appointment) {
      // Fallback: search for appointments for today that match this patient's document (if already associated)
      const now = new Date();
      const today = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
      const resApps = await api.get(`/appointments?patientId=${patient.id}&date=${today}`);
      const scheduledAppointments = resApps.data.filter((a: any) => a.status === 'SCHEDULED');
      
      if (scheduledAppointments.length === 0) {
        toast.warning('No tiene citas programadas para hoy o ya realizó el check-in.');
        loading.value = false;
        return;
      }
      appointment = scheduledAppointments[0];
    }
    
    // 3. Perform Check-in with patient association
    const resCheckin = await api.post(`/appointments/${appointment.id}/checkin`, {
      patientId: patient.id
    });
    ticket.value = resCheckin.data.ticketNumber;
    
    // Show success screen
    showSuccess.value = true;
    
    // Auto-reset after 5 seconds
    setTimeout(() => {
      reset();
    }, 5000);
    
  } catch (error: any) {
    console.error(error);
    toast.error('Error al realizar check-in. Intente nuevamente.');
  } finally {
    loading.value = false;
  }
};

const fetchTodayAppointments = async () => {
  loading.value = true;
  try {
    const now = new Date();
    const today = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
    const res = await api.get(`/appointments?date=${today}`);
    // Show scheduled and checked-in appointments
    todayAppointments.value = res.data.filter((a: any) => a.status === 'SCHEDULED' || a.status === 'CHECKED_IN');
  } catch (error) {
    console.error('Error fetching today appointments:', error);
    toast.error('Error al cargar las citas de hoy');
  } finally {
    loading.value = false;
  }
};

const selectAppointment = (app: any) => {
  selectedAppointment.value = app;
  showTable.value = false;
  // Pre-fill document ID if we want to be helpful, but user said "enviar al escaneo"
  // documentId.value = app.patient?.documentNumber || '';
};

onMounted(() => {
  fetchTodayAppointments();
  
  // Listen for new appointments via WebSocket
  websocketService.on('appointment:updated', (appointment: any) => {
    console.log('📅 New appointment received via WebSocket:', appointment);
    
    // Check if it's for today
    const aptDate = new Date(appointment.dateTime);
    const appointmentDate = `${aptDate.getFullYear()}-${String(aptDate.getMonth() + 1).padStart(2, '0')}-${String(aptDate.getDate()).padStart(2, '0')}`;
    const now = new Date();
    const today = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

    
    if (appointmentDate === today) {
      // Check if appointment already exists in list
      const existingIndex = todayAppointments.value.findIndex(a => a.id === appointment.id);
      
      if (existingIndex >= 0) {
        // Update existing appointment
        todayAppointments.value[existingIndex] = appointment;
      } else {
        // Add new appointment if it's SCHEDULED or CHECKED_IN
        if (appointment.status === 'SCHEDULED' || appointment.status === 'CHECKED_IN') {
          todayAppointments.value.push(appointment);
          toast.success(`Nueva cita agregada: ${appointment.contactName}`);
        }
      }
    }
  });
});

const confirmAndCheckin = async () => {
  // Use extracted document ID for check-in
  documentId.value = extractedData.value.documentId;
  showVerification.value = false;
  await performCheckin();
};

const reset = () => {
  showSuccess.value = false;
  showVerification.value = false;
  documentId.value = '';
  ticket.value = '';
  extractedData.value = {
    documentId: '',
    fullName: '',
    birthDate: '',
    sex: '',
    address: ''
  };
  stopCamera();
  showTable.value = true;
  selectedAppointment.value = null;
  fetchTodayAppointments();
};

const handleKeyPress = (e: KeyboardEvent) => {
  if (e.key === 'Enter') {
    performCheckin();
  }
};

// Cleanup on component unmount
onUnmounted(() => {
  stopCamera();
});
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <GlobalHeader />

    <!-- Main Content: Appointment Table -->
    <div v-if="showTable && !showSuccess && !showVerification" class="flex-1 p-8 overflow-auto bg-gray-50/50">
      <div class="max-w-6xl mx-auto space-y-8 animate-fade-in">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 class="text-4xl font-bold text-onkos-dark-blue mb-2">Citas para Hoy</h1>
            <p class="text-lg text-onkos-medium-blue">Busca tu nombre y selecciona tu cita para confirmar tu llegada.</p>
          </div>
          <div class="flex items-center gap-4">
            <div class="relative">
              <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">🔍</span>
              <input 
                v-model="searchQuery"
                type="text" 
                placeholder="Buscar por nombre o DNI..." 
                class="pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none w-64 md:w-80 shadow-sm"
              />
            </div>
            <button @click="fetchTodayAppointments" class="flex items-center gap-2 px-6 py-3 bg-white border border-gray-200 rounded-xl shadow-sm hover:bg-gray-50 transition-all font-medium text-gray-700">
              <span :class="{ 'animate-spin': loading }">🔄</span>
              Actualizar
            </button>
          </div>
        </div>

        <div v-if="loading && todayAppointments.length === 0" class="flex flex-col items-center justify-center py-32 space-y-4">
          <div class="animate-spin rounded-full h-16 w-16 border-4 border-primary border-t-transparent"></div>
          <p class="text-gray-500 font-medium">Cargando citas...</p>
        </div>

        <div v-else-if="todayAppointments.length === 0" class="text-center py-32 bg-white rounded-3xl border-2 border-dashed border-gray-200 shadow-inner">
          <div class="text-6xl mb-4">📅</div>
          <p class="text-xl text-gray-400 font-medium">No hay citas programadas para hoy.</p>
          <p class="text-gray-400 text-sm mt-1">Si crees que esto es un error, por favor consulta en recepción.</p>
        </div>

        <div v-else class="bg-white rounded-3xl border border-gray-100 shadow-sm overflow-hidden">
          <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="bg-gray-50/50 border-b border-gray-100">
                  <th class="px-3 py-3 text-xs font-bold text-gray-400 uppercase tracking-wider">Hora</th>
                  <th class="px-3 py-3 text-xs font-bold text-gray-400 uppercase tracking-wider">Paciente</th>
                  <th class="px-3 py-3 text-xs font-bold text-gray-400 uppercase tracking-wider">Contacto</th>
                  <th class="px-3 py-3 text-xs font-bold text-gray-400 uppercase tracking-wider">Servicio</th>
                  <th class="px-3 py-3 text-xs font-bold text-gray-400 uppercase tracking-wider">Médico</th>
                  <th class="px-3 py-3 text-xs font-bold text-gray-400 uppercase tracking-wider text-right">Acción</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-50">
                <tr 
                  v-for="app in filteredAppointments" 
                  :key="app.id"
                  class="hover:bg-gray-50/50 transition-colors group"
                >
                  <td class="px-3 py-3 whitespace-nowrap">
                    <div v-if="app.status === 'CHECKED_IN' && app.checkinTime" class="flex items-center gap-1 text-primary font-bold text-sm">
                      <span>🕒</span>
                      {{ new Date(app.checkinTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }}
                    </div>
                    <div v-else-if="app.status === 'SCHEDULED'" class="flex items-center gap-1 text-gray-400 text-sm">
                      <span>📅</span>
                      <span class="text-xs italic">Pendiente</span>
                    </div>
                  </td>
                  <td class="px-3 py-3 whitespace-nowrap">
                    <div v-if="app.status === 'CHECKED_IN'" class="font-bold text-gray-900 text-sm">{{ app.patient?.name }}</div>
                    <div v-else class="text-gray-400 italic text-xs">Pendiente</div>
                  </td>
                  <td class="px-3 py-3 whitespace-nowrap">
                    <div class="flex items-center gap-2">
                      <span class="font-bold text-gray-900 text-sm">{{ app.contactName }}</span>
                      <span class="text-xs text-gray-400 font-mono">({{ app.phoneNumber }})</span>
                    </div>
                  </td>
                  <td class="px-3 py-3 whitespace-nowrap">
                    <div class="flex items-center gap-2">
                      <span class="text-base">{{ app.serviceType?.icon || '🏥' }}</span>
                      <span class="text-sm font-semibold text-gray-700">{{ app.serviceType?.name }}</span>
                    </div>
                  </td>
                  <td class="px-3 py-3 whitespace-nowrap">
                    <div class="text-sm font-medium text-gray-800">{{ app.doctor?.name || 'Por asignar' }}</div>
                  </td>
                  <td class="px-3 py-3 text-right whitespace-nowrap">
                    <button 
                      v-if="app.status === 'SCHEDULED'"
                      @click="selectAppointment(app)"
                      class="px-3 py-1.5 bg-primary/10 text-primary hover:bg-primary hover:text-white rounded-lg font-bold transition-all text-xs whitespace-nowrap"
                    >
                      Check-in →
                    </button>
                    <div v-else-if="app.status === 'CHECKED_IN'" class="inline-block px-3 py-1.5 bg-orange-100 text-orange-600 rounded-lg font-bold text-xs">
                      Checked in
                    </div>
                  </td>
                </tr>
                <tr v-if="filteredAppointments.length === 0">
                  <td colspan="6" class="px-6 py-12 text-center text-gray-400 italic">
                    No se encontraron citas que coincidan con "{{ searchQuery }}"
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content: Scanning (Step 2) -->
    <div v-if="!showTable && !showSuccess && !showVerification" class="flex-1 flex items-center justify-center p-8 bg-white">
      <div class="max-w-2xl w-full text-center space-y-12 animate-fade-in">
        <div class="flex justify-start">
          <button @click="showTable = true" class="group flex items-center gap-2 px-4 py-2 text-gray-500 hover:text-primary transition-colors font-medium">
            <span class="group-hover:-translate-x-1 transition-transform">←</span>
            Volver a la lista de citas
          </button>
        </div>
        <!-- Title -->
        <div>
          <div class="inline-block p-4 bg-primary/10 rounded-3xl mb-6">
            <span class="text-4xl">🆔</span>
          </div>
          <h1 class="text-5xl font-bold text-onkos-dark-blue mb-4">Confirmar Identidad</h1>
          <p class="text-xl text-onkos-medium-blue">Hola <strong>{{ selectedAppointment?.contactName }}</strong>, por favor escanea tu documento para confirmar tu llegada.</p>
        </div>

        <!-- ID Card Icon - CLICKABLE -->
        <div class="flex justify-center py-8">
          <button 
            @click="smartScan"
            :disabled="processingImage"
            class="relative group transition-all duration-300 hover:scale-105 focus:outline-none focus:ring-4 focus:ring-primary/30 rounded-3xl disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <!-- ID Card Illustration -->
            <svg width="280" height="180" viewBox="0 0 240 160" fill="none" xmlns="http://www.w3.org/2000/svg" class="drop-shadow-2xl group-hover:drop-shadow-xl transition-all">
              <!-- Card Background -->
              <rect x="10" y="15" width="220" height="130" rx="12" fill="#FCFCFC" stroke="#223675" stroke-width="3" class="group-hover:fill-onkos-light-blue/10 transition-colors"/>
              
              <!-- Photo placeholder -->
              <rect x="25" y="30" width="60" height="75" rx="6" fill="#D1D5DB" class="group-hover:fill-gray-400 transition-colors"/>
              <circle cx="55" cy="55" r="15" fill="#9CA3AF"/>
              <path d="M55 70 Q40 90, 55 95 Q70 90, 55 70" fill="#9CA3AF"/>
              
              <!-- Text lines -->
              <rect x="100" y="35" width="110" height="8" rx="4" fill="#223675" opacity="0.6"/>
              <rect x="100" y="50" width="90" height="6" rx="3" fill="#9CA3AF"/>
              <rect x="100" y="63" width="100" height="6" rx="3" fill="#9CA3AF"/>
              <rect x="100" y="76" width="70" height="6" rx="3" fill="#9CA3AF"/>
              
              <!-- Barcode -->
              <rect x="25" y="115" width="190" height="20" rx="4" fill="white" stroke="#223675" stroke-width="2"/>
              <line x1="35" y1="120" x2="35" y2="130" stroke="#223675" stroke-width="2"/>
              <line x1="45" y1="120" x2="45" y2="130" stroke="#223675" stroke-width="3"/>
              <line x1="55" y1="120" x2="55" y2="130" stroke="#223675" stroke-width="1"/>
              <line x1="65" y1="120" x2="65" y2="130" stroke="#223675" stroke-width="2"/>
              <line x1="75" y1="120" x2="75" y2="130" stroke="#223675" stroke-width="3"/>
              <line x1="85" y1="120" x2="85" y2="130" stroke="#223675" stroke-width="2"/>
              <line x1="95" y1="120" x2="95" y2="130" stroke="#223675" stroke-width="1"/>
              <line x1="105" y1="120" x2="105" y2="130" stroke="#223675" stroke-width="3"/>
              
              <!-- Scan effect on hover -->
              <line x1="0" y1="75" x2="240" y2="75" stroke="#CEEAC7" stroke-width="2" opacity="0" class="group-hover:opacity-40 transition-opacity scan-line"/>
            </svg>
            
            <!-- Hover overlay text -->
            <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
              <div class="bg-primary text-white px-6 py-3 rounded-full font-semibold text-lg shadow-xl">
                📸 Escanear
              </div>
            </div>
          </button>
        </div>

        <!-- Input Field -->
        <div class="max-w-md mx-auto space-y-6">
          <div class="text-center mb-4">
            <p class="text-sm text-gray-500">O ingresa tu número manualmente:</p>
          </div>
          
          <div class="relative">
            <div class="absolute left-5 top-1/2 -translate-y-1/2 text-primary text-2xl">
              🔢
            </div>
            <input 
              type="text" 
              v-model="documentId"
              @keypress="handleKeyPress"
              placeholder="DNI o Carnet"
              class="w-full text-center text-3xl py-6 pl-16 pr-6 border-2 border-gray-200 rounded-2xl focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all outline-none tracking-widest font-bold text-gray-700 placeholder-gray-300"
              :disabled="loading || processingImage"
            />
          </div>
          
          <button 
            @click="performCheckin" 
            :disabled="loading || !documentId || processingImage"
            class="w-full bg-primary text-white py-5 text-xl font-semibold rounded-2xl hover:bg-opacity-90 transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-lg hover:shadow-xl transform hover:-translate-y-0.5"
          >
            <span v-if="loading">Verificando...</span>
            <span v-else>Continuar ✓</span>
          </button>
          

          
          <!-- Processing indicator -->
          <div v-if="processingImage" class="text-center">
            <div class="flex items-center justify-center gap-3 text-primary">
              <svg class="animate-spin h-8 w-8" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <span class="text-lg font-semibold">Analizando imagen con IA...</span>
            </div>
          </div>
        </div>

        <!-- Help Text -->
        <div class="text-sm text-gray-500 space-y-2 text-center">
          <p class="font-medium">Haz clic en la credencial para escanear automáticamente</p>
          <p class="text-xs">El sistema detectará si usar cámara o archivo</p>
          <p class="text-xs">¿Necesitas ayuda? Acércate al módulo de atención.</p>
        </div>
      </div>
    </div>

    <!-- Verification Screen -->
    <div v-else-if="showVerification && !showSuccess" class="flex-1 flex items-center justify-center p-8">
      <div class="max-w-3xl w-full animate-fade-in">
        <div class="bg-white rounded-3xl shadow-2xl p-8 border border-gray-100">
          <h2 class="text-3xl font-bold text-gray-900 mb-2">Verificar Datos del Paciente</h2>
          <p class="text-gray-600 mb-8">Revise la información extraída y confirme para continuar.</p>

          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Nombre Completo</label>
              <input type="text" v-model="extractedData.fullName" readonly class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-lg font-medium text-gray-900" />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Fecha de Nacimiento</label>
                <input type="text" v-model="extractedData.birthDate" readonly class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Edad</label>
                <input type="text" :value="calculatedAge" readonly class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Sexo</label>
                <input type="text" v-model="extractedData.sex" readonly class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Número de Documento</label>
                <input type="text" v-model="extractedData.documentId" readonly class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl font-mono" />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Dirección <span class="text-gray-400">(Opcional)</span>
              </label>
              <input 
                type="text" 
                v-model="extractedData.address" 
                :placeholder="extractedData.address ? '' : 'No detectada - Puedes escanear el reverso'"
                readonly 
                class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl" 
                :class="extractedData.address ? 'text-gray-900' : 'text-gray-400 italic'"
              />
            </div>

            <!-- Warning if address is missing -->
            <div v-if="!extractedData.address" class="bg-blue-50 border border-blue-200 rounded-xl p-4 flex items-start gap-3">
              <span class="text-2xl">ℹ️</span>
              <div class="flex-1">
                <p class="text-sm font-medium text-blue-900">Dirección no detectada</p>
                <p class="text-xs text-blue-700 mt-1">La dirección puede estar en el reverso del documento. Puedes escanear el reverso o continuar sin ella.</p>
              </div>
            </div>
          </div>

          <div class="flex gap-4 mt-8">
            <button 
              v-if="!extractedData.address"
              @click="smartScan(true)"  
              class="flex-1 bg-blue-500 text-white py-4 text-lg font-semibold rounded-2xl hover:bg-blue-600 transition-all shadow-lg"
            >
              📸 Escanear Reverso
            </button>
            <button 
              @click="confirmAndCheckin" 
              class="flex-1 bg-primary text-white py-4 text-lg font-semibold rounded-2xl hover:bg-opacity-90 transition-all shadow-lg"
            >
              ✓ Confirmar y Continuar
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Success Screen -->
    <div v-else class="flex-1 flex items-center justify-center p-8">
      <div class="max-w-2xl w-full text-center space-y-12 animate-fade-in">
        <!-- Success Icon -->
        <div class="flex justify-center">
          <div class="w-32 h-32 bg-green-100 rounded-full flex items-center justify-center">
            <svg class="w-16 h-16 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
            </svg>
          </div>
        </div>

        <!-- Success Message -->
        <div>
          <h1 class="text-5xl font-bold text-gray-900 mb-4">¡Check-in Exitoso!</h1>
          <p class="text-xl text-gray-600">Por favor, toma asiento y espera tu turno</p>
        </div>

        <!-- Ticket Number -->
        <div class="bg-gradient-to-br from-primary/10 to-primary/5 p-12 rounded-3xl border-2 border-dashed border-primary/30 inline-block mx-auto">
          <p class="text-sm text-gray-500 uppercase tracking-wider mb-3">Tu Turno</p>
          <p class="text-8xl font-black text-primary tracking-tighter">{{ ticket }}</p>
        </div>

        <!-- Auto-reset message -->
        <div class="text-sm text-gray-500">
          <p>Esta pantalla se reiniciará automáticamente en unos segundos...</p>
          <button @click="reset" class="mt-4 px-8 py-3 bg-primary text-white rounded-xl font-bold hover:bg-opacity-90 transition-all shadow-md">
            Finalizar y Volver a la Lista
          </button>
        </div>
      </div>
    </div>

    <!-- Camera Modal -->
    <div v-if="showCamera" class="fixed inset-0 bg-black z-50 flex flex-col">
      <!-- Camera Header -->
      <div class="p-6 bg-gray-900/90 backdrop-blur flex items-center justify-between">
        <h2 class="text-white text-xl font-semibold">Escanear DNI con IA</h2>
        <button @click="stopCamera" class="text-white hover:text-gray-300 text-3xl">×</button>
      </div>

      <!-- Camera View -->
      <div class="flex-1 relative flex items-center justify-center">
        <video 
          ref="videoRef" 
          autoplay 
          playsinline
          class="max-w-full max-h-full object-contain"
        ></video>

        <!-- Overlay guide -->
        <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
          <div class="border-4 border-primary border-dashed rounded-2xl w-96 h-60 opacity-70"></div>
        </div>

        <!-- Instructions -->
        <div class="absolute bottom-32 left-0 right-0 text-center text-white px-4">
          <p class="text-lg bg-black/50 backdrop-blur py-3 px-6 rounded-full inline-block">
            Coloca tu DNI dentro del recuadro
          </p>
        </div>
      </div>

      <!-- Camera Controls -->
      <div class="p-6 bg-gray-900/90 backdrop-blur">
        <button 
          @click="capturePhoto"
          :disabled="processingImage"
          class="w-full bg-primary text-white py-5 text-xl font-bold rounded-2xl hover:bg-opacity-90 transition-all disabled:opacity-50 flex items-center justify-center gap-3"
        >
          <span v-if="processingImage" class="flex items-center gap-2">
            <svg class="animate-spin h-6 w-6" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Analizando con IA...
          </span>
          <span v-else class="flex items-center gap-2">
            <span class="text-2xl">🤖</span>
            Capturar y Analizar
          </span>
        </button>

        <button 
          @click="openFileSelector"
          :disabled="processingImage"
          class="w-full mt-4 bg-gray-800 text-white py-4 text-lg font-semibold rounded-2xl hover:bg-gray-700 transition-all disabled:opacity-50 flex items-center justify-center gap-2 border border-gray-700"
        >
          <span>📂</span> Subir desde archivo
        </button>
      </div>

      <!-- Hidden canvas for image processing -->
      <canvas ref="canvasRef" class="hidden"></canvas>
    </div>

    <!-- Hidden file input (Always present) -->
    <input 
      ref="fileInputRef"
      type="file" 
      accept="image/*" 
      @change="handleFileSelect"
      class="hidden"
    />

    <!-- Upload Fallback Modal -->
    <div v-if="showUploadFallback" class="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4 backdrop-blur-sm animate-fade-in">
      <div class="bg-white rounded-3xl max-w-md w-full p-8 text-center shadow-2xl">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-6">
          <span class="text-4xl">📷</span>
        </div>
        
        <h3 class="text-2xl font-bold text-gray-900 mb-3">Cámara no detectada</h3>
        <p class="text-gray-600 mb-8">
          No pudimos acceder a la cámara. Por favor selecciona una foto de tu galería o archivos.
        </p>
        
        <div class="space-y-3">
          <button 
            @click="openFileSelector(); showUploadFallback = false"
            class="w-full bg-primary text-white py-4 text-lg font-semibold rounded-2xl hover:bg-opacity-90 transition-all shadow-lg flex items-center justify-center gap-2"
          >
            <span>📂</span> Seleccionar Foto
          </button>
          
          <button 
            @click="showUploadFallback = false"
            class="w-full bg-gray-100 text-gray-700 py-4 text-lg font-semibold rounded-2xl hover:bg-gray-200 transition-all"
          >
            Cancelar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.animate-fade-in {
  animation: fadeInUp 0.6s ease-out forwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.scan-line {
  animation: scan 2s ease-in-out infinite;
}

@keyframes scan {
  0%, 100% {
    transform: translateY(-40px);
    opacity: 0;
  }
  50% {
    opacity: 0.3;
  }
}
</style>
