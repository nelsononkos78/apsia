import { sequelize } from '../config/database';
import { ServiceType } from '../models/service-type.model';
import { ServiceTypeEnum } from '../models/appointment.model';

export const seedServiceTypes = async () => {
    const serviceTypes = [
        { name: 'Consulta Nueva', code: ServiceTypeEnum.CONSULTATION_NEW, description: 'Primera visita con un especialista.', icon: '🏥', showPatient: true },
        { name: 'Consulta de Seguimiento', code: ServiceTypeEnum.CONSULTATION_FOLLOWUP, description: 'Revisión de progreso y resultados.', icon: '🔄', showPatient: true },
        { name: 'Sesión de Quimioterapia', code: ServiceTypeEnum.CHEMOTHERAPY, description: 'Administración de esquemas quimioterapéuticos', icon: '💉', showPatient: true },
        { name: 'Procedimiento Oncológico', code: ServiceTypeEnum.PROCEDURE, description: 'Biopsias, paracentesis, etc. (Requiere Orden)', icon: '💉', showPatient: true },
        { name: 'Examen de Laboratorio Oncológico', code: ServiceTypeEnum.LABORATORY_ONCO, description: 'Análisis clínicos especializados.', icon: '🧪', showPatient: true },
        { name: 'Ecografía Oncológica', code: ServiceTypeEnum.ULTRASOUND_ONCO, description: 'Estudios de imagen.', icon: '🔍', showPatient: true },
        { name: 'Recuperación Ambulatoria', code: ServiceTypeEnum.RECOVERY, description: 'Reposo corto, monitoreo, hidratación, analgesia post procedimiento', icon: '🛌', showPatient: true },
        { name: 'Emergencia Oncológica', code: ServiceTypeEnum.EMERGENCY_ONCO, description: 'Emergencia ante urgencias oncológicas', icon: '🚨', showPatient: true },
        { name: 'Servicios de Salud General (SSG)', code: ServiceTypeEnum.GENERAL_HEALTH, description: 'Vitaminas, inyecciones, hidrataciones, ecografías y laboratorio general', icon: '🩺', showPatient: true }
    ];

    for (const st of serviceTypes) {
        await ServiceType.upsert(st);
    }
    console.log('Service types seeded.');
};
