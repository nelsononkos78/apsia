<template>
    <div class="resource-grid-section">
        <div class="section-header">
            <h3 class="section-title">
                <i :class="['fas', typeIcon, 'icon']"></i>
                {{ typeTitle }}
            </h3>
            <div class="section-stats">
                <span class="stat available">{{ availableCount }} disponibles</span>
                <span class="stat occupied">{{ occupiedCount }} ocupados</span>
                <span class="stat disabled">{{ disabledCount }} inhabilitados</span>
            </div>
            <button @click="showAddModal = true" class="btn-add">
                <i class="fas fa-plus plus-icon"></i>
                Agregar
            </button>
        </div>

        <div class="resources-grid">
            <ResourceCard 
                v-for="resource in resources" 
                :key="resource.id"
                :resource="resource"
            />
        </div>

        <AddResourceModal 
            v-if="showAddModal"
            :resourceType="type"
            @close="showAddModal = false"
            @added="handleResourceAdded"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import ResourceCard from './ResourceCard.vue';
import AddResourceModal from './AddResourceModal.vue';
import type { Resource } from '../../services/resource.service';

const props = defineProps<{
    type: 'CONSULTORIO' | 'TRATAMIENTO' | 'ESTANCIA';
    resources: Resource[];
}>();

const showAddModal = ref(false);

const typeIcon = computed(() => {
    switch (props.type) {
        case 'CONSULTORIO': return 'fa-stethoscope';
        case 'TRATAMIENTO': return 'fa-syringe';
        case 'ESTANCIA': return 'fa-bed';
        default: return '';
    }
});

const typeTitle = computed(() => {
    switch (props.type) {
        case 'CONSULTORIO': return 'Consultorios';
        case 'TRATAMIENTO': return 'Sala de Tratamientos';
        case 'ESTANCIA': return 'Estancia (Camas)';
        default: return '';
    }
});

const availableCount = computed(() => 
    props.resources.filter(r => r.status === 'DISPONIBLE').length
);

const occupiedCount = computed(() => 
    props.resources.filter(r => r.status === 'OCUPADO').length
);

const disabledCount = computed(() => 
    props.resources.filter(r => r.status === 'INHABILITADO').length
);

function handleResourceAdded() {
    showAddModal.value = false;
}
</script>

<style scoped>
.resource-grid-section {
    margin-bottom: 32px;
}

.section-header {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 16px;
    padding: 16px;
    background: linear-gradient(135deg, #4fc3f7 0%, #29b6f6 100%);
    border-radius: 12px;
    color: white;
}

.section-title {
    margin: 0;
    font-size: 20px;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 8px;
}

.icon {
    font-size: 24px;
}

.section-stats {
    display: flex;
    gap: 12px;
    margin-left: auto;
}

.stat {
    padding: 4px 12px;
    border-radius: 12px;
    font-size: 13px;
    font-weight: 600;
    background: rgba(255, 255, 255, 0.2);
}

.stat.available {
    background: rgba(76, 175, 80, 0.8);
}

.stat.occupied {
    background: rgba(244, 67, 54, 0.8);
}

.stat.disabled {
    background: rgba(158, 158, 158, 0.8);
}

.btn-add {
    background: rgba(255, 255, 255, 0.9);
    color: #667eea;
    border: none;
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
    transition: all 0.3s ease;
}

.btn-add:hover {
    background: white;
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.plus-icon {
    font-size: 18px;
    font-weight: 700;
}

.resources-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 8px;
}

@media (max-width: 1600px) {
    .resources-grid {
        grid-template-columns: repeat(5, 1fr);
    }
}

@media (max-width: 1200px) {
    .resources-grid {
        grid-template-columns: repeat(4, 1fr);
    }
}

@media (max-width: 900px) {
    .resources-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media (max-width: 600px) {
    .resources-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}
</style>
