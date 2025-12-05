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
        waitingRoom.value.filter(w => w.status === 'ESPERANDO')
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
        waitingRoom.value.push(newRecord);
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
        setLoading
    };
});
