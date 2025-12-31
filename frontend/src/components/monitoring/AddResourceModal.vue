<template>
    <div class="modal-overlay" @click.self="close">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Agregar Nuevo Recurso</h2>
                <button @click="close" class="btn-close">✕</button>
            </div>

            <form @submit.prevent="handleSubmit" class="modal-body">
                <div class="form-group">
                    <label for="name">Nombre del Recurso *</label>
                    <input 
                        id="name"
                        v-model="formData.name"
                        type="text"
                        placeholder="Ej: Consultorio 5"
                        required
                    />
                </div>

                <div class="form-group">
                    <label for="type">Tipo de Recurso *</label>
                    <select id="type" v-model="formData.type" required disabled>
                        <option value="CONSULTORIO">Consultorio</option>
                        <option value="TRATAMIENTO">Sala de Tratamiento</option>
                        <option value="ESTANCIA">Estancia (Cama)</option>
                        <option value="TRIAJE">Triaje</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="capacity">Capacidad</label>
                    <input 
                        id="capacity"
                        v-model.number="formData.capacity"
                        type="number"
                        min="1"
                        placeholder="1"
                    />
                    <small>Normalmente 1 para consultorios y camas</small>
                </div>

                <div class="form-group">
                    <label for="notes">Notas (opcional)</label>
                    <textarea 
                        id="notes"
                        v-model="formData.notes"
                        rows="3"
                        placeholder="Información adicional sobre el recurso..."
                    ></textarea>
                </div>

                <div class="modal-actions">
                    <button type="button" @click="close" class="btn-cancel">
                        Cancelar
                    </button>
                    <button type="submit" class="btn-submit" :disabled="isSubmitting">
                        {{ isSubmitting ? 'Creando...' : 'Crear Recurso' }}
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { resourceService } from '../../services/resource.service';
import { useMonitoringStore } from '../../stores/monitoring.store';

const props = defineProps<{
    resourceType: 'CONSULTORIO' | 'TRATAMIENTO' | 'ESTANCIA' | 'TRIAJE'
}>();

const emit = defineEmits<{
    close: []
    added: []
}>();

const monitoringStore = useMonitoringStore();

const formData = ref({
    name: '',
    type: props.resourceType,
    capacity: 1,
    notes: ''
});

const isSubmitting = ref(false);

async function handleSubmit() {
    isSubmitting.value = true;
    try {
        const newResource = await resourceService.createResource({
            name: formData.value.name,
            type: formData.value.type,
            capacity: formData.value.capacity || 1,
            notes: formData.value.notes || undefined
        });
        
        monitoringStore.addResource(newResource);
        emit('added');
        emit('close');
    } catch (error) {
        console.error('Error creating resource:', error);
        alert('Error al crear el recurso. Por favor intente nuevamente.');
    } finally {
        isSubmitting.value = false;
    }
}

function close() {
    emit('close');
}

onMounted(() => {
    // Generar nombre sugerido basado en el tipo y cantidad existente
    const existingCount = monitoringStore.resources.filter(r => r.type === props.resourceType).length;
    const typeNames = {
        CONSULTORIO: 'Consultorio',
        TRATAMIENTO: 'Sala Tratamiento',
        ESTANCIA: 'Cama',
        TRIAJE: 'Camilla'
    };
    formData.value.name = `${typeNames[props.resourceType]} ${existingCount + 1}`;
});
</script>

<style scoped>
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.6);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    backdrop-filter: blur(4px);
}

.modal-content {
    background: white;
    border-radius: 16px;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    animation: slideIn 0.3s ease;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 24px;
    border-bottom: 1px solid #e0e0e0;
}

.modal-header h2 {
    margin: 0;
    font-size: 24px;
    font-weight: 700;
    color: #333;
}

.btn-close {
    background: none;
    border: none;
    font-size: 24px;
    color: #666;
    cursor: pointer;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    transition: all 0.3s ease;
}

.btn-close:hover {
    background: #f5f5f5;
    color: #333;
}

.modal-body {
    padding: 24px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #333;
    font-size: 14px;
}

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 14px;
    transition: all 0.3s ease;
    font-family: inherit;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-group select:disabled {
    background: #f5f5f5;
    cursor: not-allowed;
}

.form-group small {
    display: block;
    margin-top: 4px;
    font-size: 12px;
    color: #666;
}

.modal-actions {
    display: flex;
    gap: 12px;
    margin-top: 24px;
}

.modal-actions button {
    flex: 1;
    padding: 12px 24px;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-cancel {
    background: #f5f5f5;
    color: #666;
}

.btn-cancel:hover {
    background: #e0e0e0;
}

.btn-submit {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.btn-submit:hover:not(:disabled) {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.btn-submit:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}
</style>
