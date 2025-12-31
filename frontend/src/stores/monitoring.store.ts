import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { Resource } from '../services/resource.service';
import type { WaitingRoomRecord } from '../services/waiting-room.service';

export const useMonitoringStore = defineStore('monitoring', () => {
    // State
    const resources = ref<Resource[]>([]);
    const waitingRoom = ref<WaitingRoomRecord[]>([]);
    const selectedDate = ref<Date>(new Date());
    const dailyStatistics = ref<any>(null);
    const isLoading = ref(false);

    // Getters
    const consultorios = computed(() =>
        resources.value.filter(r => r.type === 'CONSULTORIO')
    );

    const tratamientos = computed(() =>
        resources.value.filter(r => r.type === 'TRATAMIENTO')
    );

    const estancias = computed(() =>
        resources.value.filter(r => r.type === 'ESTANCIA')
    );

    const triajeResources = computed(() =>
        resources.value.filter(r => r.type === 'TRIAJE')
    );

    const availableResources = computed(() =>
        resources.value.filter(r => r.status === 'DISPONIBLE')
    );

    const occupiedResources = computed(() =>
        resources.value.filter(r => r.status === 'OCUPADO')
    );

    const disabledResources = computed(() =>
        resources.value.filter(r => r.status === 'INHABILITADO')
    );

    const waitingPatients = computed(() =>
        [...waitingRoom.value]
            .filter(w => w.status === 'ESPERANDO')
            .sort((a, b) => {
                // Priority: URGENTE (1) > NORMAL (0)
                const priorityOrder: Record<string, number> = { 'URGENTE': 1, 'NORMAL': 0 };
                const aPrio = priorityOrder[a.priority] || 0;
                const bPrio = priorityOrder[b.priority] || 0;

                if (aPrio !== bPrio) return bPrio - aPrio;

                // Time: Oldest first
                return new Date(a.checkInTime).getTime() - new Date(b.checkInTime).getTime();
            })
    );

    const urgentPatients = computed(() =>
        waitingRoom.value.filter(w => w.priority === 'URGENTE' && w.status === 'ESPERANDO')
    );

    // Actions
    function setResources(newResources: Resource[]) {
        resources.value = newResources;
    }

    function updateResource(updatedResource: Resource) {
        const index = resources.value.findIndex(r => r.id === updatedResource.id);
        if (index !== -1) {
            resources.value[index] = updatedResource;
        }
    }

    function addResource(newResource: Resource) {
        resources.value.push(newResource);
    }

    function setWaitingRoom(newWaitingRoom: WaitingRoomRecord[]) {
        waitingRoom.value = newWaitingRoom;
    }

    function updateWaitingRoomRecord(updatedRecord: WaitingRoomRecord) {
        const index = waitingRoom.value.findIndex(w => w.id === updatedRecord.id);
        if (index !== -1) {
            waitingRoom.value[index] = updatedRecord;
        }
    }

    function addToWaitingRoom(newRecord: WaitingRoomRecord) {
        const exists = waitingRoom.value.some(w => w.id === newRecord.id);
        if (!exists) {
            waitingRoom.value.push(newRecord);
        } else {
            updateWaitingRoomRecord(newRecord);
        }
    }

    function removeFromWaitingRoom(id: number) {
        waitingRoom.value = waitingRoom.value.filter(w => w.id !== id);
    }

    function setSelectedDate(date: Date) {
        selectedDate.value = date;
    }

    function setDailyStatistics(stats: any) {
        dailyStatistics.value = stats;
    }

    function updateAppointment(appointment: any) {
        if (dailyStatistics.value && dailyStatistics.value.appointments && dailyStatistics.value.appointments.list) {
            const index = dailyStatistics.value.appointments.list.findIndex((a: any) => a.id === appointment.id);
            if (index !== -1) {
                dailyStatistics.value.appointments.list[index] = appointment;
            } else {
                dailyStatistics.value.appointments.list.push(appointment);
            }
        }
    }

    function setLoading(loading: boolean) {
        isLoading.value = loading;
    }

    return {
        // State
        resources,
        waitingRoom,
        selectedDate,
        dailyStatistics,
        isLoading,

        // Getters
        consultorios,
        tratamientos,
        estancias,
        triajeResources,
        availableResources,
        occupiedResources,
        disabledResources,
        waitingPatients,
        urgentPatients,

        // Actions
        setResources,
        updateResource,
        addResource,
        setWaitingRoom,
        updateWaitingRoomRecord,
        addToWaitingRoom,
        removeFromWaitingRoom,
        setSelectedDate,
        setDailyStatistics,
        updateAppointment,
        setLoading
    };
});
