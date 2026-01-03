<template>
    <div class="calendar-panel">
        <div class="panel-header">
            <h2>Calendario</h2>
            <div class="month-selector">
                <button @click="previousMonth" class="nav-btn">‹</button>
                <span class="current-month">{{ currentMonthName }}</span>
                <button @click="nextMonth" class="nav-btn">›</button>
            </div>
        </div>

        <div class="calendar-grid">
            <div class="weekday-header" v-for="day in weekdays" :key="day">
                {{ day }}
            </div>

            <div 
                v-for="day in calendarDays" 
                :key="day.date.toISOString()"
                :class="['calendar-day', {
                    'other-month': !day.isCurrentMonth,
                    'selected': isSelected(day.date),
                    'today': isToday(day.date),
                    'has-appointments': day.appointmentCount > 0
                }]"
                @click="handleDayClick(day)"
            >
                <div class="day-number">{{ day.date.getDate() }}</div>
            </div>
        </div>

        <div class="legend">
            <div class="legend-item">
                <span class="indicator today-indicator"></span>
                <span>Hoy</span>
            </div>
            <div class="legend-item">
                <span class="indicator has-appointments-indicator"></span>
                <span>Con citas</span>
            </div>
        </div>
        
        <AppointmentDetailsModal 
            v-if="showModal && selectedDayAppointments.length > 0"
            :date="modalDate"
            :appointments="selectedDayAppointments"
            @close="showModal = false"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { storeToRefs } from 'pinia';
import { useMonitoringStore } from '../../stores/monitoring.store';
import { websocketService } from '../../services/websocket.service';
import api from '../../services/api';
import AppointmentDetailsModal from './AppointmentDetailsModal.vue';

const monitoringStore = useMonitoringStore();
const { selectedDate } = storeToRefs(monitoringStore);

const currentMonth = ref(new Date());
const weekdays = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

const occupancyData = ref<Record<string, { count: number; level: string; appointments: any[] }>>({});
const showModal = ref(false);
const modalDate = ref(new Date());
const selectedDayAppointments = ref<any[]>([]);

const currentMonthName = computed(() => {
    return currentMonth.value.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' });
});

interface CalendarDay {
    date: Date;
    isCurrentMonth: boolean;
    appointmentCount: number;
    occupancyLevel: string;
}

const calendarDays = computed((): CalendarDay[] => {
    const year = currentMonth.value.getFullYear();
    const month = currentMonth.value.getMonth();
    
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    
    const startDate = new Date(firstDay);
    startDate.setDate(startDate.getDate() - firstDay.getDay());
    
    const endDate = new Date(lastDay);
    endDate.setDate(endDate.getDate() + (6 - lastDay.getDay()));
    
    const days: CalendarDay[] = [];
    const current = new Date(startDate);
    
    while (current <= endDate) {
        const dateKey = `${current.getFullYear()}-${String(current.getMonth() + 1).padStart(2, '0')}-${String(current.getDate()).padStart(2, '0')}`;
        const occupancy = occupancyData.value[dateKey] || { count: 0, level: 'low', appointments: [] };
        
        days.push({
            date: new Date(current),
            isCurrentMonth: current.getMonth() === month,
            appointmentCount: occupancy.count,
            occupancyLevel: occupancy.level
        });
        
        current.setDate(current.getDate() + 1);
    }
    
    return days;
});

function previousMonth() {
    currentMonth.value = new Date(currentMonth.value.getFullYear(), currentMonth.value.getMonth() - 1);
    loadAppointmentCounts();
}

function nextMonth() {
    currentMonth.value = new Date(currentMonth.value.getFullYear(), currentMonth.value.getMonth() + 1);
    loadAppointmentCounts();
}

function handleDayClick(day: CalendarDay) {
    if (day.appointmentCount > 0) {
        const d = day.date;
        const dateKey = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
        const dayData = occupancyData.value[dateKey];
        if (dayData && dayData.appointments) {
            modalDate.value = day.date;
            selectedDayAppointments.value = dayData.appointments;
            showModal.value = true;
        }
    }
    selectDate(day.date);
}

function selectDate(date: Date) {
    monitoringStore.setSelectedDate(date);
    emit('dateSelected', date);
}

