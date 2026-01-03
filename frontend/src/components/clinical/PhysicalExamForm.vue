<template>
    <div class="physical-exam-form">
        <!-- Alergias Section -->
        <section class="form-section glass-card">
            <div class="section-header">
                <div class="title-with-icon">
                    <div class="icon-box red">
                        <i class="fas fa-hand-dots"></i>
                    </div>
                    <h3 class="section-title">Alergias y Sensibilidades</h3>
                </div>
            </div>

            <div class="allergy-form-container">
                <div class="allergy-input-grid">
                    <div class="form-group">
                        <label>Sustancia / Elemento</label>
                        <div class="input-with-icon">
                            <i class="fas fa-search"></i>
                            <input v-model="newAllergy.substance" placeholder="Ej: Penicilina, Polen..." />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Tipo</label>
                        <select v-model="newAllergy.type">
                            <option value="MEDICAMENTO">Medicamento</option>
                            <option value="ALIMENTO">Alimento</option>
                            <option value="AMBIENTAL">Ambiental</option>
                            <option value="OTRO">Otro</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Severidad</label>
                        <div class="severity-selector">
                            <button 
                                type="button"
                                v-for="s in ['LEVE', 'MODERADO', 'SEVERO']" 
                                :key="s"
                                @click="newAllergy.severity = s"
                                :class="['severity-btn', s.toLowerCase(), { active: newAllergy.severity === s }]"
                            >
                                {{ s }}
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="form-group full-width">
                    <label>Comentarios y Reacciones</label>
                    <textarea v-model="newAllergy.comments" placeholder="Describa la reacción, detonante o cuidados especiales..."></textarea>
                </div>

                <div class="action-row">
                    <button type="button" @click="addAllergy" class="btn-primary-outline">
                        <i class="fas fa-plus"></i>
                        Registrar Alergia
                    </button>
                </div>
            </div>

            <div class="allergy-list-container">
                <div v-if="allergies.length > 0" class="allergy-cards-grid">
                    <div v-for="allergy in allergies" :key="allergy.id" class="allergy-mini-card" :class="{ inactive: !allergy.isActive }">
                        <div class="allergy-card-header">
                            <span class="allergy-substance">{{ allergy.substance }}</span>
                            <span :class="['severity-badge', allergy.severity.toLowerCase()]">{{ allergy.severity }}</span>
                        </div>
                        <p class="allergy-comment">{{ allergy.comments || 'Sin comentarios' }}</p>
                        <div class="allergy-card-footer">
                            <span class="allergy-date">{{ formatDate(allergy.createdAt) }}</span>
                            <label class="switch">
                                <input type="checkbox" :checked="allergy.isActive" @change="toggleAllergy(allergy)">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div v-else class="empty-list-placeholder">
                    <i class="fas fa-shield-virus"></i>
                    <p>No se han registrado alergias para este paciente</p>
                </div>
            </div>
        </section>

        <!-- Funciones Vitales Section -->
        <section class="form-section glass-card">
            <div class="section-header">
                <div class="title-with-icon">
                    <div class="icon-box blue">
                        <i class="fas fa-heart-pulse"></i>
                    </div>
                    <h3 class="section-title">Funciones Vitales (Triaje)</h3>
                </div>
            </div>

            <div class="vitals-layout">
                <div class="vitals-inputs-panel">
                    <div class="vitals-grid">
                        <div class="vital-input-card">
                            <div class="vital-label">
                                <i class="fas fa-thermometer-half"></i>
                                <span>Temperatura</span>
                            </div>
                            <div class="input-group">
                                <input type="number" step="0.1" v-model="exam.temperature" placeholder="0.0" />
                                <span class="unit">°C</span>
                            </div>
                        </div>

                        <div class="vital-input-card">
                            <div class="vital-label">
                                <i class="fas fa-weight-hanging"></i>
                                <span>Peso</span>
                            </div>
                            <div class="input-group">
                                <input type="number" step="0.1" v-model="exam.weight" @input="calculateIMC" placeholder="0.0" />
                                <span class="unit">Kg</span>
                            </div>
                        </div>

                        <div class="vital-input-card">
                            <div class="vital-label">
                                <i class="fas fa-arrows-up-down"></i>
                                <span>Talla</span>
                            </div>
                            <div class="input-group">
                                <input type="number" v-model="exam.height" @input="calculateIMC" placeholder="0" />
                                <span class="unit">cm</span>
                            </div>
                        </div>

                        <div class="vital-input-card waist-card">
                            <div class="vital-label">
                                <i class="fas fa-ruler-horizontal"></i>
                                <span>Perímetro Abdominal (Cintura)</span>
                            </div>
                            <div class="input-group">
                                <input type="number" v-model="exam.waist" placeholder="0" />
                                <span class="unit">cm</span>
                            </div>
                        </div>

                        <div class="vital-input-card">
                            <div class="vital-label">
                                <i class="fas fa-wind"></i>
                                <span>Respiración</span>
                            </div>
                            <div class="input-group">
                                <input type="number" v-model="exam.respiration" placeholder="0" />
                                <span class="unit">rpm</span>
                            </div>
                        </div>

                        <div class="vital-input-card">
                            <div class="vital-label">
                                <i class="fas fa-heartbeat"></i>
                                <span>Pulso</span>
                            </div>
                            <div class="input-group">
                                <input type="number" v-model="exam.pulse" placeholder="0" />
                                <span class="unit">bpm</span>
                            </div>
                        </div>
                    </div>

                    <div class="vital-input-card bp-card">
                        <div class="vital-label">
                            <i class="fas fa-gauge-high"></i>
                            <span>Presión Arterial</span>
                        </div>
                        <div class="bp-inputs-row">
                            <input type="number" v-model="exam.systolic" placeholder="Sis" />
                            <span class="separator">/</span>
                            <input type="number" v-model="exam.diastolic" placeholder="Dia" />
                            <span class="unit">mmHg</span>
                        </div>
                    </div>
                </div>

                <div class="vitals-analysis-panel">
                    <div class="analysis-card">
                        <h4 class="analysis-title">Análisis Nutricional e IMC</h4>
                        
                        <div class="metrics-grid">
                            <div class="metric-box">
                                <span class="metric-label">Peso Ideal</span>
                                <span class="metric-value">{{ idealWeight }} <small>Kg</small></span>
                            </div>
                            <div class="metric-box">
                                <span class="metric-label">% Sobre Peso</span>
                                <span class="metric-value" :class="{ warning: parseFloat(overIdealWeightPercent) > 10 }">
                                    {{ overIdealWeightPercent }}<small>%</small>
                                </span>
                            </div>
                        </div>

                        <div class="imc-bsa-display-container">
                            <div class="metric-circle-group">
                                <div class="metric-wrapper">
                                    <div class="imc-circle" :class="imcClass">
                                        <span class="imc-number">{{ exam.imc || '0.0' }}</span>
                                    </div>
                                    <span class="metric-label-bottom">IMC</span>
                                </div>
                            </div>
                            
                            <div class="metric-circle-group">
                                <div class="metric-wrapper">
                                    <div class="bsa-circle">
                                        <span class="bsa-number">{{ exam.bodySurfaceArea || '0.00' }}</span>
                                        <span class="bsa-unit">m²</span>
                                    </div>
                                    <span class="metric-label-bottom">Superficie</span>
                                </div>
                            </div>
                        </div>

                        <div v-if="imcClassification" class="imc-classification-row">
                            <span class="classification-label">{{ imcClassification }}</span>
                        </div>

                        <div class="risk-indicator" :class="riskClass">
                            <div class="risk-header">
                                <span>Nivel de Riesgo</span>
                                <span class="risk-tag">{{ exam.risk || 'No calculado' }}</span>
                            </div>
                            <div class="risk-bar">
                                <div class="risk-progress"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="form-actions-footer">
            <button type="button" @click="saveExam" class="btn-save-premium" :disabled="loading">
                <div v-if="loading" class="spinner"></div>
                <i v-else class="fas fa-cloud-upload-alt"></i>
                {{ loading ? 'Sincronizando...' : 'Finalizar y Guardar Registro' }}
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import api from '../../services/api';
import { useToast } from 'vue-toastification';

