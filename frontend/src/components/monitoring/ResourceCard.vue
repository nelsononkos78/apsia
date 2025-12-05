<template>
    <div :class="['resource-card-minimal', `status-${resource.status.toLowerCase()}`]">
        <div class="card-content">
            <div class="icon-container">
                <div class="resource-number">{{ resourceNumber }}</div>
            </div>
            <div class="action-buttons">
                <button 
                    v-if="resource.status === 'DISPONIBLE'" 
                    @click="markAsOccupied"
                    class="action-icon-btn"
                    title="Ocupar"
                >
                    <i class="fas fa-user"></i>
                </button>
                <button 
                    v-if="resource.status === 'OCUPADO'" 
                    @click="markAsAvailable"
                    class="action-icon-btn"
                    title="Liberar"
                >
                    <i class="fas fa-check-circle"></i>
                </button>
                <button 
                    @click="toggleDisable"
                    class="action-icon-btn"
                    :title="resource.status === 'INHABILITADO' ? 'Habilitar' : 'Inhabilitar'"
                >
                    <i :class="resource.status === 'INHABILITADO' ? 'fas fa-unlock' : 'fas fa-lock'"></i>
                </button>
            </div>
        </div>
        <span v-if="resource.statusReason" class="reason-badge">{{ reasonText }}</span>
    </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { Resource } from '../../services/resource.service';
import { resourceService } from '../../services/resource.service';
import { useMonitoringStore } from '../../stores/monitoring.store';

const props = defineProps<{
    resource: Resource
}>();

const monitoringStore = useMonitoringStore();

const resourceIconClass = computed(() => {
    switch (props.resource.type) {
        case 'CONSULTORIO': return 'fas fa-stethoscope';
        case 'TRATAMIENTO': return 'fas fa-syringe';
        case 'ESTANCIA': return 'fas fa-bed';
        default: return '';
    }
});

const resourceNumber = computed(() => {
    // Extraer número del nombre (ej: "Consultorio 1" -> "1")
    const match = props.resource.name.match(/\d+/);
    return match ? match[0] : '?';
});

const reasonText = computed(() => {
    switch (props.resource.statusReason) {
        case 'MANTENIMIENTO': return 'Mantenimiento';
        case 'LIMPIEZA': return 'Limpieza';
        case 'FALLA': return 'Falla';
        default: return '';
    }
});

async function markAsOccupied() {
    try {
        const updated = await resourceService.updateResourceStatus(props.resource.id, {
            status: 'OCUPADO'
        });
        monitoringStore.updateResource(updated);
    } catch (error) {
        console.error('Error updating resource:', error);
    }
}

async function markAsAvailable() {
    try {
        const updated = await resourceService.releaseResource(props.resource.id);
        monitoringStore.updateResource(updated);
    } catch (error) {
        console.error('Error releasing resource:', error);
    }
}

async function toggleDisable() {
    try {
        const newStatus = props.resource.status === 'INHABILITADO' ? 'DISPONIBLE' : 'INHABILITADO';
        const reason = newStatus === 'INHABILITADO' ? 'MANTENIMIENTO' : undefined;
        
        const updated = await resourceService.updateResourceStatus(props.resource.id, {
            status: newStatus,
            reason
        });
        monitoringStore.updateResource(updated);
    } catch (error) {
        console.error('Error toggling resource status:', error);
    }
}
</script>

<style scoped>
.resource-card-minimal {
    width: 150px;
    height: 70px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
    border: 1px solid rgba(0, 0, 0, 0.06);
    position: relative;
}

.resource-card-minimal::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    transition: all 0.3s ease;
}

/* Colores homologados: Verde = Disponible, Rojo = Ocupado */
.resource-card-minimal.status-disponible::before {
    background: linear-gradient(90deg, #4caf50, #66bb6a);
}

.resource-card-minimal.status-ocupado::before {
    background: linear-gradient(90deg, #f44336, #ef5350);
}

.resource-card-minimal.status-inhabilitado::before {
    background: linear-gradient(90deg, #9e9e9e, #bdbdbd);
}

.resource-card-minimal:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.card-content {
    padding: 8px;
    display: flex;
    align-items: center;
    gap: 0;
    height: 100%;
}

.icon-container {
    width: 50px;
    height: 50px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    position: relative;
    transition: all 0.3s ease;
}

/* Colores de fondo del icono homologados */
.status-disponible .icon-container {
    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.status-ocupado .icon-container {
    background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

.status-inhabilitado .icon-container {
    background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
}

.resource-number {
    font-size: 36px;
    font-weight: 900;
    line-height: 1;
}

/* Colores del número según estado */
.status-disponible .resource-number {
    color: #a5d8a9;
}

.status-ocupado .resource-number {
    color: #ffaaaa;
}

.status-inhabilitado .resource-number {
    color: #757575;
}

.action-buttons {
    display: flex;
    gap: 3px;
    margin-left: auto;
}

.action-icon-btn {
    width: 26px;
    height: 26px;
    border: none;
    background: white;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #546e7a;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    font-size: 11px;
}

.action-icon-btn:hover {
    background: #00bcd4;
    color: white;
    transform: scale(1.1);
}

.reason-badge {
    position: absolute;
    bottom: 3px;
    right: 3px;
    font-size: 8px;
    padding: 2px 4px;
    border-radius: 6px;
    background: rgba(0, 0, 0, 0.05);
    color: #546e7a;
    font-weight: 500;
}

/* Responsive para pantallas pequeñas */
@media (max-width: 1400px) {
    .card-content {
        padding: 6px;
    }
    
    .icon-container {
        width: 45px;
        height: 45px;
    }
    
    .resource-number {
        font-size: 32px;
    }
    
    .action-icon-btn {
        width: 24px;
        height: 24px;
        font-size: 10px;
    }
}

@media (max-width: 768px) {
    .card-content {
        padding: 5px;
    }
    
    .icon-container {
        width: 40px;
        height: 40px;
    }
    
    .resource-number {
        font-size: 28px;
    }
    
    .action-icon-btn {
        width: 22px;
        height: 22px;
        font-size: 9px;
    }
    
    .action-buttons {
        gap: 2px;
    }
}
</style>
