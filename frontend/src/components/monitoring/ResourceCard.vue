<template>
    <div :class="['resource-card-minimal', displayStatusClass, { 'inactive-doctor': isCardDisabled }]">
        <div class="card-content">
            <div class="icon-container">
                <div class="resource-number">{{ resourceNumber }}</div>
            </div>
            <div class="details-container">
                <div class="detail-text">
                    <div class="primary-text">{{ primaryText }}</div>
                    <div class="secondary-text" v-if="secondaryText">{{ secondaryText }}</div>
                </div>
            </div>
            <div class="action-buttons" v-if="isDoctorActiveToday">
                <button 
                    v-if="resource.status === 'DISPONIBLE'" 
                    @click="markAsOccupied"
                    class="action-icon-btn"
                    title="Ocupar"
                >
                    <i class="fas fa-user"></i>
                </button>
                <button 
                    v-if="resource.status === 'OCUPADO'" 
                    @click="markAsAvailable"
                    class="action-icon-btn"
                    title="Liberar"
                >
                    <i class="fas fa-check-circle"></i>
                </button>
                <button 
                    @click="toggleDisable"
                    class="action-icon-btn"
                    :title="resource.status === 'INHABILITADO' ? 'Habilitar' : 'Inhabilitar'"
                >
                    <i :class="resource.status === 'INHABILITADO' ? 'fas fa-unlock' : 'fas fa-lock'"></i>
                </button>
            </div>
        </div>
        <span v-if="resource.statusReason" class="reason-badge">{{ reasonText }}</span>
    </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { Resource } from '../../services/resource.service';
import { resourceService } from '../../services/resource.service';
import { useMonitoringStore } from '../../stores/monitoring.store';

const props = defineProps<{
    resource: Resource;
    doctorName?: string;
    patientName?: string;
    treatmentInfo?: string;
    waitingCount?: number;
}>();

const monitoringStore = useMonitoringStore();

const resourceIconClass = computed(() => {
    switch (props.resource.type) {
        case 'CONSULTORIO': return 'fas fa-stethoscope';
        case 'TRATAMIENTO': return 'fas fa-syringe';
        case 'ESTANCIA': return 'fas fa-bed';
        default: return '';
    }
});

const resourceNumber = computed(() => {
    // Extraer número del nombre (ej: "Consultorio 1" -> "1")
    const match = props.resource.name.match(/\d+/);
    return match ? match[0] : '?';
});

const reasonText = computed(() => {
    switch (props.resource.statusReason) {
        case 'MANTENIMIENTO': return 'Mantenimiento';
        case 'LIMPIEZA': return 'Limpieza';
        case 'FALLA': return 'Falla';
        default: return '';
    }
});

async function markAsOccupied() {
    try {
        const updated = await resourceService.callNextPatient(props.resource.id);
        monitoringStore.updateResource(updated);
    } catch (error: any) {
        if (error.response && error.response.status === 404) {
            alert(error.response.data.message); // Or use a toast notification
        } else {
            console.error('Error calling next patient:', error);
        }
    }
}

async function markAsAvailable() {
    try {
        const updated = await resourceService.releaseResource(props.resource.id);
        monitoringStore.updateResource(updated);
    } catch (error) {
        console.error('Error releasing resource:', error);
    }
}



const isDoctorActiveToday = computed(() => {
    if (props.resource.type !== 'CONSULTORIO') return true; // Only applies to Consultorios
    if (!props.resource.doctor) return true; // If no doctor, assume active (or handle as 'Sin asignar')

    if (props.resource.doctor.status !== 'activo') return false;

    const today = new Date().getDay(); // 0 = Sunday, ...
    // Check if doctor has schedule for today
    const schedule = props.resource.doctor.schedules?.find(s => s.dayOfWeek === today);
    return !!schedule && schedule.isActive;
});

const displayStatus = computed(() => {
    if (!isDoctorActiveToday.value) return 'INHABILITADO';
    return props.resource.status;
});

const isCardDisabled = computed(() => {
    if (!isDoctorActiveToday.value) return true;
    
    // If it's a consulting room and it's occupied, we disable it for monitoring
    // so the doctor is the one who releases it.
    if (props.resource.type === 'CONSULTORIO' && props.resource.status === 'OCUPADO') {
        return true;
    }
    
    return false;
});

