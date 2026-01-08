<template>
    <div class="doctor-dashboard">
        <GlobalHeader fullWidth>
            <template #center>
                <DigitalClock />
            </template>
            <template #actions>
                <div class="header-actions-wrapper">
                    <div v-if="resource" class="resource-badge">
                        <i class="fas fa-door-open"></i>
                        {{ resource.name }}
                    </div>
                </div>
            </template>
        </GlobalHeader>

        <header class="dashboard-header">
            <div class="header-content">
                <div class="brand">
                    <div class="logo-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="doctor-info">
                        <span class="doctor-name">{{ doctor?.name }}</span>
                        <span class="specialty">{{ doctor?.specialty?.name }}</span>
                    </div>
                </div>
            </div>
            <button @click="logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i>
                Salir
            </button>
        </header>

        <main class="dashboard-main">
            <!-- Left Column: Consultation Area -->
            <div class="consultation-section">
                <div class="section-card main-card">
                    <div class="card-header-row">
                        <div class="header-title-group">
                            <h2>Consulta Activa</h2>
                            <div v-if="currentAppointment?.status === 'IN_PROGRESS'" 
                                :class="['timer-badge', { 'over-timing': isOverTiming }]"
                            >
                                <i class="fas fa-stopwatch"></i>
                                {{ formattedConsultationTime }}
                            </div>
                        </div>
                        <div class="header-actions-group">
                            <button 
                                v-if="currentAppointment?.status === 'SCHEDULED' || currentAppointment?.status === 'CHECKED_IN'"
                                @click="startConsultation" 
                                class="btn-primary btn-header"
                            >
                                <i class="fas fa-play"></i> Iniciar Consulta
                            </button>
                            <button 
                                v-if="currentAppointment?.status === 'IN_PROGRESS'"
                                @click="finishConsultation" 
                                class="btn-success btn-header"
                            >
                                <i class="fas fa-check"></i> Finalizar Consulta
                            </button>
                        </div>
                    </div>
                    
                    <div v-if="currentPatient" class="patient-consultation-container">
                        <!-- Simplified Patient Header (Table-like) -->
                        <div class="patient-info-table">
                            <div class="info-cell service">
                                <label>SERVICIO:</label>
                                <span>{{ currentAppointment?.serviceType?.name || 'N/A' }}</span>
                            </div>
                            <div class="info-cell patient">
                                <label>PACIENTE:</label>
                                <span>{{ currentPatient.name }}</span>
                            </div>
                            <div class="info-cell hc">
                                <label>HISTORIA CLÍNICA:</label>
                                <span>{{ currentPatient.medicalRecordNumber || 'Sin asignar' }}</span>
                            </div>
                        </div>

                        <!-- Patient Request Description -->
                        <div class="description-box" v-if="currentAppointment?.notes">
                            <label>Motivo de Consulta / Descripción:</label>
                            <p>{{ currentAppointment.notes }}</p>
                        </div>

                        <!-- Clinical Tabs Section -->
                        <div class="clinical-tabs-container">
                            <div class="tabs-header">
                                <button 
                                    v-for="tab in TABS" 
                                    :key="tab"
                                    @click="activeTab = tab"
                                    :class="['tab-btn', { active: activeTab === tab }]"
                                >
                                    {{ tab }}
                                </button>
                            </div>
                            <div class="tab-content">
                                <div v-if="activeTab === 'EXAMEN FISICO' && currentPatient" class="physical-exam-tab">
                                    <PhysicalExamForm 
                                        :patientId="currentPatient.id"
                                        :appointmentId="currentAppointment.id"
                                        :staffId="user.id"
                                    />
                                </div>
                                <div v-else-if="activeTab === 'DIAGNOSTICO'" class="diagnosis-tab">
                                    <div class="diagnosis-inputs">
                                        <div class="input-field">
                                            <label>Código CIE10</label>
                                            <input v-model="diagnosisCode" placeholder="Ej: C50.9" class="cie-input" />
                                        </div>
                                        <div class="input-field">
                                            <label>Descripción del Diagnóstico</label>
                                            <textarea v-model="diagnosisDescription" placeholder="Describa el diagnóstico..." class="diag-textarea"></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div v-else class="textarea-wrapper">
                                    <textarea 
                                        v-model="clinicalNotes[activeTab]" 
                                        :placeholder="'Escribir ' + activeTab.toLowerCase() + '...'"
                                    ></textarea>
                                    <button @click="improveTextWithAI" class="btn-ai" title="Mejorar con IA">
                                        <i class="fas fa-magic"></i>
                                        Mejorar redacción con IA
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div v-else class="empty-state">
                        <i class="fas fa-user-clock"></i>
                        <p>No hay paciente en consulta</p>
                        <p class="sub-text">Llame al siguiente paciente de la lista para comenzar</p>
                    </div>
                </div>
            </div>

            <!-- Right Column: Waiting List -->
            <div class="waiting-list-section">
                <div class="section-card">
                    <div class="list-header">
                        <h2>Sala de Espera</h2>
                        <div class="list-badges">
                            <span class="badge badge-attended" title="Atendidos hoy">
                                <i class="fas fa-check-double"></i> {{ attendedCount }}
                            </span>
                            <span class="badge badge-waiting" title="En espera">
                                <i class="fas fa-clock"></i> {{ waitingList.length }}
                            </span>
                            <span v-if="pendingTriajeCount > 0" class="badge badge-triaje" title="En triaje">
                                <i class="fas fa-user-nurse"></i> {{ pendingTriajeCount }}
                            </span>
                        </div>
                    </div>

                    <div class="waiting-list">
                        <div 
                            v-for="record in sortedWaitingList" 
                            :key="record.id" 
                            class="waiting-item"
                        >
                            <div class="waiting-info">
                                <span class="ticket">T-{{ record.id }}</span>
                                <span class="name">{{ record.patient.name }}</span>
                                <span class="time">
                                    <i class="far fa-clock"></i>
                                    {{ formatTime(record.checkInTime) }}
                                </span>
                            </div>
                            <button 
                                @click="callPatient(record)" 
                                class="btn-call"
                                :disabled="!!currentPatient"
                                title="Llamar paciente"
                            >
                                <i class="fas fa-bullhorn"></i>
                            </button>
                        </div>

                        <div v-if="waitingList.length === 0" class="empty-list">
                            No hay pacientes en espera
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import api from '../services/api';
import { websocketService } from '../services/websocket.service';
import DigitalClock from '../components/monitoring/DigitalClock.vue';
import GlobalHeader from '../components/common/GlobalHeader.vue';
import PhysicalExamForm from '../components/clinical/PhysicalExamForm.vue';

