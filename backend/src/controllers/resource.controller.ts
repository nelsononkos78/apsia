import { Request, Response } from 'express';
import { ResourceService } from '../services/resource.service';
import { Resource, ResourceType, ResourceStatus, InhabilitadoReason } from '../models/resource.model';
import { WaitingRoom, WaitingRoomStatus } from '../models/waiting-room.model';
import { Appointment } from '../models/appointment.model';
import { Patient } from '../models/patient.model';
import { Queue } from '../models/queue.model';
import { ServiceType } from '../models/service-type.model';
import { Op } from 'sequelize';
import { getWebSocketService } from '../services/websocket.service';
import { getTvService } from '../services/tv.service';

const resourceService = new ResourceService();

export class ResourceController {
    /**
     * GET /api/resources
     * Obtener todos los recursos
     */
    async getAllResources(req: Request, res: Response) {
        try {
            const resources = await resourceService.getAllResources();
            res.json(resources);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/resources/type/:type
     * Obtener recursos por tipo
     */
    async getResourcesByType(req: Request, res: Response) {
        try {
            const { type } = req.params;

            if (!Object.values(ResourceType).includes(type as ResourceType)) {
                return res.status(400).json({ error: 'Tipo de recurso inválido' });
            }

            const resources = await resourceService.getResourcesByType(type as ResourceType);
            res.json(resources);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/resources/:id
     * Obtener un recurso por ID
     */
    async getResourceById(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const resource = await resourceService.getResourceById(parseInt(id));

            if (!resource) {
                return res.status(404).json({ error: 'Recurso no encontrado' });
            }

            res.json(resource);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/resources
     * Crear un nuevo recurso
     */
    async createResource(req: Request, res: Response) {
        try {
            const { name, type, capacity, notes } = req.body;

            if (!name || !type) {
                return res.status(400).json({ error: 'Nombre y tipo son requeridos' });
            }

            if (!Object.values(ResourceType).includes(type)) {
                return res.status(400).json({ error: 'Tipo de recurso inválido' });
            }

            const resource = await resourceService.createResource({
                name,
                type,
                capacity,
                notes
            });

            res.status(201).json(resource);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * PUT /api/resources/:id/status
     * Actualizar estado de un recurso
     */
    async updateResourceStatus(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const { status, reason } = req.body;

            if (!status) {
                return res.status(400).json({ error: 'Estado es requerido' });
            }

            if (!Object.values(ResourceStatus).includes(status)) {
                return res.status(400).json({ error: 'Estado inválido' });
            }

            if (status === ResourceStatus.INHABILITADO && reason &&
                !Object.values(InhabilitadoReason).includes(reason)) {
                return res.status(400).json({ error: 'Razón de inhabilitación inválida' });
            }

            await resourceService.updateResourceStatus(
                parseInt(id),
                status,
                reason
            );

            // Reload with associations for complete response
            const resourceWithData = await resourceService.getResourceById(parseInt(id));
            res.json(resourceWithData);
        } catch (error: any) {
            if (error.message === 'Recurso no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/resources/:id/assign
     * Asignar paciente a un recurso
     */
    async assignPatient(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const { patientId } = req.body;

            if (!patientId) {
                return res.status(400).json({ error: 'ID de paciente es requerido' });
            }

            const resource = await resourceService.assignPatientToResource(
                parseInt(id),
                patientId
            );

            res.json(resource);
        } catch (error: any) {
            if (error.message === 'Recurso no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            if (error.message === 'Recurso no disponible' ||
                error.message === 'Recurso a capacidad máxima') {
                return res.status(400).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/resources/:id/release
     * Liberar un recurso
     */
    async releaseResource(req: Request, res: Response) {
        try {
            const { id } = req.params;
            await resourceService.releaseResource(parseInt(id));

            // Reload with associations for complete response
            const resourceWithData = await resourceService.getResourceById(parseInt(id));
            res.json(resourceWithData);
        } catch (error: any) {
            if (error.message === 'Recurso no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/resources/:id/call-next-patient
     * Llamar al siguiente paciente para un recurso
     */
    async callNextPatient(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const resource = await resourceService.getResourceById(Number(id));

            if (!resource) {
                return res.status(404).json({ message: 'Resource not found' });
            }

            if (resource.type !== ResourceType.TRIAJE && !resource.doctorId) {
                return res.status(400).json({ message: 'No doctor assigned to this resource' });
            }

            // Find next patient based on resource type
            let appointmentWhere: any = {};

            if (resource.type === ResourceType.TRIAJE) {
                // For Triaje: Only new patients who haven't completed triaje
                appointmentWhere = {
                    triajeCompleted: false,
                    '$serviceType.code$': 'CONSULTATION_NEW'
                };
            } else {
                // For other resources (Consultorio): 
                // Follow-up patients OR (New patients AND triaje completed)
                appointmentWhere = {
                    doctorId: resource.doctorId,
                    [Op.or]: [
                        { '$serviceType.code$': { [Op.ne]: 'CONSULTATION_NEW' } },
                        { triajeCompleted: true }
                    ]
                };
            }

            const nextPatient = await WaitingRoom.findOne({
                where: {
                    status: WaitingRoomStatus.ESPERANDO,
                },
                include: [{
                    model: Appointment,
                    as: 'appointment',
                    where: appointmentWhere,
                    include: [
                        { model: Queue, as: 'queue' },
                        { model: ServiceType, as: 'serviceType' }
                    ]
                }, {
                    model: Patient,
                    as: 'patient'
                }],
                order: [['priority', 'DESC'], ['checkInTime', 'ASC']]
            });

            if (!nextPatient) {
                return res.status(404).json({ message: 'No hay más pacientes en cola para este médico.' });
            }

            // Call the patient (reuse logic from DoctorService or call it here)
            // For now, let's implement the logic here or inject DoctorService\n            // Ideally, we should move this to a service.

            // Update WaitingRoom status
            await nextPatient.update({ status: WaitingRoomStatus.LLAMADO });

            // Reload with associations for WebSocket event
            const updatedWaitingRoom = await WaitingRoom.findByPk(nextPatient.id, {
                include: [{ model: Patient }, { model: Appointment, include: [Queue] }]
            });

            // Update Resource
            await resource.update({
                status: 'OCUPADO',
                currentPatientId: nextPatient.patientId,
                currentAppointmentId: nextPatient.appointmentId
            });

            // Update Queue status (Set as current turn)
            if (nextPatient.appointmentId) {
                // Set all other items as not current
                await Queue.update({ isCurrent: false }, { where: { isCompleted: false } });

                // Set this item as current
                await Queue.update({ isCurrent: true }, { where: { appointmentId: nextPatient.appointmentId } });
            }

            // Broadcast TV state update
            const tvService = getTvService();
            await tvService.broadcastTvState();

            // Emit events
            const wsService = getWebSocketService();
            wsService.emitTvCall({
                ticket: nextPatient.appointment?.queue?.ticketNumber || `T-${nextPatient.id}`,
                patient: `${nextPatient.patient.firstName} ${nextPatient.patient.lastName}`,
                timestamp: new Date()
            });

            wsService.emitAppointmentUpdate(nextPatient.appointment);
            wsService.emitResourceUpdate(resource);

            // Emit waiting room update
            if (updatedWaitingRoom) {
                wsService.emitWaitingRoomUpdate(updatedWaitingRoom.toJSON());
            }

            // Return updated resource
            const updatedResource = await resourceService.getResourceById(Number(id));
            res.json(updatedResource);

        } catch (error: any) {
            console.error('Error calling next patient:', error);
            res.status(500).json({ message: 'Error calling next patient', error });
        }
    }

    /**
     * GET /api/resources/available/:type
     * Obtener recursos disponibles por tipo
     */
    async getAvailableResources(req: Request, res: Response) {
        try {
            const { type } = req.params;

            if (!Object.values(ResourceType).includes(type as ResourceType)) {
                return res.status(400).json({ error: 'Tipo de recurso inválido' });
            }

            const resources = await resourceService.getAvailableResourcesByType(type as ResourceType);
            res.json(resources);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/resources/statistics
     * Obtener estadísticas de recursos
     */
    async getStatistics(req: Request, res: Response) {
        try {
            const stats = await resourceService.getResourceStatistics();
            res.json(stats);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }
}