const props = defineProps<{
    patientId: number;
    appointmentId: number;
    staffId: number;
    readOnly?: boolean;
}>();

const toast = useToast();
const loading = ref(false);

const exam = ref<any>({
    temperature: null,
    pulse: null,
    respiration: null,
    height: null,
    weight: null,
    systolic: null,
    diastolic: null,
    imc: null,
    bodySurfaceArea: null,
    waist: null,
    risk: ''
});

const allergies = ref<any[]>([]);
const newAllergy = ref({
    substance: '',
    type: 'MEDICAMENTO',
    severity: 'MODERADO',
    comments: ''
});

const idealWeight = computed(() => {
    if (!exam.value.height) return '---';
    const heightM = exam.value.height / 100;
    return (22 * (heightM * heightM)).toFixed(1);
});

const overIdealWeightPercent = computed(() => {
    if (!exam.value.weight || !idealWeight.value || idealWeight.value === '---') return '0.0';
    const ideal = parseFloat(idealWeight.value);
    const percent = ((exam.value.weight - ideal) / ideal) * 100;
    return percent.toFixed(1);
});

const imcClassification = computed(() => {
    const imc = parseFloat(exam.value.imc);
    if (!imc) return '';
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    if (imc < 35) return 'Obesidad I';
    if (imc < 40) return 'Obesidad II';
    return 'Obesidad III';
});