const router = useRouter();

const doctor = ref<any>(null);
const user = ref<any>(null);
const resource = ref<any>(null);
const waitingList = ref<any[]>([]);
const currentPatient = ref<any>(null);
const currentAppointment = ref<any>(null);
const attendedCount = ref(0);
const pendingTriajeCount = ref(0);

// Clock and Timer
const currentTime = ref('');
const currentDate = ref('');
const consultationSeconds = ref(0);
const consultationTimer = ref<number | null>(null);

const TABS = ['ANAMNESIS', 'EXAMEN FISICO', 'EVOLUCION', 'INTERCONSULTA', 'Nº EMERGENCIA', 'DIAGNOSTICO'];
const activeTab = ref(TABS[0]);
const clinicalNotes = ref<Record<string, string>>(
    TABS.reduce((acc, tab) => ({ ...acc, [tab]: '' }), {})
);

const diagnosisCode = ref('');
const diagnosisDescription = ref('');

const sortedWaitingList = computed(() => {
    return [...waitingList.value].sort((a, b) => {
        // Priority: URGENTE (1) > NORMAL (0)
        const priorityOrder: Record<string, number> = { 'URGENTE': 1, 'NORMAL': 0 };
        const aPrio = priorityOrder[a.priority] || 0;
        const bPrio = priorityOrder[b.priority] || 0;
        
        if (aPrio !== bPrio) return bPrio - aPrio;
        
        // Time: Oldest first
        return new Date(a.checkInTime).getTime() - new Date(b.checkInTime).getTime();
    });
});

