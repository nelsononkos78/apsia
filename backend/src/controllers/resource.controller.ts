import { Request, Response } from 'express';
import { ResourceService } from '../services/resource.service';
import { Resource, ResourceType, ResourceStatus, InhabilitadoReason } from '../models/resource.model';
import { WaitingRoom, WaitingRoomStatus } from '../models/waiting-room.model';
import { Appointment, ServiceTypeEnum } from '../models/appointment.model';
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
            const { staffId } = req.query;

            if (!Object.values(ResourceType).includes(type as ResourceType)) {
                return res.status(400).json({ error: 'Tipo de recurso inválido' });
            }

            const resources = await resourceService.getResourcesByType(
                type as ResourceType,
                staffId ? parseInt(staffId as string) : undefined
            );
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
            const { name, type, capacity, notes, doctorId, staffId } = req.body;

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
                notes,
                doctorId,
                staffId
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
     * POST /api/resources/:id/call-next
     * Llamar al siguiente paciente para un recurso
     */
    async callNextPatient(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const resource = await resourceService.getResourceById(Number(id));

            if (!resource) {
                return res.status(404).json({ message: 'Resource not found' });
            }

            // if (resource.type !== ResourceType.TRIAJE && !resource.doctorId) {
            //     return res.status(400).json({ message: 'No doctor assigned to this resource' });
            // }



            const nextPatient = await WaitingRoom.findOne({
                where: {
                    status: WaitingRoomStatus.ESPERANDO,
                    ...(resource.type === ResourceType.TRIAJE ? {
                        '$appointment.triajeCompleted$': false
                    } : {
                        [Op.or]: [
                            { '$appointment.triajeCompleted$': true },
                            {
                                '$appointment.serviceType.code$': {
                                    [Op.ne]: ServiceTypeEnum.CONSULTATION_NEW
                                }
                            }
                        ]
                    }),
                    // Strictly filter by doctorId ONLY for CONSULTORIO
                    ...(resource.type === ResourceType.CONSULTORIO && resource.doctorId ? { '$appointment.doctorId$': resource.doctorId } : {})
                },
                include: [{
                    model: Appointment,
                    as: 'appointment',
                    required: true,
                    include: [
                        { model: Queue, as: 'queue' },
                        {
                            model: ServiceType,
                            as: 'serviceType',
                            required: true,
                            // For TRIAJE: only CONSULTATION_NEW
                            ...(resource.type === ResourceType.TRIAJE ? {
                                where: { code: ServiceTypeEnum.CONSULTATION_NEW }
                            } : {})
                        }
                    ]
                }, {
                    model: Patient,
                    as: 'patient'
                }],
                order: [['priority', 'DESC'], ['checkInTime', 'ASC']]
            });

            if (!nextPatient) {
                if (resource.type !== ResourceType.TRIAJE) {
                    const pendingTriajeWhere: any = { triajeCompleted: false };
                    if (resource.doctorId) {
                        pendingTriajeWhere.doctorId = resource.doctorId;
                    }

                    const pendingTriaje = await WaitingRoom.count({
                        where: { status: WaitingRoomStatus.ESPERANDO },
                        include: [{
                            model: Appointment,
                            as: 'appointment',
                            where: pendingTriajeWhere
                        }]
                    });

                    if (pendingTriaje > 0) {
                        return res.status(404).json({
                            message: `No hay pacientes listos. Hay ${pendingTriaje} paciente(s) en triaje para este médico.`,
                            hasPendingTriaje: true
                        });
                    }
                }
                return res.status(404).json({ message: 'No hay más pacientes en cola para este médico.' });
            }

            // Call the patient
            if (!nextPatient.patient) {
                console.error(`❌ Patient not found for WaitingRoom record ${nextPatient.id}`);
                return res.status(500).json({ message: 'Error: Datos del paciente no encontrados.' });
            }

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

                // Set this item as current and update serviceArea to match resource
                await Queue.update(
                    {
                        isCurrent: true,
                        serviceArea: resource.name // This will help TvService identify the area
                    },
                    { where: { appointmentId: nextPatient.appointmentId } }
                );

                // Update appointment resourceId
                await Appointment.update(
                    { resourceId: resource.id },
                    { where: { id: nextPatient.appointmentId } }
                );
            }

            // Broadcast TV state update
            try {
                // Emit events
                const wsService = getWebSocketService();
                const ticket = nextPatient.appointment?.queue?.ticketNumber || `T-${nextPatient.id}`;
                const patientName = `${nextPatient.patient.firstName} ${nextPatient.patient.lastName}`;
                const destination = resource.type === 'TRIAJE' ? 'Triaje' : resource.name;

                wsService.emitTvCall({
                    ticket,
                    patient: patientName,
                    patientName, // For compatibility
                    ticketNumber: ticket, // For compatibility
                    destination,
                    timestamp: new Date()
                });

                const tvService = getTvService();
                await tvService.broadcastTvState();

                if (nextPatient.appointment) {
                    wsService.emitAppointmentUpdate(nextPatient.appointment);
                }
                wsService.emitResourceUpdate(resource);

                // Emit waiting room update
                if (updatedWaitingRoom) {
                    wsService.emitWaitingRoomUpdate(updatedWaitingRoom.toJSON());
                }

                // Notify dashboard of changes
                wsService.emitDashboardUpdate();
            } catch (emitError) {
                console.error('Error emitting events:', emitError);
            }

            // Return updated resource
            const updatedResource = await resourceService.getResourceById(Number(id));
            res.json(updatedResource);

        } catch (error: any) {
            console.error('❌ Error calling next patient:', error);
            res.status(500).json({
                message: 'Error al llamar al siguiente paciente',
                error: error.message || 'Internal Server Error'
            });
        }
    }

    /**
     * GET /api/resources/available/:type
     * Obtener recursos disponibles por tipo
     */
    async getAvailableResources(req: Request, res: Response) {
        try {
            const { type } = req.params;
            const { staffId } = req.query;

            if (!type) {
                return res.status(400).json({ error: 'Tipo es requerido' });
            }

            const resources = await resourceService.getAvailableResourcesByType(
                type as ResourceType,
                staffId ? parseInt(staffId as string) : undefined
            );
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