const imcClass = computed(() => {
    const imc = parseFloat(exam.value.imc);
    if (!imc) return '';
    if (imc < 18.5) return 'underweight';
    if (imc < 25) return 'normal';
    if (imc < 30) return 'overweight';
    return 'obese';
});

const riskClass = computed(() => {
    if (exam.value.risk === 'Alto') return 'risk-high';
    if (exam.value.risk === 'Medio') return 'risk-medium';
    if (exam.value.risk === 'Bajo') return 'risk-low';
    return '';
});

function calculateIMC() {
    if (exam.value.height && exam.value.weight) {
        const heightM = exam.value.height / 100;
        exam.value.imc = (exam.value.weight / (heightM * heightM)).toFixed(1);
        
        // Calculate Body Surface Area using Mosteller formula
        // BSA (m²) = √(height(cm) × weight(kg) / 3600)
        exam.value.bodySurfaceArea = Math.sqrt((exam.value.height * exam.value.weight) / 3600).toFixed(2);
        
        // Risk logic
        if (parseFloat(exam.value.imc) >= 30 || exam.value.waist > 102) {
            exam.value.risk = 'Alto';
        } else if (parseFloat(exam.value.imc) >= 25 || exam.value.waist > 88) {
            exam.value.risk = 'Medio';
        } else {
            exam.value.risk = 'Bajo';
        }
    }
}

async function loadData() {
    if (!props.appointmentId) return;
    try {
        console.log(`🔍 Loading physical exam for appointment ${props.appointmentId}...`);
        const [examRes, allergyRes] = await Promise.all([
            api.get(`/physical-exam/appointment/${props.appointmentId}`),
            api.get(`/physical-exam/patient/${props.patientId}/allergies`)
        ]);
        
        if (examRes.data) {
            console.log('✅ Physical exam data found:', examRes.data);
            exam.value = examRes.data;
        } else {
            console.log('ℹ️ No physical exam data found for this appointment.');
            // Reset if no data
            exam.value = {
                temperature: null, pulse: null, respiration: null,
                height: null, weight: null, systolic: null, diastolic: null,
                imc: null, bodySurfaceArea: null, waist: null, risk: ''
            };
        }
        allergies.value = Array.isArray(allergyRes.data) ? allergyRes.data : [];
    } catch (error) {
        console.error('❌ Error loading physical exam data:', error);
    }
}