const formattedConsultationTime = computed(() => {
    const mins = Math.floor(consultationSeconds.value / 60);
    const secs = consultationSeconds.value % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
});

const isOverTiming = computed(() => {
    if (!resource.value?.timing) return false;
    const timingInSeconds = resource.value.timing * 60;
    return consultationSeconds.value >= timingInSeconds;
});



function startTimer() {
    if (consultationTimer.value) return;
    
    const updateTimer = () => {
        if (currentAppointment.value?.startTime) {
            const start = new Date(currentAppointment.value.startTime).getTime();
            const now = new Date().getTime();
            consultationSeconds.value = Math.max(0, Math.floor((now - start) / 1000));
        } else {
            consultationSeconds.value++;
        }
    };

    updateTimer(); // Initial calculation
    consultationTimer.value = window.setInterval(updateTimer, 1000);
}

function stopTimer() {
    if (consultationTimer.value) {
        clearInterval(consultationTimer.value);
        consultationTimer.value = null;
    }
}

async function improveTextWithAI() {
    const currentText = clinicalNotes.value[activeTab.value];
    if (!currentText.trim()) return;

    try {
        // Mocking AI improvement for now
        // In a real scenario, this would call a backend endpoint that uses LLM
        const res = await api.post('/vision/analyze-text', { 
            text: currentText,
            context: `Mejorar la redacción médica para la sección de ${activeTab.value}`
        });
        
        if (res.data && res.data.analysis) {
            clinicalNotes.value[activeTab.value] = res.data.analysis;
        } else {
            // Fallback mock if API doesn't return expected format
            clinicalNotes.value[activeTab.value] = `[Mejorado por IA]: ${currentText}`;
        }
    } catch (error) {
        console.error('Error improving text with AI:', error);
    }
}

async function loadDashboard() {
    try {
        const userLocal = JSON.parse(localStorage.getItem('user') || '{}');
        user.value = userLocal;
        const email = userLocal.email || 'antonio.camargo@onkos.pe'; 

        const res = await api.get(`/doctors/dashboard?email=${email}`);
        const data = res.data;

        doctor.value = data.doctor;
        resource.value = data.resource;
        waitingList.value = data.waitingList;
        attendedCount.value = data.attendedCount || 0;
        pendingTriajeCount.value = data.pendingTriajeCount || 0;

        if (resource.value?.currentPatient) {
            currentPatient.value = resource.value.currentPatient;
            // If there's a current patient, we should also try to find the active appointment
            // For now, let's assume the dashboard returns it or we fetch it
            // Assuming the backend was updated to return currentAppointment
            currentAppointment.value = data.currentAppointment || null;
            
            if (currentAppointment.value?.status === 'IN_PROGRESS') {
                startTimer();
            }
        }
    } catch (error) {
        console.error('Error loading dashboard:', error);
    }
}

async function callPatient(record: any) {
    if (currentPatient.value) return;
    try {
        await api.post('/doctors/call', {
            doctorId: doctor.value.id,
            waitingRoomId: record.id
        });
        
        // Reload everything to ensure consistent state
        await loadDashboard();
        
        consultationSeconds.value = 0;
    } catch (error: any) {
        if (error.response && error.response.status === 404) {
            alert(error.response.data.message);
        } else {
            console.error('Error calling patient:', error);
        }
    }
}

async function startConsultation() {
    if (!currentAppointment.value) return;
    try {
        const res = await api.post('/doctors/start', {
            doctorId: doctor.value.id,
            appointmentId: currentAppointment.value.id
        });
        currentAppointment.value = res.data;
        startTimer();
    } catch (error) {
        console.error('Error starting consultation:', error);
    }
}

