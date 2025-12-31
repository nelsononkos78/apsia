<template>
    <div class="modal-overlay" @click.self="$emit('close')">
        <div class="modal-container">
            <div class="modal-header">
                <h3>
                    <i class="far fa-calendar-alt"></i>
                    Citas del {{ formattedDate }}
                </h3>
                <button @click="$emit('close')" class="btn-close">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <div v-if="appointments.length === 0" class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <p>No hay citas programadas para este día</p>
                </div>
                
                <div v-else class="appointments-list">
                    <div 
                        v-for="apt in sortedAppointments" 
                        :key="apt.id"
                        :class="['appointment-item', `status-${apt.status.toLowerCase()}`]"
                    >
                        <div class="apt-time">
                            <i class="far fa-clock"></i>
                            {{ formatTime(apt.dateTime) }}
                        </div>
                        <div class="apt-details">
                            <div class="apt-patient">
                                <i class="fas fa-user"></i>
                                {{ apt.patient?.name || 'Paciente' }}
                            </div>
                            <div class="apt-doctor">
                                <i class="fas fa-user-md"></i>
                                {{ apt.doctor?.name || 'Sin asignar' }}
                            </div>
                            <div class="apt-service">
                                <i class="fas fa-notes-medical"></i>
                                {{ apt.serviceType?.name || 'Servicio' }}
                            </div>
                        </div>
                        <div class="apt-status">
                            <span :class="['status-badge', `badge-${apt.status.toLowerCase()}`]">
                                {{ getStatusLabel(apt.status) }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="modal-footer">
                <div class="summary">
                    Total: <strong>{{ appointments.length }}</strong> citas
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = defineProps<{
    date: Date;
    appointments: any[];
}>();

defineEmits<{
    close: []
}>();

const formattedDate = computed(() => {
    return props.date.toLocaleDateString('es-ES', { 
        weekday: 'long', 
        day: 'numeric', 
        month: 'long', 
        year: 'numeric' 
    });
});

const sortedAppointments = computed(() => {
    return [...props.appointments].sort((a, b) => {
        return new Date(a.dateTime).getTime() - new Date(b.dateTime).getTime();
    });
});

function formatTime(dateStr: string) {
    return new Date(dateStr).toLocaleTimeString('es-ES', { 
        hour: '2-digit', 
        minute: '2-digit' 
    });
}

function getStatusLabel(status: string) {
    const labels: Record<string, string> = {
        'SCHEDULED': 'Programada',
        'CHECKED_IN': 'En espera',
        'IN_PROGRESS': 'En atención',
        'COMPLETED': 'Completada',
        'CANCELLED': 'Cancelada',
        'NO_SHOW': 'No asistió'
    };
    return labels[status] || status;
}
</script>

<style scoped>
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    backdrop-filter: blur(4px);
}

.modal-container {
    background: white;
    border-radius: 16px;
    width: 90%;
    max-width: 700px;
    max-height: 80vh;
    display: flex;
    flex-direction: column;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.modal-header {
    padding: 24px;
    border-bottom: 1px solid #e0e0e0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-header h3 {
    margin: 0;
    font-size: 20px;
    font-weight: 700;
    color: #263238;
    display: flex;
    align-items: center;
    gap: 12px;
    text-transform: capitalize;
}

.modal-header h3 i {
    color: #00bcd4;
    font-size: 24px;
}

.btn-close {
    background: none;
    border: none;
    font-size: 24px;
    color: #78909c;
    cursor: pointer;
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    transition: all 0.2s;
}

.btn-close:hover {
    background: #f5f5f5;
    color: #263238;
}

.modal-body {
    flex: 1;
    overflow-y: auto;
    padding: 16px 24px;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #90a4ae;
}

.empty-state i {
    font-size: 64px;
    margin-bottom: 16px;
    opacity: 0.3;
}

.empty-state p {
    margin: 0;
    font-size: 16px;
}

.appointments-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.appointment-item {
    background: #fafafa;
    border-radius: 12px;
    padding: 16px;
    display: grid;
    grid-template-columns: 100px 1fr auto;
    gap: 16px;
    align-items: center;
    border-left: 4px solid #e0e0e0;
    transition: all 0.2s;
}

.appointment-item:hover {
    background: #f5f5f5;
    transform: translateX(4px);
}

.appointment-item.status-in_progress {
    border-left-color: #2196f3;
    background: #e3f2fd;
}

.appointment-item.status-checked_in {
    border-left-color: #ff9800;
    background: #fff3e0;
}

.appointment-item.status-completed {
    border-left-color: #4caf50;
}

.apt-time {
    font-size: 18px;
    font-weight: 700;
    color: #263238;
    display: flex;
    align-items: center;
    gap: 8px;
}

.apt-time i {
    color: #00bcd4;
    font-size: 16px;
}

.apt-details {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.apt-patient,
.apt-doctor,
.apt-service {
    font-size: 14px;
    color: #546e7a;
    display: flex;
    align-items: center;
    gap: 8px;
}

.apt-patient {
    font-weight: 700;
    color: #263238;
    font-size: 15px;
}

.apt-patient i {
    color: #00bcd4;
}

.apt-doctor i {
    color: #7e57c2;
}

.apt-service i {
    color: #26a69a;
}

.apt-status {
    display: flex;
    align-items: center;
}

.status-badge {
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    white-space: nowrap;
}

.badge-scheduled {
    background: #e3f2fd;
    color: #1976d2;
}

.badge-checked_in {
    background: #fff3e0;
    color: #f57c00;
}

.badge-in_progress {
    background: #e8f5e9;
    color: #388e3c;
}

.badge-completed {
    background: #f1f8e9;
    color: #689f38;
}

.badge-cancelled {
    background: #ffebee;
    color: #d32f2f;
}

.badge-no_show {
    background: #fce4ec;
    color: #c2185b;
}

.modal-footer {
    padding: 16px 24px;
    border-top: 1px solid #e0e0e0;
    background: #fafafa;
}

.summary {
    font-size: 14px;
    color: #546e7a;
}

.summary strong {
    color: #263238;
    font-size: 16px;
}

@media (max-width: 768px) {
    .appointment-item {
        grid-template-columns: 1fr;
        gap: 12px;
    }
    
    .apt-time {
        font-size: 16px;
    }
}
</style>
