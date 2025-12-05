<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import api from '../services/api';
import { useToast } from "vue-toastification";

const toast = useToast();
const showSuccess = ref(false);
const showVerification = ref(false);
const documentId = ref('');
const loading = ref(false);
const ticket = ref('');

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
      try {
        const img = new Image();
        img.src = e.target?.result as string;
        
        img.onload = async () => {
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
          } else {
            // New scan mode: Validate ID
            if (!newData.documentId) {
              throw new Error('No se pudo detectar el número de documento. Intente nuevamente con una imagen más clara.');
            }

            extractedData.value = {
              documentId: newData.documentId,
              fullName: newData.fullName,
              birthDate: newData.birthDate,
              sex: newData.sex,
              address: newData.address || ''
            };
          }
          
          showVerification.value = true;
          isScanningBack.value = false;
        };
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
      } else {
        // New scan mode: Validate ID
        if (!newData.documentId) {
          throw new Error('No se pudo detectar el número de documento. Intente nuevamente.');
        }

        extractedData.value = {
          documentId: newData.documentId,
          fullName: newData.fullName,
          birthDate: newData.birthDate,
          sex: newData.sex,
          address: newData.address || ''
        };
      }
      
      stopCamera();
      showVerification.value = true;
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
    // 1. Find Patient
    const resPatient = await api.get(`/patients?documentId=${documentId.value}`);
    
    if (resPatient.data.length === 0) {
      toast.error('Paciente no encontrado. Por favor verifique su documento.');
      loading.value = false;
      return;
    }

    const patient = resPatient.data[0];
    
    // 2. Find Today's Appointments
    const today = new Date().toISOString().split('T')[0];
    const resApps = await api.get(`/appointments?patientId=${patient.id}&date=${today}`);
    const scheduledAppointments = resApps.data.filter((a: any) => a.status === 'SCHEDULED');
    
    if (scheduledAppointments.length === 0) {
      toast.warning('No tiene citas programadas para hoy o ya realizó el check-in.');
      loading.value = false;
      return;
    }

    // 3. Auto-select first scheduled appointment
    const appointment = scheduledAppointments[0];
    
    // 4. Perform Check-in
    const resCheckin = await api.post(`/appointments/${appointment.id}/checkin`);
    ticket.value = resCheckin.data.ticketNumber;
    
    // Show success screen
    showSuccess.value = true;
    
    // Auto-reset after 10 seconds
    setTimeout(() => {
      reset();
    }, 10000);
    
  } catch (error: any) {
    console.error(error);
    toast.error('Error al realizar check-in. Intente nuevamente.');
  } finally {
    loading.value = false;
  }
};

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
    <!-- Header -->
    <header class="px-8 py-6 border-b border-gray-100">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 bg-primary rounded-lg flex items-center justify-center text-white font-bold text-xl">
          I
        </div>
        <span class="text-xl font-semibold text-gray-800">Instituto Oncológico</span>
      </div>
    </header>

    <!-- Main Content -->
    <div v-if="!showSuccess && !showVerification" class="flex-1 flex items-center justify-center p-8">
      <div class="max-w-2xl w-full text-center space-y-12 animate-fade-in">
        <!-- Title -->
        <div>
          <h1 class="text-5xl font-bold text-gray-900 mb-4">Bienvenido a Onkos</h1>
          <p class="text-xl text-gray-600">Haz clic en la credencial para escanear tu documento</p>
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
              <rect x="10" y="15" width="220" height="130" rx="12" fill="#F4F6F8" stroke="#2BB88A" stroke-width="3" class="group-hover:fill-green-50 transition-colors"/>
              
              <!-- Photo placeholder -->
              <rect x="25" y="30" width="60" height="75" rx="6" fill="#D1D5DB" class="group-hover:fill-gray-400 transition-colors"/>
              <circle cx="55" cy="55" r="15" fill="#9CA3AF"/>
              <path d="M55 70 Q40 90, 55 95 Q70 90, 55 70" fill="#9CA3AF"/>
              
              <!-- Text lines -->
              <rect x="100" y="35" width="110" height="8" rx="4" fill="#2BB88A" opacity="0.6"/>
              <rect x="100" y="50" width="90" height="6" rx="3" fill="#9CA3AF"/>
              <rect x="100" y="63" width="100" height="6" rx="3" fill="#9CA3AF"/>
              <rect x="100" y="76" width="70" height="6" rx="3" fill="#9CA3AF"/>
              
              <!-- Barcode -->
              <rect x="25" y="115" width="190" height="20" rx="4" fill="white" stroke="#2BB88A" stroke-width="2"/>
              <line x1="35" y1="120" x2="35" y2="130" stroke="#2BB88A" stroke-width="2"/>
              <line x1="45" y1="120" x2="45" y2="130" stroke="#2BB88A" stroke-width="3"/>
              <line x1="55" y1="120" x2="55" y2="130" stroke="#2BB88A" stroke-width="1"/>
              <line x1="65" y1="120" x2="65" y2="130" stroke="#2BB88A" stroke-width="2"/>
              <line x1="75" y1="120" x2="75" y2="130" stroke="#2BB88A" stroke-width="3"/>
              <line x1="85" y1="120" x2="85" y2="130" stroke="#2BB88A" stroke-width="2"/>
              <line x1="95" y1="120" x2="95" y2="130" stroke="#2BB88A" stroke-width="1"/>
              <line x1="105" y1="120" x2="105" y2="130" stroke="#2BB88A" stroke-width="3"/>
              
              <!-- Scan effect on hover -->
              <line x1="0" y1="75" x2="240" y2="75" stroke="#2BB88A" stroke-width="2" opacity="0" class="group-hover:opacity-40 transition-opacity scan-line"/>
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
          <button @click="reset" class="mt-4 text-primary hover:underline">
            Realizar otro check-in
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