async function finishConsultation() {
    if (!currentAppointment.value) return;
    try {
        const medicalRecord = {
            anamnesis: clinicalNotes.value['ANAMNESIS'],
            physicalExam: clinicalNotes.value['EXAMEN FISICO'],
            evolution: clinicalNotes.value['EVOLUCION'],
            interconsultation: clinicalNotes.value['INTERCONSULTA'],
            emergencyNumber: clinicalNotes.value['Nº EMERGENCIA'],
            diagnosisCode: diagnosisCode.value,
            diagnosisDescription: diagnosisDescription.value
        };

        await api.post('/doctors/finish', {
            doctorId: doctor.value.id,
            appointmentId: currentAppointment.value.id,
            medicalRecord
        });
        currentPatient.value = null;
        currentAppointment.value = null;
        diagnosisCode.value = '';
        diagnosisDescription.value = '';
        // Reset clinical notes
        TABS.forEach(tab => clinicalNotes.value[tab] = '');
        
        stopTimer();
        consultationSeconds.value = 0;
        loadDashboard();
    } catch (error) {
        console.error('Error finishing consultation:', error);
    }
}

function logout() {
    router.push('/staff/login');
}

function formatTime(dateStr: string) {
    if (!dateStr) return '';
    return new Date(dateStr).toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
}

function handleWaitingRoomUpdate() {
    console.log('🔄 Waiting room updated via WebSocket, reloading dashboard...');
    loadDashboard();
}

onMounted(() => {
    loadDashboard();
    
    // Ensure we are in the monitoring room for real-time updates
    websocketService.joinMonitoring();

    // Listen for WebSocket updates
    websocketService.on('waitingRoom:added', handleWaitingRoomUpdate);
    websocketService.on('waitingRoom:updated', handleWaitingRoomUpdate);
    websocketService.on('waitingRoom:removed', handleWaitingRoomUpdate);
});

onUnmounted(() => {
    stopTimer();

    // Remove WebSocket listeners
    websocketService.off('waitingRoom:added', handleWaitingRoomUpdate);
    websocketService.off('waitingRoom:updated', handleWaitingRoomUpdate);
    websocketService.off('waitingRoom:removed', handleWaitingRoomUpdate);
});
</script>

<style scoped>
.doctor-dashboard {
    min-height: 100vh;
    background: #FCFCFC;
    display: flex;
    flex-direction: column;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
}

.dashboard-header {
    background: #FCFCFC;
    padding: 0.75rem 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(34, 54, 117, 0.08);
    z-index: 100;
}

.brand {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    margin-bottom: 0.25rem;
}

.logo-icon {
    width: 32px;
    height: 32px;
    background: #5371C4;
    color: white;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 900;
    font-size: 1.2rem;
}

.header-content h1 {
    margin: 0;
    font-size: 1.25rem;
    color: #223675;
    font-weight: 800;
    letter-spacing: -0.5px;
}

.doctor-info {
    display: flex;
    flex-direction: column;
    line-height: 1.2;
}

.doctor-name {
    font-weight: 700;
    color: #223675;
    font-size: 0.95rem;
}

.specialty {
    font-size: 0.8rem;
    color: #5371C4;
    font-weight: 500;
}

.header-center {
    flex: 1;
    display: flex;
    justify-content: center;
}

.clock-container {
    display: flex;
    align-items: center;
    gap: 1.5rem;
    background: #223675;
    padding: 0.5rem 1rem;
    border-radius: 16px;
    border: 1px solid #5371C4;
    box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
}

.date-box {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    color: #C3E1ED;
    font-size: 1.1rem;
    font-weight: 500;
}

.date-box i {
    font-size: 1.2rem;
    opacity: 0.8;
}

.date-box span {
    text-transform: lowercase;
}

