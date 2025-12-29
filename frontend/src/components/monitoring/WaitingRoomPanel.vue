<template>
    <div class="waiting-room-modern">
        <div class="panel-header-modern">
            <div class="header-left">
                <i class="fas fa-users header-icon"></i>
                <h2>Sala de Espera</h2>
            </div>
            <div class="stats-badges">
                <span class="badge badge-total">{{ waitingPatients.length }}</span>
                <span v-if="urgentCount > 0" class="badge badge-urgent">{{ urgentCount }} urgentes</span>
            </div>
        </div>

        <div class="patient-list-modern">
            <div 
                v-for="record in waitingPatients" 
                :key="record.id"
                :class="['patient-item', { urgent: record.priority === 'URGENTE' }]"
            >
                <div class="patient-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="patient-details">
                    <div class="patient-name-row">
                        <span class="patient-name">{{ record.patient?.name || 'Paciente' }}</span>
                        <span v-if="record.patient?.medicalRecordNumber" class="medical-record-badge">
                            {{ record.patient.medicalRecordNumber }}
                        </span>
                    </div>
                    <div class="patient-meta-row">
                        <span class="meta-item office-badge">
                            <i class="fas fa-door-open"></i>
                            {{ getAssignedResource(record.appointment) }}
                        </span>
                        <span class="meta-item wait-time">
                            <i class="fas fa-clock"></i>
                            {{ calculateWaitTime(record.checkInTime) }}
                        </span>
                    </div>
                </div>
            </div>

            <div v-if="waitingPatients.length === 0" class="empty-state-modern">
                <i class="fas fa-inbox"></i>
                <p>No hay pacientes en espera</p>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { storeToRefs } from 'pinia';
import { useMonitoringStore } from '../../stores/monitoring.store';
import { waitingRoomService } from '../../services/waiting-room.service';

const monitoringStore = useMonitoringStore();
const { waitingPatients, resources } = storeToRefs(monitoringStore);

function getAssignedResource(appointment?: any) {
    if (!appointment) return 'Sin asignar';
    
    // 1. Intentar por resourceId directo
    if (appointment.resourceId) {
        const resource = resources.value.find(r => r.id === appointment.resourceId);
        if (resource) return resource.name;
    }
    
    // 2. Intentar por doctorId
    if (appointment.doctorId) {
        const resource = resources.value.find(r => r.doctorId === appointment.doctorId);
        if (resource) return resource.name;
    }
    
    return 'Sin asignar';
}

const urgentCount = computed(() => 
    waitingPatients.value.filter(p => p.priority === 'URGENTE').length
);

function calculateWaitTime(checkInTime: string): string {
    const now = new Date();
    const checkIn = new Date(checkInTime);
    const diffMs = now.getTime() - checkIn.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    
    if (diffMins < 60) {
        return `${diffMins}min`;
    } else {
        const hours = Math.floor(diffMins / 60);
        const mins = diffMins % 60;
        return `${hours}h ${mins}m`;
    }
}

async function callPatient(id: number) {
    try {
        const updated = await waitingRoomService.callPatient(id);
        monitoringStore.updateWaitingRoomRecord(updated);
    } catch (error) {
        console.error('Error calling patient:', error);
    }
}

async function markAttended(id: number) {
    try {
        await waitingRoomService.markAsAttended(id);
        monitoringStore.removeFromWaitingRoom(id);
    } catch (error) {
        console.error('Error marking patient as attended:', error);
    }
}
</script>

<style scoped>
.waiting-room-modern {
    background: white;
    border-radius: 16px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.panel-header-modern {
    padding: 20px 24px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
}

.header-left {
    display: flex;
    align-items: center;
    gap: 12px;
}

.header-icon {
    font-size: 24px;
    color: #00bcd4;
}

.panel-header-modern h2 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    color: #263238;
}

.stats-badges {
    display: flex;
    gap: 8px;
}

.badge {
    padding: 4px 12px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 600;
}

.badge-total {
    background: #e0f7fa;
    color: #00838f;
}

.badge-urgent {
    background: #ffebee;
    color: #c62828;
}

.patient-list-modern {
    flex: 1;
    overflow-y: auto;
    padding: 12px;
}

.patient-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 12px;
    margin-bottom: 4px;
    background: #fafafa;
    border-radius: 8px;
    transition: all 0.2s ease;
    border-left: 3px solid transparent;
}

.patient-item:hover {
    background: #f5f5f5;
    transform: translateX(2px);
}

.patient-item.urgent {
    border-left-color: #f44336;
    background: #ffebee;
}

.patient-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: linear-gradient(135deg, #e0f7fa, #b2ebf2);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.patient-avatar i {
    font-size: 16px;
    color: #00838f;
}

.patient-details {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.patient-name-row {
    display: flex;
    align-items: center;
}

.patient-name {
    font-size: 13px;
    font-weight: 600;
    color: #263238;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.medical-record-badge {
    background: #f0f0f0;
    color: #555;
    padding: 2px 8px;
    margin-left: 8px;
    border-radius: 4px;
    font-size: 10px;
    font-weight: 600;
    font-family: 'Courier New', monospace;
    border: 1px solid #ddd;
}

.patient-meta-row {
    display: flex;
    align-items: center;
    gap: 12px;
}

.office-badge {
    background: #e3f2fd;
    color: #1976d2;
    padding: 1px 6px;
    border-radius: 4px;
    font-size: 10px;
    font-weight: 700;
    flex-shrink: 0;
}

.wait-time {
    font-size: 10px;
    color: #78909c;
    font-weight: 500;
}

.meta-item {
    display: flex;
    align-items: center;
    gap: 4px;
}

.meta-item i {
    font-size: 9px;
}

.patient-actions {
    display: flex;
    gap: 4px;
}

.action-icon-btn {
    width: 32px;
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
}

.action-icon-btn:hover {
    background: #00bcd4;
    color: white;
    transform: scale(1.1);
}

.empty-state-modern {
    text-align: center;
    padding: 60px 20px;
    color: #90a4ae;
}

.empty-state-modern i {
    font-size: 48px;
    margin-bottom: 16px;
    opacity: 0.3;
}

.empty-state-modern p {
    margin: 0;
    font-size: 14px;
}
</style>
