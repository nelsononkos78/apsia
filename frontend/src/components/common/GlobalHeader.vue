<template>
  <header :class="['global-header', { 'dark-mode': dark }]">
    <div :class="['header-container', { 'full-width': fullWidth }]">
      <div class="brand">
        <img :src="logo" alt="Logo" class="logo" :style="{ height: logoHeight || '45px' }" />
        <div v-if="!hideTitle" class="title-group">
          <h1 class="title">{{ title }}</h1>
          <p v-if="subtitle" class="subtitle">{{ subtitle }}</p>
        </div>
      </div>
      
      <div class="header-center">
        <slot name="center"></slot>
      </div>

      <div class="header-actions">
        <slot name="actions"></slot>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = defineProps<{
  logo?: string;
  title?: string;
  subtitle?: string;
  hideTitle?: boolean;
  dark?: boolean;
  logoHeight?: string;
  fullWidth?: boolean;
}>();

const logo = computed(() => props.logo || '/src/assets/logo.png');
const title = computed(() => props.title || 'Sistema de Gestión de Pacientes');
</script>

<style scoped>
.global-header {
  background: #FCFCFC;
  padding: 0.75rem 2rem;
  border-bottom: 1px solid rgba(34, 54, 117, 0.08);
  z-index: 100;
  transition: all 0.3s ease;
}

.global-header.dark-mode {
  background: #1f2937; /* gray-800 */
  border-bottom: 2px solid #374151; /* gray-700 */
  color: white;
}

.header-container {
  max-width: 1600px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  width: 100%;
}

.header-container.full-width {
  max-width: none;
  padding: 0 2rem;
}

.brand {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.logo {
  width: auto;
  object-fit: contain;
}

.title-group {
  display: flex;
  flex-direction: column;
}

.title {
  margin: 0;
  font-size: 1.25rem;
  color: #223675;
  font-weight: 800;
  letter-spacing: -0.5px;
}

.dark-mode .title {
  color: #f9fafb;
}

.subtitle {
  margin: 0;
  font-size: 0.8rem;
  color: #5371C4;
  font-weight: 500;
}

.dark-mode .subtitle {
  color: #9ca3af;
}

.header-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.header-actions {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}
</style>