.date-box span::first-letter {
    text-transform: none; /* Keep weekday lowercase as in image */
}

.time-box {
    background: #5371C4;
    color: white;
    padding: 0.4rem 1.2rem;
    border-radius: 12px;
    font-size: 1.8rem;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    border: 1px solid #C3E1ED;
}

.header-actions {
    display: flex;
    align-items: center;
    gap: 1.5rem;
}

.resource-badge {
    background: #CEEAC7;
    color: #223675;
    padding: 6px 16px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 13px;
    display: flex;
    align-items: center;
    gap: 8px;
    border: 1px solid #A5D8A9;
}

.btn-logout {
    border: none;
    background: none;
    color: #e74c3c;
    cursor: pointer;
    font-weight: 700;
    font-size: 0.9rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem;
    border-radius: 8px;
    transition: background 0.2s;
}

.btn-logout:hover {
    background: #fee2e2;
}

.dashboard-main {
    flex: 1;
    padding: 1.5rem;
    display: grid;
    grid-template-columns: 1fr 350px;
    gap: 1.5rem;
    max-width: 1600px;
    margin: 0 auto;
    width: 100%;
}

.section-card {
    background: white;
    border-radius: 16px;
    padding: 1.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.03);
    border: 1px solid #edf2f7;
    display: flex;
    flex-direction: column;
}

.main-card {
    min-height: 600px;
}

.card-header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid #f1f5f9;
}

.header-title-group {
    display: flex;
    align-items: center;
    gap: 1.5rem;
}

.card-header-row h2 {
    margin: 0;
    font-size: 1.4rem;
    color: #223675;
    font-weight: 800;
}

.timer-badge {
    background: #CEEAC7;
    color: #223675;
    padding: 0.4rem 1rem;
    border-radius: 30px;
    font-weight: 800;
    font-size: 1rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    border: 2px solid #A5D8A9;
    transition: all 0.3s ease;
}

.timer-badge.over-timing {
    background: #fee2e2;
    color: #e74c3c;
    border-color: #fecaca;
    animation: pulse 2s infinite;
}

.header-actions-group {
    display: flex;
    gap: 1rem;
}

.btn-header {
    padding: 0.6rem 1.2rem;
    font-size: 0.95rem;
    border-radius: 10px;
    font-weight: 700;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.2s;
}

.btn-primary {
    background: #CEEAC7;
    color: #223675;
}

.btn-success {
    background: #5371C4;
    color: white;
}

.btn-header:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

