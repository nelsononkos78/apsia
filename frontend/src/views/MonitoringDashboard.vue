<template>
    <div class="monitoring-dashboard-modern">
        <div class="dashboard-container">
            <!-- Sidebar izquierdo: Sala de Espera + Calendario -->
            <aside class="sidebar-left">
                <div class="sidebar-section waiting-section">
                    <WaitingRoomPanel />
                </div>
                <div class="sidebar-section calendar-section">
                    <CalendarPanel @dateSelected="handleDateSelected" />
                </div>
            </aside>

            <!-- Área principal: Recursos -->
            <main class="main-content">
                <header class="content-header">
                    <div class="header-left">
                        <h1>Panel de Monitoreo</h1>
                        <p class="subtitle">{{ currentDateDisplay }}</p>
                    </div>
                    <div class="header-center">
                        <DigitalClock />
                        <div class="time-selector">
                            <select v-model="selectedHour" class="hour-select">
                                <option :value="null">Tiempo Real</option>
                                <option v-for="h in hours" :key="h" :value="h">{{ h }}:00</option>
                            </select>
                        </div>
                    </div>
                    <div class="connection-indicator" :class="{ connected: isConnected }">
                        <i :class="isConnected ? 'fas fa-circle' : 'fas fa-circle-notch fa-spin'"></i>
                        <span>{{ isConnected ? 'Conectado' : 'Conectando...' }}</span>
                    </div>
                </header>

                <div class="resources-container">
                    <ResourceGrid 
                        type="CONSULTORIO"
                        :resources="consultorios"
                        :resourceDetails="resourceDetails"
                    />
                    <ResourceGrid 
                        type="TRATAMIENTO"
                        :resources="tratamientos"
                        :resourceDetails="resourceDetails"
                    />
                    <ResourceGrid 
                        type="ESTANCIA"
                        :resources="estancias"
                        :resourceDetails="resourceDetails"
                    />
                </div>
            </main>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { storeToRefs } from 'pinia';
import { useMonitoringStore } from '../stores/monitoring.store';
import { resourceService } from '../services/resource.service';
import { waitingRoomService } from '../services/waiting-room.service';
import { monitoringService } from '../services/monitoring.service';
import api from '../services/api';
import WaitingRoomPanel from '../components/monitoring/WaitingRoomPanel.vue';
import CalendarPanel from '../components/monitoring/CalendarPanel.vue';
import ResourceGrid from '../components/monitoring/ResourceGrid.vue';
import DigitalClock from '../components/monitoring/DigitalClock.vue';
import { websocketService } from '../services/websocket.service';

const monitoringStore = useMonitoringStore();
const { consultorios, tratamientos, estancias, selectedDate, dailyStatistics } = storeToRefs(monitoringStore);

const isConnected = ref(true);
const selectedHour = ref<number | null>(null);
const hours = Array.from({ length: 13 }, (_, i) => i + 8); // 8:00 to 20:00
let refreshInterval: number | null = null;

