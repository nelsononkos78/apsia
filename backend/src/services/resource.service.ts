import { Resource, ResourceStatus, ResourceType, InhabilitadoReason } from '../models/resource.model';
import { Patient } from '../models/patient.model';
import { Doctor } from '../models/doctor.model';
import { DoctorSchedule } from '../models/doctor-schedule.model';
import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { WaitingRoom, WaitingRoomStatus } from '../models/waiting-room.model';
import { Op } from 'sequelize';
import { getWebSocketService } from './websocket.service';

export class ResourceService {
    /**
     * Obtener todos los recursos
     */
    async getAllResources(): Promise<Resource[]> {
        return await Resource.findAll({
            include: [
                { model: Patient, as: 'currentPatient' },
                { model: Appointment, as: 'currentAppointment' },
                {
                    model: Doctor,
                    as: 'doctor',
                    include: [{ model: DoctorSchedule, as: 'schedules' }]
                }
            ],
            order: [['type', 'ASC'], ['name', 'ASC']]
        });
    }

    /**
     * Obtener recursos por tipo
     */
    async getResourcesByType(type: ResourceType): Promise<Resource[]> {
        return await Resource.findAll({
            where: { type },
            include: [
                { model: Patient, as: 'currentPatient' },
                { model: Appointment, as: 'currentAppointment' },
                {
                    model: Doctor,
                    as: 'doctor',
                    include: [{ model: DoctorSchedule, as: 'schedules' }]
                }
            ],
            order: [['name', 'ASC']]
        });
    }

    /**
     * Obtener un recurso por ID
     */
    async getResourceById(id: number): Promise<Resource | null> {
        return await Resource.findByPk(id, {
            include: [
                { model: Patient, as: 'currentPatient' },
                { model: Appointment, as: 'currentAppointment' },
                {
                    model: Doctor,
                    as: 'doctor',
                    include: [{ model: DoctorSchedule, as: 'schedules' }]
                }
            ]
        });
    }

    /**
     * Crear un nuevo recurso
     */
    async createResource(data: {
        name: string;
        type: ResourceType;
        capacity?: number;
        notes?: string;
    }): Promise<Resource> {
        const newResource = await Resource.create({
            name: data.name,
            type: data.type,
            capacity: data.capacity || 1,
            notes: data.notes,
            status: ResourceStatus.DISPONIBLE,
            currentOccupancy: 0
        });

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            wsService.emitResourceCreated(newResource.toJSON());
        } catch (error) {
            console.error('WebSocket not initialized:', error);
        }

