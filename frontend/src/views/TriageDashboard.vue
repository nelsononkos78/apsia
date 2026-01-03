<template>
    <div class="triage-dashboard">
        <GlobalHeader fullWidth>
            <template #center>
                <DigitalClock />
            </template>
            <template #actions>
                <div class="header-actions-wrapper">
                    <div v-if="currentResource" class="resource-badge">
                        <i class="fas fa-user-nurse"></i>
                        {{ currentResource.name }}
                    </div>
                </div>
            </template>
        </GlobalHeader>

        <header class="dashboard-header">
            <div class="header-content">
                <div class="brand">
                    <div class="logo-icon">
                        <i class="fas fa-notes-medical"></i>
                    </div>
                    <div class="staff-info">
                        <span class="staff-name">{{ staff?.name || 'Enfermera' }}</span>
                        <span class="role">Triaje y Signos Vitales</span>
                    </div>
                </div>
            </div>
            <button @click="logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i>
                Salir
            </button>
        </header>

        <main class="dashboard-main">
            <!-- Left Column: Triage Area -->
            <div class="triage-section">
                <div class="section-card main-card">
                    <div class="card-header-row">
                        <div class="header-title-group">
                            <h2>Triaje Activo</h2>
                        </div>
                        <div class="header-actions-group">
                            <button 
                                v-if="currentPatient"
                                @click="finishTriage" 
                                class="btn-success btn-header"
                                :disabled="loading"
                            >
                                <i class="fas fa-check"></i> Finalizar Triaje
                            </button>
                        </div>
                    </div>
                    
                    <div v-if="currentPatient" class="patient-triage-container">
                        <div class="patient-info-table">
                            <div class="info-cell patient">
                                <label>PACIENTE:</label>
                                <span>{{ currentPatient.name }}</span>
                            </div>
                            <div class="info-cell hc">
                                <label>HISTORIA CLÍNICA:</label>
                                <span>{{ currentPatient.medicalRecordNumber || '---' }}</span>
                            </div>
                            <div class="info-cell age">
                                <label>EDAD:</label>
                                <span>{{ calculateAge(currentPatient.birthDate) }} años</span>
                            </div>
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
                                <div v-if="activeTab === 'EXAMEN FISICO'" class="physical-exam-tab">
                                    <PhysicalExamForm 
                                        v-if="currentAppointment"
                                        ref="physicalExamRef"
                                        :patientId="currentPatient.id"
                                        :appointmentId="currentAppointment.id"
                                        :staffId="staff.id"
                                    />
                                    <div v-else class="loading-appointment">
                                        Cargando datos de la cita...
                                    </div>
                                </div>
                                <div v-else class="empty-tab-content">
                                    Sección {{ activeTab }} en desarrollo
                                </div>
                            </div>
                        </div>
                    </div>

                    <div v-else class="empty-state">
                        <i class="fas fa-user-clock"></i>
                        <p>No hay paciente en triaje</p>
                        <p class="sub-text">Llame al siguiente paciente de la lista para comenzar</p>
                    </div>
                </div>
            </div>

            <!-- Right Column: Waiting List -->
            <div class="waiting-list-section">
                <div class="section-card">
                    <div class="list-header">
                        <h2>Lista de Espera</h2>
                        <span class="badge badge-waiting">{{ waitingList.length }}</span>
                    </div>

                    <div class="waiting-list">
                        <div 
                            v-for="record in waitingList" 
                            :key="record.id" 
                            class="waiting-item"
                        >
                            <div class="waiting-info">
                                <span class="name">{{ record.patient.name }}</span>
                                <span class="time">
                                    <i class="far fa-clock"></i>
                                    {{ formatTime(record.checkInTime) }}
                                </span>
                            </div>
                            <button 
                                @click="callPatient(record)" 
                                class="btn-call"
                                :disabled="!!currentPatient || loading"
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
import { useToast } from 'vue-toastification';

const router = useRouter();
const toast = useToast();

const staff = ref<any>(null);
const currentResource = ref<any>(null);
const waitingList = ref<any[]>([]);
const currentPatient = ref<any>(null);
const currentAppointment = ref<any>(null);
const loading = ref(false);

const TABS = ['EXAMEN FISICO', 'NOTAS DE ENFERMERIA'];
const activeTab = ref(TABS[0]);

async function loadDashboard() {
    try {
        const userStr = localStorage.getItem('user');
        
        if (!userStr) {
            console.warn('⚠️ No user found in localStorage, redirecting to login');
            router.push('/staff/login');
            return;
        }

        const user = JSON.parse(userStr);
        
        if (!user || !user.id) {
            console.warn('⚠️ Invalid user data, redirecting to login');
            router.push('/staff/login');
            return;
        }

        staff.value = user;

        // Fetch triage resources assigned to this staff
        const res = await api.get('/resources/type/TRIAJE');
        const triageResources = res.data;
        
        // Find resource assigned to this staff or just pick the first one for now
        // In a real scenario, we'd have a specific assignment
        currentResource.value = triageResources.find((r: any) => r.staffId === staff.value.id) || triageResources[0];

        if (currentResource.value) {
            if (currentResource.value.currentPatient) {
                currentPatient.value = currentResource.value.currentPatient;
                currentAppointment.value = currentResource.value.currentAppointment;
            } else {
                currentPatient.value = null;
                currentAppointment.value = null;
            }
        }

        // Fetch waiting list for triage
        const waitingRes = await api.get('/waiting-room');
        waitingList.value = waitingRes.data.filter((r: any) => 
            r.status === 'ESPERANDO' && (!r.appointment || !r.appointment.triajeCompleted)
        );

    } catch (error) {
        console.error('Error loading triage dashboard:', error);
    }
}