async function addAllergy() {
    if (!newAllergy.value.substance) {
        toast.warning('Ingrese la sustancia de la alergia');
        return;
    }
    try {
        const res = await api.post('/physical-exam/allergies', {
            ...newAllergy.value,
            patientId: props.patientId
        });
        allergies.value.unshift(res.data);
        newAllergy.value = {
            substance: '',
            type: 'MEDICAMENTO',
            severity: 'MODERADO',
            comments: ''
        };
        toast.success('Alergia registrada');
    } catch (error) {
        console.error('Error adding allergy:', error);
        toast.error('Error al registrar alergia');
    }
}

async function toggleAllergy(allergy: any) {
    try {
        await api.delete(`/physical-exam/allergies/${allergy.id}`);
        allergy.isActive = !allergy.isActive;
        toast.info('Estado actualizado');
    } catch (error) {
        toast.error('Error al actualizar');
    }
}

async function saveExam() {
    loading.value = true;
    try {
        // Clean data to send only what's needed
        const dataToSend = {
            temperature: exam.value.temperature,
            pulse: exam.value.pulse,
            respiration: exam.value.respiration,
            height: exam.value.height,
            weight: exam.value.weight,
            systolic: exam.value.systolic,
            diastolic: exam.value.diastolic,
            imc: exam.value.imc,
            bodySurfaceArea: exam.value.bodySurfaceArea,
            waist: exam.value.waist,
            risk: exam.value.risk,
            patientId: props.patientId,
            appointmentId: props.appointmentId,
            staffId: props.staffId
        };

        console.log('📤 Saving Physical Exam Data:', dataToSend);

        if (!dataToSend.staffId) {
            console.error('❌ Missing staffId. Cannot save exam.');
            toast.error('Error: No se ha identificado al personal médico (staffId missing).');
            loading.value = false;
            return;
        }

        await api.post('/physical-exam', dataToSend);
        toast.success('Registro clínico guardado');
    } catch (error: any) {
        console.error('❌ Error saving exam:', error);
        if (error.response) {
            console.error('Server response:', error.response.data);
            toast.error(`Error del servidor: ${error.response.data.error || 'Error interno'}`);
        } else {
            toast.error('Error al sincronizar datos');
        }
    } finally {
        loading.value = false;
    }
}

function formatDate(date: string) {
    return new Date(date).toLocaleDateString('es-ES', { day: '2-digit', month: 'short', year: 'numeric' });
}

onMounted(loadData);
watch(() => props.appointmentId, loadData);

defineExpose({
    saveExam
});
</script>

<style scoped>
.physical-exam-form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 0.25rem;
    background: transparent;
    font-family: 'Inter', sans-serif;
}

.glass-card {
    background: white;
    border-radius: 16px;
    padding: 1rem;
    border: 1px solid rgba(34, 54, 117, 0.08);
    box-shadow: 0 8px 20px rgba(34, 54, 117, 0.03);
}

.section-header {
    margin-bottom: 1rem;
}