const currentDateDisplay = computed(() => {
    return selectedDate.value.toLocaleDateString('es-ES', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
});

const resourceDetails = computed(() => {
    const details: Record<number, { doctorName?: string; patientName?: string; treatmentInfo?: string }> = {};
    
    let relevantAppointments = [];

    if (selectedHour.value !== null) {
        // Filter by scheduled hour
        relevantAppointments = dailyStatistics.value?.appointments?.list?.filter((a: any) => {
            const date = new Date(a.dateTime);
            return date.getHours() === selectedHour.value;
        }) || [];
    } else {
        // Real-time: Active appointments
        relevantAppointments = dailyStatistics.value?.appointments?.list?.filter((a: any) => 
            a.status === 'IN_PROGRESS' || a.status === 'CHECKED_IN'
        ) || [];
    }

    relevantAppointments.forEach((apt: any) => {
        if (apt.resourceId) {
            details[apt.resourceId] = {
                doctorName: apt.doctor ? `Dr. ${apt.doctor.name.split(' ')[0]}` : undefined,
                patientName: apt.patient ? `${apt.patient.firstName} ${apt.patient.lastName}` : undefined,
                treatmentInfo: apt.serviceType
            };
        }
    });

    return details;
});

async function loadData() {
    try {
        // Cargar recursos con su estado real del backend
        const resources = await resourceService.getAllResources();
        monitoringStore.setResources(resources);

        // Cargar sala de espera
        const waitingRoom = await waitingRoomService.getCurrentList();
        monitoringStore.setWaitingRoom(waitingRoom);

        // Cargar estadísticas
        const stats = await monitoringService.getDailyStatistics(selectedDate.value);
        monitoringStore.setDailyStatistics(stats);
    } catch (error) {
        console.error('Error loading monitoring data:', error);
    }
}

async function handleDateSelected(date: Date) {
    monitoringStore.setSelectedDate(date);
    await loadData();
}

onMounted(async () => {
    await loadData();
    
    isConnected.value = websocketService.isConnected();
    
    websocketService.on('resource:updated', (resource: any) => {
        monitoringStore.updateResource(resource);
    });
    
    websocketService.on('resource:created', (resource: any) => {
        monitoringStore.addResource(resource);
    });
    
    websocketService.on('waitingRoom:updated', (record: any) => {
        monitoringStore.updateWaitingRoomRecord(record);
    });
    
    websocketService.on('waitingRoom:added', (record: any) => {
        monitoringStore.addToWaitingRoom(record);
    });
    
    websocketService.on('waitingRoom:removed', (recordId: number) => {
        monitoringStore.removeFromWaitingRoom(recordId);
    });

    websocketService.on('appointment:updated', (appointment: any) => {
        monitoringStore.updateAppointment(appointment);
    });

    websocketService.on('appointment:created', (appointment: any) => {
        monitoringStore.updateAppointment(appointment);
    });
    
    const connectionCheckInterval = setInterval(() => {
        isConnected.value = websocketService.isConnected();
    }, 1000);
    
    refreshInterval = window.setInterval(() => {
        if (!websocketService.isConnected()) {
            loadData();
        }
    }, 30000);
    
    onUnmounted(() => {
        if (refreshInterval) {
            clearInterval(refreshInterval);
        }
        clearInterval(connectionCheckInterval);
    });
});
</script>

<style scoped>
.monitoring-dashboard-modern {
    min-height: 100vh;
    background: linear-gradient(135deg, #eceff1 0%, #cfd8dc 100%);
    padding: 0;
}

.dashboard-container {
    display: grid;
    grid-template-columns: 380px 1fr;
    height: 100vh;
    gap: 0;
}

.sidebar-left {
    background: #f5f7fa;
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 16px;
    overflow-y: auto;
    border-right: 1px solid rgba(0, 0, 0, 0.08);
}

.sidebar-section {
    flex-shrink: 0;
}

.waiting-section {
    height: 45vh;
    min-height: 400px;
}

.calendar-section {
    height: 45vh;
    min-height: 400px;
}

.main-content {
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.content-header {
    background: white;
    padding: 24px 32px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}

.header-left h1 {
    margin: 0 0 4px 0;
    font-size: 24px;
    font-weight: 700;
    color: #263238;
}

.subtitle {
    margin: 0;
    font-size: 13px;
    color: #78909c;
    text-transform: capitalize;
}

.header-center {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
}

.hour-select {
    padding: 4px 12px;
    border-radius: 8px;
    border: 1px solid #cfd8dc;
    background: white;
    font-size: 12px;
    color: #455a64;
    cursor: pointer;
    outline: none;
}

.connection-indicator {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    border-radius: 20px;
    background: #ffebee;
    color: #c62828;
    font-size: 13px;
    font-weight: 500;
}

.connection-indicator.connected {
    background: #e8f5e9;
    color: #2e7d32;
}

.connection-indicator i {
    font-size: 10px;
}

.resources-container {
    flex: 1;
    overflow-y: auto;
    padding: 24px 32px;
}

@media (max-width: 1400px) {
    .dashboard-container {
        grid-template-columns: 320px 1fr;
    }
}

@media (max-width: 1200px) {
    .dashboard-container {
        grid-template-columns: 1fr;
        grid-template-rows: auto 1fr;
    }
    
    .sidebar-left {
        flex-direction: row;
        height: auto;
        overflow-x: auto;
        border-right: none;
        border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    }
    
    .sidebar-section {
        min-width: 350px;
    }
    
    .waiting-section,
    .calendar-section {
        height: 500px;
    }
}
</style>