        return newResource;
    }

    /**
     * Actualizar estado de un recurso
     */
    async updateResourceStatus(
        id: number,
        status: ResourceStatus,
        reason?: InhabilitadoReason
    ): Promise<Resource> {
        const resource = await Resource.findByPk(id);
        if (!resource) {
            throw new Error('Recurso no encontrado');
        }

        resource.status = status;
        resource.statusReason = status === ResourceStatus.INHABILITADO ? reason || null : null;

        await resource.save();

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting resource update via WebSocket:', { id: resource.id, name: resource.name, status: resource.status });

            // Reload with associations for complete data
            const resourceWithAssociations = await this.getResourceById(id);
            if (resourceWithAssociations) {
                wsService.emitResourceUpdate(resourceWithAssociations.toJSON());
            }
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }

        return resource;
    }

    /**
     * Asignar paciente a un recurso
     */
    async assignPatientToResource(resourceId: number, patientId: number): Promise<Resource> {
        const resource = await Resource.findByPk(resourceId);
        if (!resource) {
            throw new Error('Recurso no encontrado');
        }

        if (resource.status !== ResourceStatus.DISPONIBLE) {
            throw new Error('Recurso no disponible');
        }

        if (resource.currentOccupancy >= resource.capacity) {
            throw new Error('Recurso a capacidad máxima');
        }

        resource.currentPatientId = patientId;
        resource.currentOccupancy += 1;
        resource.status = resource.currentOccupancy >= resource.capacity
            ? ResourceStatus.OCUPADO
            : ResourceStatus.DISPONIBLE;

        await resource.save();

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting resource update via WebSocket (assign):', { id: resource.id, name: resource.name, status: resource.status });

            // Reload with associations for complete data
            const resourceWithAssociations = await this.getResourceById(resourceId);
            if (resourceWithAssociations) {
                wsService.emitResourceUpdate(resourceWithAssociations.toJSON());
            }
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }

        return resource;
    }

    /**
     * Liberar recurso
     */
    async releaseResource(resourceId: number): Promise<Resource> {
        const resource = await Resource.findByPk(resourceId);
        if (!resource) {
            throw new Error('Recurso no encontrado');
        }

        resource.currentPatientId = null;
        resource.currentOccupancy = 0;
        resource.status = ResourceStatus.DISPONIBLE;

        // If it's a Triaje resource, mark the appointment as triajeCompleted
        // and return the patient to the waiting room
        if (resource.type === ResourceType.TRIAJE && resource.currentAppointmentId) {
            await Appointment.update(
                {
                    triajeCompleted: true,
                    resourceId: null // Liberar el recurso de la cita
                },
                { where: { id: resource.currentAppointmentId } }
            );

            // Emit appointment update
            try {
                const wsService = getWebSocketService();
                const updatedAppt = await Appointment.findByPk(resource.currentAppointmentId);
                if (updatedAppt) {
                    wsService.emitAppointmentUpdate(updatedAppt.toJSON());
                }
            } catch (e) {
                console.error('Error emitting appointment update:', e);
            }

            // Return to waiting room
            const waitingRecord = await WaitingRoom.findOne({
                where: { appointmentId: resource.currentAppointmentId }
            });

            if (waitingRecord) {
                waitingRecord.status = WaitingRoomStatus.ESPERANDO;
                await waitingRecord.save();

                // Emit WebSocket event for waiting room update
                this.emitWaitingRoomUpdate(waitingRecord.id);
            }
        } else if (resource.type === ResourceType.CONSULTORIO && resource.currentAppointmentId) {
            // If it's a Consultorio, mark as ATENDIDO in waiting room
            const waitingRecord = await WaitingRoom.findOne({
                where: { appointmentId: resource.currentAppointmentId }
            });

            if (waitingRecord) {
                waitingRecord.status = WaitingRoomStatus.ATENDIDO;
                await waitingRecord.save();

                // Emit WebSocket event for waiting room update
                this.emitWaitingRoomUpdate(waitingRecord.id);
            }

            // Also mark appointment as COMPLETED if it was IN_PROGRESS
            await Appointment.update(
                {
                    status: AppointmentStatus.COMPLETED,
                    resourceId: null // Liberar el recurso de la cita
                },
                { where: { id: resource.currentAppointmentId, status: AppointmentStatus.IN_PROGRESS } }
            );

            // Emit appointment update
            try {
                const wsService = getWebSocketService();
                const updatedAppt = await Appointment.findByPk(resource.currentAppointmentId);
                if (updatedAppt) {
                    wsService.emitAppointmentUpdate(updatedAppt.toJSON());
                }
            } catch (e) {
                console.error('Error emitting appointment update:', e);
            }
        } else if (resource.currentAppointmentId) {
            // For any other resource type, just clear the resourceId from appointment
            await Appointment.update(
                { resourceId: null },
                { where: { id: resource.currentAppointmentId } }
            );
        }

        resource.currentAppointmentId = null;
        await resource.save();

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting resource update via WebSocket (release):', { id: resource.id, name: resource.name, status: resource.status });

            // Reload with associations for complete data
            const resourceWithAssociations = await this.getResourceById(resourceId);
            if (resourceWithAssociations) {
                wsService.emitResourceUpdate(resourceWithAssociations.toJSON());
            }
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }

        return resource;
    }

    /**
     * Obtener recursos disponibles por tipo
     */
    async getAvailableResourcesByType(type: ResourceType): Promise<Resource[]> {
        return await Resource.findAll({
            where: {
                type,
                status: ResourceStatus.DISPONIBLE,
                currentOccupancy: {
                    [Op.lt]: Resource.sequelize!.col('capacity')
                }
            },
            order: [['name', 'ASC']]
        });
    }

    /**
     * Obtener estadísticas de recursos
     */
    async getResourceStatistics() {
        const resources = await this.getAllResources();

        const stats = {
            total: resources.length,
            disponibles: resources.filter(r => r.status === ResourceStatus.DISPONIBLE).length,
            ocupados: resources.filter(r => r.status === ResourceStatus.OCUPADO).length,
            inhabilitados: resources.filter(r => r.status === ResourceStatus.INHABILITADO).length,
            byType: {
                CONSULTORIO: {
                    total: 0,
                    disponibles: 0,
                    ocupados: 0,
                    inhabilitados: 0
                },
                TRATAMIENTO: {
                    total: 0,
                    disponibles: 0,
                    ocupados: 0,
                    inhabilitados: 0
                },
                ESTANCIA: {
                    total: 0,
                    disponibles: 0,
                    ocupados: 0,
                    inhabilitados: 0
                },
                TRIAJE: {
                    total: 0,
                    disponibles: 0,
                    ocupados: 0,
                    inhabilitados: 0
                }
            }
        };

        resources.forEach(resource => {
            const typeStats = stats.byType[resource.type];
            typeStats.total++;

            if (resource.status === ResourceStatus.DISPONIBLE) typeStats.disponibles++;
            else if (resource.status === ResourceStatus.OCUPADO) typeStats.ocupados++;
            else if (resource.status === ResourceStatus.INHABILITADO) typeStats.inhabilitados++;
        });

        return stats;
    }

    /**
     * Helper para emitir actualizaciones de sala de espera
     */
    private async emitWaitingRoomUpdate(id: number) {
        try {
            const wsService = getWebSocketService();
            const recordWithData = await WaitingRoom.findByPk(id, {
                include: [
                    { model: Patient },
                    {
                        model: Appointment,
                        include: ['serviceType', 'doctor']
                    }
                ]
            });
            if (recordWithData) {
                wsService.emitWaitingRoomUpdate(recordWithData.toJSON());
            }
        } catch (error) {
            console.error('❌ Error emitting waiting room update:', error);
        }
    }
}