async function callPatient(record: any) {
    if (!currentResource.value) return;
    loading.value = true;
    try {
        await api.post(`/resources/${currentResource.value.id}/call-next`);
        toast.success('Paciente llamado');
        await loadDashboard();
    } catch (error: any) {
        toast.warning(error.response?.data?.message || 'Error al llamar paciente');
    } finally {
        loading.value = false;
    }
}

const physicalExamRef = ref<any>(null);

async function finishTriage() {
    if (!currentResource.value) return;
    loading.value = true;
    try {
        // Auto-save physical exam if the ref exists
        if (physicalExamRef.value && typeof physicalExamRef.value.saveExam === 'function') {
            await physicalExamRef.value.saveExam();
        }

        await api.post(`/resources/${currentResource.value.id}/release`);
        toast.success('Triaje finalizado y datos guardados');
        currentPatient.value = null;
        currentAppointment.value = null;
        await loadDashboard();
    } catch (error) {
        console.error('Error finishing triage:', error);
        toast.error('Error al finalizar triaje');
    } finally {
        loading.value = false;
    }
}

function calculateAge(birthDate: string) {
    if (!birthDate) return '';
    const today = new Date();
    const birth = new Date(birthDate);
    let age = today.getFullYear() - birth.getFullYear();
    const m = today.getMonth() - birth.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
        age--;
    }
    return age;
}

function formatTime(dateStr: string) {
    if (!dateStr) return '';
    return new Date(dateStr).toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
}

function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    router.push('/staff/login');
}

onMounted(() => {
    loadDashboard();
    websocketService.joinMonitoring();
    websocketService.on('resource:updated', loadDashboard);
    websocketService.on('waitingRoom:updated', loadDashboard);
});

onUnmounted(() => {
    websocketService.off('resource:updated', loadDashboard);
    websocketService.off('waitingRoom:updated', loadDashboard);
});
</script>

<style scoped>
.triage-dashboard {
    min-height: 100vh;
    background: #FCFCFC;
    display: flex;
    flex-direction: column;
    font-family: 'Inter', sans-serif;
}

.dashboard-header {
    background: #FCFCFC;
    padding: 0.75rem 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(34, 54, 117, 0.08);
}

.brand {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.logo-icon {
    width: 32px;
    height: 32px;
    background: #008f72;
    color: white;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
}

.staff-info {
    display: flex;
    flex-direction: column;
    line-height: 1.2;
}

.staff-name {
    font-weight: 700;
    color: #223675;
    font-size: 0.95rem;
}

.role {
    font-size: 0.8rem;
    color: #008f72;
    font-weight: 500;
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

.card-header-row h2 {
    margin: 0;
    font-size: 1.4rem;
    color: #223675;
    font-weight: 800;
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
}

.btn-success {
    background: #5371C4;
    color: white;
}

.patient-triage-container {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.patient-info-table {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr;
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
}

.info-cell span {
    font-weight: 700;
    color: #223675;
    font-size: 1.1rem;
}

.clinical-tabs-container {
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    overflow: hidden;
    margin-top: 1rem;
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
}

.tab-btn.active {
    color: #223675;
    border-bottom-color: #223675;
    background: white;
}

.tab-content {
    padding: 1.5rem;
    background: white;
}

.empty-tab-content {
    text-align: center;
    padding: 3rem;
    color: #94a3b8;
    font-style: italic;
}

.loading-appointment {
    text-align: center;
    padding: 2rem;
    color: #5371C4;
    font-weight: 600;
}

.empty-state {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #94a3b8;
    gap: 1rem;
}

.empty-state i {
    font-size: 4rem;
    opacity: 0.3;
}

.waiting-list-section .list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
}

.badge-waiting {
    background: #5371C4;
    color: white;
    padding: 0.25rem 0.75rem;
    border-radius: 999px;
    font-weight: 700;
}

.waiting-list {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.waiting-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    background: #f8fafc;
    border-radius: 12px;
    border: 1px solid #edf2f7;
}

.waiting-info {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
}

.waiting-info .name {
    font-weight: 700;
    color: #223675;
}

.waiting-info .time {
    font-size: 0.8rem;
    color: #64748b;
}

.btn-call {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    border: none;
    background: #CEEAC7;
    color: #223675;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}

.btn-call:hover:not(:disabled) {
    background: #A5D8A9;
    transform: scale(1.1);
}

.btn-call:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.empty-list {
    text-align: center;
    padding: 2rem;
    color: #94a3b8;
    font-style: italic;
}
</style>