.patient-consultation-container {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.patient-info-table {
    display: grid;
    grid-template-columns: 1fr 2fr 1fr;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    overflow: hidden;
}

.info-cell {
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    border-right: 1px solid #e2e8f0;
}

.info-cell:last-child {
    border-right: none;
}

.info-cell label {
    font-size: 0.7rem;
    font-weight: 800;
    color: #5371C4;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.info-cell span {
    font-weight: 700;
    color: #223675;
    font-size: 1.1rem;
}

.hc-input {
    border: 1px solid #cbd5e0;
    border-radius: 4px;
    padding: 0.4rem 0.6rem;
    font-weight: 600;
    font-size: 1rem;
    color: #2d3748;
    width: 100%;
}

.description-box {
    background: #FCFCFC;
    padding: 1rem;
    border-radius: 8px;
    border-left: 4px solid #5371C4;
    border: 1px solid rgba(34, 54, 117, 0.08);
}

.description-box label {
    display: block;
    font-size: 0.8rem;
    font-weight: 700;
    color: #5371C4;
    margin-bottom: 0.5rem;
}

.description-box p {
    margin: 0;
    color: #223675;
    line-height: 1.5;
}

.clinical-tabs-container {
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    overflow: hidden;
    flex: 1;
}

.tabs-header {
    display: flex;
    background: #f8fafc;
    border-bottom: 1px solid #e2e8f0;
}

.tab-btn {
    flex: 1;
    padding: 1rem;
    border: none;
    background: none;
    font-weight: 700;
    font-size: 0.85rem;
    color: #5371C4;
    cursor: pointer;
    transition: all 0.2s;
    border-bottom: 3px solid transparent;
}

.tab-btn:hover {
    background: #edf2f7;
    color: #4a5568;
}

.tab-btn.active {
    color: #223675;
    border-bottom-color: #223675;
    background: white;
}

.tab-content {
    padding: 1.5rem;
    flex: 1;
    display: flex;
}

.textarea-wrapper {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.textarea-wrapper textarea {
    width: 100%;
    min-height: 250px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 1rem;
    font-size: 1rem;
    line-height: 1.6;
    color: #2d3748;
    resize: vertical;
    font-family: inherit;
}

.btn-ai {
    align-self: flex-end;
    background: #C3E1ED;
    color: #223675;
    border: 1px solid #5371C4;
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 700;
    font-size: 0.9rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.2s;
}

.btn-ai:hover {
    background: #5371C4;
    color: white;
    transform: translateY(-1px);
}

.consultation-actions {
    display: flex;
    justify-content: center;
    padding-top: 1rem;
}

.btn-lg {
    padding: 1rem 3rem;
    font-size: 1.2rem;
    border-radius: 12px;
}

.waiting-list-section .section-card {
    height: calc(100vh - 120px);
}

.list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
}

.list-header h2 {
    margin: 0;
    font-size: 1.2rem;
    color: #223675;
    font-weight: 800;
}

.list-badges {
    display: flex;
    gap: 0.5rem;
}

.badge {
    padding: 0.25rem 0.75rem;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 800;
    display: flex;
    align-items: center;
    gap: 0.4rem;
}

.badge-waiting {
    background: #5371C4;
    color: white;
}

.badge-triaje {
    background: #FDE68A;
    color: #92400E;
    border: 1px solid #F59E0B;
}

.badge-attended {
    background: #CEEAC7;
    color: #223675;
}

.waiting-list {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    overflow-y: auto;
    padding-right: 0.5rem;
}

.waiting-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    background: #FCFCFC;
    border-radius: 12px;
    border: 1px solid rgba(34, 54, 117, 0.08);
    transition: all 0.2s;
}

.waiting-item:hover {
    border-color: #5371C4;
    background: #C3E1ED;
    transform: translateX(4px);
}

.waiting-info {
    display: flex;
    flex-direction: column;
    gap: 0.2rem;
}

.ticket {
    font-weight: 800;
    color: #5371C4;
    font-size: 0.85rem;
}

.name {
    font-weight: 700;
    color: #223675;
    font-size: 1rem;
}

.time {
    font-size: 0.75rem;
    color: #5371C4;
    display: flex;
    align-items: center;
    gap: 0.3rem;
    font-weight: 600;
}

.btn-call {
    width: 44px;
    height: 44px;
    border: none;
    border-radius: 12px;
    background: white;
    color: #5371C4;
    box-shadow: 0 2px 8px rgba(34, 54, 117, 0.08);
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
}

.btn-call:hover:not(:disabled) {
    background: #5371C4;
    color: white;
    transform: scale(1.05);
}

.btn-call:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

.empty-state {
    text-align: center;
    color: #a0aec0;
    padding: 6rem 0;
}

.empty-state i {
    font-size: 4rem;
    margin-bottom: 1.5rem;
    opacity: 0.3;
}

.empty-state p {
    font-size: 1.2rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
}

.sub-text {
    font-size: 0.95rem;
    font-weight: 500;
}

/* Custom Scrollbar */
.waiting-list::-webkit-scrollbar {
    width: 6px;
}
.waiting-list::-webkit-scrollbar-track {
    background: #f1f5f9;
}
.waiting-list::-webkit-scrollbar-thumb {
    background: #cbd5e0;
    border-radius: 10px;
}

.physical-exam-tab {
    width: 100%;
}
</style>