function isSelected(date: Date): boolean {
    return date.toDateString() === selectedDate.value.toDateString();
}

function isToday(date: Date): boolean {
    const today = new Date();
    return date.toDateString() === today.toDateString();
}

const emit = defineEmits<{
    dateSelected: [date: Date]
}>();

async function loadAppointmentCounts() {
    try {
        // Get all appointments
        const response = await api.get('/appointments');
        const appointments = response.data;
        
        // Count appointments by day and store appointment data
        const dataByDate: Record<string, any[]> = {};
        appointments.forEach((apt: any) => {
            const aptDate = new Date(apt.dateTime);
            const dateKey = `${aptDate.getFullYear()}-${String(aptDate.getMonth() + 1).padStart(2, '0')}-${String(aptDate.getDate()).padStart(2, '0')}`;
            if (!dataByDate[dateKey]) {
                dataByDate[dateKey] = [];
            }
            dataByDate[dateKey].push(apt);
        });
        
        // Update occupancyData with counts and appointment data
        occupancyData.value = {};
        Object.keys(dataByDate).forEach(dateKey => {
            const count = dataByDate[dateKey].length;
            let level = 'low';
            if (count > 30) level = 'high';
            else if (count > 15) level = 'medium';
            
            occupancyData.value[dateKey] = { 
                count, 
                level,
                appointments: dataByDate[dateKey]
            };
        });
    } catch (error) {
        console.error('Error loading appointment counts:', error);
    }
}

function handleAppointmentUpdate() {
    loadAppointmentCounts();
}

onMounted(() => {
    loadAppointmentCounts();
    
    // Listen for real-time appointment updates
    websocketService.on('appointment:created', handleAppointmentUpdate);
    websocketService.on('appointment:updated', handleAppointmentUpdate);
});

onUnmounted(() => {
    websocketService.off('appointment:created', handleAppointmentUpdate);
    websocketService.off('appointment:updated', handleAppointmentUpdate);
});
</script>

<style scoped>
.calendar-panel {
    background: white;
    border-radius: 16px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.panel-header {
    padding: 20px 24px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    background: #FCFCFC;
}

.panel-header h2 {
    margin: 0 0 12px 0;
    font-size: 18px;
    font-weight: 600;
    color: #223675;
}

.month-selector {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: #f5f5f5;
    padding: 8px 12px;
    border-radius: 8px;
}

.current-month {
    font-size: 14px;
    font-weight: 600;
    text-transform: capitalize;
    color: #455a64;
}

.nav-btn {
    background: white;
    border: 1px solid #e0e0e0;
    color: #546e7a;
    font-size: 18px;
    width: 32px;
    height: 32px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
}

.nav-btn:hover {
    background: #5371C4;
    border-color: #5371C4;
    color: white;
}

.calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 4px;
    padding: 16px;
    flex: 1;
}

.weekday-header {
    text-align: center;
    font-weight: 600;
    font-size: 11px;
    padding: 8px 4px;
    color: #78909c;
    text-transform: uppercase;
}

.calendar-day {
    background: #fafafa;
    border-radius: 8px;
    padding: 6px;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s ease;
    min-height: 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    position: relative;
    border: 2px solid transparent;
}

.calendar-day:hover {
    background: #f0f0f0;
    transform: scale(1.05);
}

.calendar-day.other-month {
    opacity: 0.3;
}

.calendar-day.selected {
    background: #C3E1ED;
    border-color: #5371C4;
    font-weight: 700;
}

.calendar-day.today {
    background: #fff3e0;
    border-color: #ff9800;
}

.calendar-day.has-appointments {
    background: #CEEAC7;
}

.day-number {
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 2px;
    color: #223675;
}

.legend {
    display: flex;
    gap: 12px;
    padding: 12px 16px;
    border-top: 1px solid rgba(0, 0, 0, 0.06);
    font-size: 11px;
    flex-wrap: wrap;
}

.legend-item {
    display: flex;
    align-items: center;
    gap: 6px;
}

.indicator {
    width: 14px;
    height: 14px;
    border-radius: 3px;
}

.today-indicator {
    background: #fff3e0;
    border: 2px solid #ff9800;
}

.has-appointments-indicator {
    background: #CEEAC7;
    border: 2px solid #A5D8A9;
}
</style>
