<template>
  <div class="digital-clock-container">
    <div class="date-section">
      <i class="far fa-calendar-alt"></i>
      <span class="date-text">{{ date }}</span>
    </div>
    <div class="time-section">
      <span class="time-text">{{ time }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

const time = ref('');
const date = ref('');
let timer: number | undefined;

const updateClock = () => {
  const now = new Date();
  
  // Time format: HH:mm
  time.value = now.toLocaleTimeString('es-ES', { 
    hour: '2-digit', 
    minute: '2-digit',
    hour12: false
  });

  // Date format: martes, 30 de diciembre
  date.value = now.toLocaleDateString('es-ES', { 
    weekday: 'long', 
    day: 'numeric',
    month: 'long'
  });
  
  timer = window.setTimeout(updateClock, 1000);
};

onMounted(() => {
  updateClock();
});

onUnmounted(() => {
  if (timer) clearTimeout(timer);
});
</script>

<style scoped>
.digital-clock-container {
  background: #223675;
  color: white;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 0.5rem 1rem;
  border-radius: 16px;
  border: 1px solid #5371C4;
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
}

.date-section {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #C3E1ED;
  font-size: 1.1rem;
  font-weight: 500;
}

.date-section i {
  font-size: 1.2rem;
  opacity: 0.8;
}

.date-text {
  text-transform: lowercase;
}

.date-text::first-letter {
  text-transform: none;
}

.time-section {
  background: #5371C4;
  color: white;
  padding: 0.4rem 1.2rem;
  border-radius: 12px;
  border: 1px solid #C3E1ED;
}

.time-text {
  font-size: 1.8rem;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
}
</style>
