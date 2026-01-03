import { Request, Response } from 'express';
import { WaitingRoomService } from '../services/waiting-room.service';
import { WaitingRoomPriority, WaitingRoomStatus } from '../models/waiting-room.model';

const waitingRoomService = new WaitingRoomService();

export class WaitingRoomController {
    /**
     * GET /api/waiting-room
     * Obtener lista actual de espera
     */
    async getCurrentList(req: Request, res: Response) {
        try {
            const list = await waitingRoomService.getCurrentWaitingList();
            res.json(list);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/waiting-room/all
     * Obtener todos los registros
     */
    async getAllRecords(req: Request, res: Response) {
        try {
            const records = await waitingRoomService.getAllWaitingRoomRecords();
            res.json(records);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/waiting-room
     * Agregar paciente a la sala de espera
     */
    async addPatient(req: Request, res: Response) {
        try {
            const { patientId, appointmentId, priority, estimatedWaitTime, notes } = req.body;

            if (!patientId) {
                return res.status(400).json({ error: 'ID de paciente es requerido' });
            }

            if (priority && !Object.values(WaitingRoomPriority).includes(priority)) {
                return res.status(400).json({ error: 'Prioridad inválida' });
            }

            const record = await waitingRoomService.addToWaitingRoom({
                patientId,
                appointmentId,
                priority,
                estimatedWaitTime,
                notes
            });

            res.status(201).json(record);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * PUT /api/waiting-room/:id/status
     * Actualizar estado de un paciente
     */
    async updateStatus(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const { status } = req.body;

            if (!status) {
                return res.status(400).json({ error: 'Estado es requerido' });
            }

            if (!Object.values(WaitingRoomStatus).includes(status)) {
                return res.status(400).json({ error: 'Estado inválido' });
            }

            const record = await waitingRoomService.updatePatientStatus(
                parseInt(id),
                status
            );

            res.json(record);
        } catch (error: any) {
            if (error.message === 'Registro no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/waiting-room/:id/call
     * Llamar a un paciente
     */
    async callPatient(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const record = await waitingRoomService.callPatient(parseInt(id));
            res.json(record);
        } catch (error: any) {
            if (error.message === 'Registro no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/waiting-room/:id/attend
     * Marcar paciente como atendido
     */
    async markAsAttended(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const record = await waitingRoomService.markAsAttended(parseInt(id));
            res.json(record);
        } catch (error: any) {
            if (error.message === 'Registro no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * DELETE /api/waiting-room/:id
     * Remover paciente de la sala de espera
     */
    async removePatient(req: Request, res: Response) {
        try {
            const { id } = req.params;
            await waitingRoomService.removeFromWaitingRoom(parseInt(id));
            res.status(204).send();
        } catch (error: any) {
            if (error.message === 'Registro no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/waiting-room/statistics
     * Obtener estadísticas de la sala de espera
     */
    async getStatistics(req: Request, res: Response) {
        try {
            const stats = await waitingRoomService.getWaitingRoomStatistics();
            const avgWaitTime = await waitingRoomService.getAverageWaitTime();

            res.json({
                ...stats,
                averageWaitTime: avgWaitTime
            });
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * POST /api/waiting-room/attend-all
     * Marcar todos los pacientes como atendidos
     */
    async markAllAsAttended(req: Request, res: Response) {
        try {
            await waitingRoomService.markAllAsAttended();
            res.json({ message: 'Todos los pacientes han sido marcados como atendidos' });
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }
}
