<template>
  <div class="digital-clock">
    <div class="time">{{ time }}</div>
    <div class="date">{{ date }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

const time = ref(new Date().toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', second: '2-digit' }));
const date = ref('');
let timer: number | undefined;

const updateClock = () => {
  const now = new Date();
  time.value = now.toLocaleTimeString('es-ES', { 
    hour: '2-digit', 
    minute: '2-digit', 
    second: '2-digit' 
  });
  date.value = now.toLocaleDateString('es-ES', { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
  
  // Use recursive setTimeout for robust scheduling
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
.digital-clock {
  background: #263238;
  color: #fff;
  padding: 10px 20px;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  min-width: 200px;
}

.time {
  font-size: 24px;
  font-weight: 700;
  font-family: 'Courier New', monospace;
  letter-spacing: 2px;
  line-height: 1.2;
}

.date {
  font-size: 11px;
  opacity: 0.8;
  text-transform: capitalize;
  margin-top: 2px;
}
</style>
