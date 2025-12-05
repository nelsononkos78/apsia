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
                    'high-occupancy': day.occupancyLevel === 'high',
                    'medium-occupancy': day.occupancyLevel === 'medium',
                    'has-appointments': day.appointmentCount > 0
                }]"
                @click="selectDate(day.date)"
            >
                <div class="day-number">{{ day.date.getDate() }}</div>
                <div v-if="day.appointmentCount > 0" class="appointment-count">
                    {{ day.appointmentCount }}
                </div>
            </div>
        </div>

        <div class="legend">
            <div class="legend-item">
                <span class="indicator today-indicator"></span>
                <span>Hoy</span>
            </div>
            <div class="legend-item">
                <span class="indicator medium-indicator"></span>
                <span>Media ocupación</span>
            </div>
            <div class="legend-item">
                <span class="indicator high-indicator"></span>
                <span>Alta ocupación</span>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { storeToRefs } from 'pinia';
import { useMonitoringStore } from '../../stores/monitoring.store';
import api from '../../services/api';

const monitoringStore = useMonitoringStore();
const { selectedDate } = storeToRefs(monitoringStore);

const currentMonth = ref(new Date());
const weekdays = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

const occupancyData = ref<Record<string, { count: number; level: string }>>({});

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
        const dateKey = current.toISOString().split('T')[0];
        const occupancy = occupancyData.value[dateKey] || { count: 0, level: 'low' };
        
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
        // Obtener todas las citas
        const response = await api.get('/appointments');
        const appointments = response.data;
        
        // Contar citas por día
        const counts: Record<string, number> = {};
        appointments.forEach((apt: any) => {
            const dateKey = new Date(apt.dateTime).toISOString().split('T')[0];
            counts[dateKey] = (counts[dateKey] || 0) + 1;
        });
        
        // Actualizar occupancyData
        Object.keys(counts).forEach(dateKey => {
            const count = counts[dateKey];
            let level = 'low';
            if (count > 30) level = 'high';
            else if (count > 15) level = 'medium';
            
            occupancyData.value[dateKey] = { count, level };
        });
    } catch (error) {
        console.error('Error loading appointment counts:', error);
    }
}

onMounted(() => {
    loadAppointmentCounts();
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
    background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
}

.panel-header h2 {
    margin: 0 0 12px 0;
    font-size: 18px;
    font-weight: 600;
    color: #263238;
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
    background: #00bcd4;
    border-color: #00bcd4;
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
    background: #e0f7fa;
    border-color: #00bcd4;
    font-weight: 700;
}

.calendar-day.today {
    background: #fff3e0;
    border-color: #ff9800;
}

.calendar-day.has-appointments {
    background: #e8f5e9;
}

.calendar-day.medium-occupancy {
    background: #fff9c4;
}

.calendar-day.high-occupancy {
    background: #ffcdd2;
}

.day-number {
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 2px;
    color: #263238;
}

.appointment-count {
    position: absolute;
    bottom: 2px;
    right: 2px;
    background: #00bcd4;
    color: white;
    font-size: 9px;
    font-weight: 700;
    padding: 2px 5px;
    border-radius: 8px;
    min-width: 16px;
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

.medium-indicator {
    background: #fff9c4;
}

.high-indicator {
    background: #ffcdd2;
}
</style>