.title-with-icon {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.icon-box {
    width: 32px;
    height: 32px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
}

.icon-box.red { background: #fee2e2; color: #ef4444; }
.icon-box.blue { background: #e0e7ff; color: #5371C4; }

.section-title {
    font-size: 1.1rem;
    color: #223675;
    font-weight: 800;
    margin: 0;
}

/* Allergy Styles */
.allergy-form-container {
    background: #f8fafc;
    padding: 1rem;
    border-radius: 12px;
    margin-bottom: 1rem;
}

.allergy-input-grid {
    display: grid;
    grid-template-columns: 2fr 1fr 1.5fr;
    gap: 1rem;
    margin-bottom: 0.75rem;
}

.form-group label {
    display: block;
    font-size: 0.7rem;
    font-weight: 700;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: 0.4rem;
}

.input-with-icon {
    position: relative;
    display: flex;
    align-items: center;
}

.input-with-icon i {
    position: absolute;
    left: 12px;
    color: #94a3b8;
}

.input-with-icon input {
    padding-left: 36px;
}

input, select, textarea {
    width: 100%;
    padding: 0.6rem 0.8rem;
    border: 1.5px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.9rem;
    color: #223675;
    background: white;
    transition: all 0.2s;
}

input:focus, select:focus, textarea:focus {
    outline: none;
    border-color: #5371C4;
    box-shadow: 0 0 0 3px rgba(83, 113, 196, 0.1);
}

.severity-selector {
    display: flex;
    gap: 0.5rem;
}

.severity-btn {
    flex: 1;
    padding: 0.5rem;
    border: 1.5px solid #e2e8f0;
    border-radius: 6px;
    font-size: 0.7rem;
    font-weight: 700;
    cursor: pointer;
    background: white;
    transition: all 0.2s;
}

.severity-btn.leve.active { background: #dcfce7; color: #166534; border-color: #166534; }
.severity-btn.moderado.active { background: #fef9c3; color: #854d0e; border-color: #854d0e; }
.severity-btn.severo.active { background: #fee2e2; color: #991b1b; border-color: #991b1b; }

.btn-primary-outline {
    background: white;
    color: #5371C4;
    border: 1.5px solid #5371C4;
    padding: 0.6rem 1.25rem;
    border-radius: 8px;
    font-weight: 700;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.2s;
    font-size: 0.85rem;
}

.btn-primary-outline:hover {
    background: #5371C4;
    color: white;
}

.allergy-list-container {
    max-height: 150px;
    overflow-y: auto;
    padding-right: 0.5rem;
}

.allergy-cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 0.75rem;
}

.allergy-mini-card {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 0.75rem;
    transition: all 0.2s;
}

.allergy-mini-card.inactive {
    opacity: 0.6;
    filter: grayscale(1);
}

.allergy-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
}

.allergy-substance {
    font-weight: 800;
    color: #223675;
}

.severity-badge {
    font-size: 0.65rem;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 99px;
    text-transform: uppercase;
}

.severity-badge.leve { background: #dcfce7; color: #166534; }
.severity-badge.moderado { background: #fef9c3; color: #854d0e; }
.severity-badge.severo { background: #fee2e2; color: #991b1b; }

.allergy-comment {
    font-size: 0.85rem;
    color: #64748b;
    margin: 0.5rem 0;
    line-height: 1.4;
}

.allergy-card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 0.75rem;
    padding-top: 0.75rem;
    border-top: 1px dashed #e2e8f0;
}

.allergy-date {
    font-size: 0.75rem;
    color: #94a3b8;
}

/* Vitals Layout */
.vitals-layout {
    display: grid;
    grid-template-columns: 1fr 340px;
    gap: 1.5rem;
}

.vitals-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 1rem;
}

.vital-input-card {
    background: #f8fafc;
    padding: 0.75rem;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
}

.vital-label {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.7rem;
    font-weight: 700;
    color: #64748b;
    margin-bottom: 0.5rem;
}

.vital-label i {
    color: #5371C4;
}

.input-group {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.input-group input {
    background: white;
    font-size: 1.1rem;
    font-weight: 800;
    padding: 0.4rem;
    text-align: right;
}

.unit {
    font-size: 0.85rem;
    font-weight: 700;
    color: #94a3b8;
    min-width: 35px;
}

.bp-inputs-row {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.bp-inputs-row input {
    width: 80px;
    text-align: center;
    font-size: 1rem;
    font-weight: 800;
}

.separator {
    font-size: 1.5rem;
    color: #cbd5e1;
    font-weight: 300;
}

.bp-card {
    margin-top: 1rem;
}

/* Analysis Panel */
.analysis-card {
    background: #223675;
    border-radius: 20px;
    padding: 1.25rem;
    color: white;
    height: 100%;
    box-shadow: 0 15px 30px rgba(34, 54, 117, 0.15);
}

.analysis-title {
    font-size: 1rem;
    font-weight: 700;
    margin: 0 0 1.5rem 0;
    opacity: 0.9;
}

.metrics-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.75rem;
    margin-bottom: 1.25rem;
}

.metric-box {
    background: rgba(255,255,255,0.05);
    padding: 0.75rem;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
}

.metric-label {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    opacity: 0.6;
    margin-bottom: 0.25rem;
}

.metric-value {
    font-size: 1.25rem;
    font-weight: 800;
}

.metric-value small {
    font-size: 0.8rem;
    font-weight: 400;
    opacity: 0.5;
}

.imc-bsa-display-container {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
    background: rgba(255,255,255,0.03);
    padding: 1.25rem;
    border-radius: 16px;
}

.metric-circle-group {
    display: flex;
    align-items: center;
    gap: 1rem;
    flex: 1;
}

.metric-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.5rem;
}

.imc-circle, .bsa-circle {
    width: 90px;
    height: 90px;
    border-radius: 50%;
    border: 5px solid rgba(255,255,255,0.1);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    transition: all 0.5s;
    flex-shrink: 0;
}

.imc-circle.normal { border-color: #10b981; color: #10b981; }
.imc-circle.overweight { border-color: #f59e0b; color: #f59e0b; }
.imc-circle.obese { border-color: #ef4444; color: #ef4444; }

.bsa-circle { 
    border-color: #5371C4; 
    color: #5371C4; 
}

.imc-number, .bsa-number { 
    font-size: 1.75rem; 
    font-weight: 900; 
    line-height: 1; 
}

.bsa-unit {
    font-size: 0.7rem;
    font-weight: 800;
    margin-top: 0.25rem;
}

.metric-label-bottom {
    font-size: 0.75rem;
    font-weight: 800;
    color: white;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.imc-status, .bsa-status {
    display: block;
    font-size: 1rem;
    font-weight: 800;
    margin-bottom: 0.25rem;
}

.imc-desc, .bsa-desc {
    font-size: 0.75rem;
    opacity: 0.5;
    margin: 0;
}

.imc-classification-row {
    text-align: center;
    padding: 0.75rem 0;
    margin-top: 0.5rem;
    border-top: 1px solid rgba(255,255,255,0.1);
}

.classification-label {
    font-size: 1.1rem;
    font-weight: 800;
    color: white;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}


.risk-indicator {
    padding-top: 1rem;
    border-top: 1px solid rgba(255,255,255,0.1);
}

.risk-header {
    display: flex;
    justify-content: space-between;
    font-size: 0.85rem;
    margin-bottom: 0.75rem;
}

.risk-tag {
    font-weight: 800;
    text-transform: uppercase;
}

.risk-bar {
    height: 8px;
    background: rgba(255,255,255,0.1);
    border-radius: 4px;
    overflow: hidden;
}

.risk-progress {
    height: 100%;
    width: 0;
    transition: width 0.5s ease;
}

.risk-low .risk-progress { width: 33%; background: #10b981; }
.risk-medium .risk-progress { width: 66%; background: #f59e0b; }
.risk-high .risk-progress { width: 100%; background: #ef4444; }

/* Footer Actions */
.form-actions-footer {
    display: flex;
    justify-content: flex-end;
    margin-top: 1rem;
}

.btn-save-premium {
    background: #5371C4;
    color: white;
    border: none;
    padding: 1rem 2rem;
    border-radius: 12px;
    font-weight: 800;
    font-size: 0.95rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    box-shadow: 0 8px 20px rgba(83, 113, 196, 0.3);
    transition: all 0.3s;
}

.btn-save-premium:hover:not(:disabled) {
    background: #223675;
    transform: translateY(-3px);
    box-shadow: 0 15px 30px rgba(34, 54, 117, 0.2);
}

.btn-save-premium:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

/* Switch Styles */
.switch {
  position: relative;
  display: inline-block;
  width: 34px;
  height: 20px;
}

.switch input { opacity: 0; width: 0; height: 0; }

.slider {
  position: absolute;
  cursor: pointer;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: #ccc;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 14px; width: 14px;
  left: 3px; bottom: 3px;
  background-color: white;
  transition: .4s;
}

input:checked + .slider { background-color: #10b981; }
input:checked + .slider:before { transform: translateX(14px); }
.slider.round { border-radius: 34px; }
.slider.round:before { border-radius: 50%; }

@media (max-width: 1100px) {
    .vitals-layout {
        grid-template-columns: 1fr;
    }
    
    .allergy-input-grid {
        grid-template-columns: 1fr;
    }
}
</style>