const displayStatusClass = computed(() => {
    return `status-${displayStatus.value.toLowerCase()}`;
});

const primaryText = computed(() => {
    if (props.resource.type === 'CONSULTORIO') {
        return props.doctorName || props.resource.doctor?.name || 'Sin asignar';
    }
    return props.patientName || 'Paciente';
});

const secondaryText = computed(() => {
    if (props.resource.type === 'CONSULTORIO') {
        if (props.resource.status === 'OCUPADO') {
            return props.patientName || (props.resource.currentPatient ? `${props.resource.currentPatient.firstName} ${props.resource.currentPatient.lastName}` : '');
        }
        // When DISPONIBLE or others
        if (props.waitingCount !== undefined && props.waitingCount > 0) {
            return `En espera: ${props.waitingCount}`;
        }
        return 'Sin pacientes';
    }
    return props.treatmentInfo || 'Tratamiento';
});

</script>

<style scoped>
.resource-card-minimal {
    width: 220px;
    height: 80px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(0, 0, 0, 0.06);
    position: relative;
}

.resource-card-minimal::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    transition: all 0.3s ease;
}

/* Colores homologados: Verde = Disponible, Rojo = Ocupado */
.resource-card-minimal.status-disponible::before {
    background: linear-gradient(90deg, #4caf50, #66bb6a);
}

.resource-card-minimal.status-ocupado::before {
    background: linear-gradient(90deg, #f44336, #ef5350);
}

.resource-card-minimal.status-inhabilitado::before {
    background: linear-gradient(90deg, #9e9e9e, #bdbdbd);
}

.resource-card-minimal:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.card-content {
    padding: 8px;
    display: flex;
    align-items: center;
    gap: 0;
    height: 100%;
    position: relative; /* For absolute positioning of actions */
}

.icon-container {
    width: 50px;
    height: 50px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    position: relative;
    transition: all 0.3s ease;
}

/* Colores de fondo del icono homologados */
.status-disponible .icon-container {
    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.status-ocupado .icon-container {
    background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

.status-inhabilitado .icon-container {
    background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
}

.resource-number {
    font-size: 36px;
    font-weight: 900;
    line-height: 1;
}

/* Colores del número según estado */
.status-disponible .resource-number {
    color: #a5d8a9;
}

.status-ocupado .resource-number {
    color: #ffaaaa;
}

.status-inhabilitado .resource-number {
    color: #757575;
}

.details-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 0 8px;
    overflow: hidden;
}

.detail-text {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.primary-text {
    font-size: 13px;
    font-weight: 700;
    color: #37474f;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.secondary-text {
    font-size: 12px;
    color: #78909c;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.action-buttons {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.98); /* Overlay background */
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    opacity: 0;
    transition: opacity 0.2s ease;
    z-index: 10;
}

.resource-card-minimal:hover .action-buttons {
    opacity: 1;
}

.inactive-doctor {
    opacity: 0.7;
    pointer-events: none;
    filter: grayscale(100%);
}

.action-icon-btn {
    width: 32px; /* Slightly larger for better clickability */
    height: 32px;
    border: none;
    background: white;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #546e7a;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    font-size: 14px;
}

.action-icon-btn:hover {
    background: #00bcd4;
    color: white;
    transform: scale(1.1);
}

.reason-badge {
    position: absolute;
    bottom: 3px;
    right: 3px;
    font-size: 8px;
    padding: 2px 4px;
    border-radius: 6px;
    background: rgba(0, 0, 0, 0.05);
    color: #546e7a;
    font-weight: 500;
}

/* Responsive para pantallas pequeñas */
@media (max-width: 1400px) {
    .card-content {
        padding: 6px;
    }
    
    .icon-container {
        width: 45px;
        height: 45px;
    }
    
    .resource-number {
        font-size: 32px;
    }
    
    .action-icon-btn {
        width: 28px;
        height: 28px;
        font-size: 12px;
    }
}

@media (max-width: 768px) {
    .card-content {
        padding: 5px;
    }
    
    .icon-container {
        width: 40px;
        height: 40px;
    }
    
    .resource-number {
        font-size: 28px;
    }
    
    .action-icon-btn {
        width: 26px;
        height: 26px;
        font-size: 11px;
    }
}
</style>
