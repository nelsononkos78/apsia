import { Request, Response } from 'express';
import { MonitoringService } from '../services/monitoring.service';

const monitoringService = new MonitoringService();

export class MonitoringController {
    /**
     * GET /api/monitoring/snapshot
     * Obtener snapshot completo del sistema
     * Query params: date (ISO string, opcional, default: hoy)
     */
    async getSnapshot(req: Request, res: Response) {
        try {
            const dateParam = req.query.date as string;
            const date = dateParam ? new Date(dateParam) : new Date();

            if (isNaN(date.getTime())) {
                return res.status(400).json({ error: 'Fecha inválida' });
            }

            const snapshot = await monitoringService.getMonitoringSnapshot(date);
            res.json(snapshot);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/monitoring/resource/:id/occupancy
     * Obtener ocupación de un recurso específico
     * Query params: date (ISO string, opcional, default: hoy)
     */
    async getResourceOccupancy(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const dateParam = req.query.date as string;
            const date = dateParam ? new Date(dateParam) : new Date();

            if (isNaN(date.getTime())) {
                return res.status(400).json({ error: 'Fecha inválida' });
            }

            const occupancy = await monitoringService.getResourceOccupancy(
                parseInt(id),
                date
            );

            res.json(occupancy);
        } catch (error: any) {
            if (error.message === 'Recurso no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/monitoring/statistics
     * Obtener estadísticas diarias
     * Query params: date (ISO string, opcional, default: hoy)
     */
    async getDailyStatistics(req: Request, res: Response) {
        try {
            const dateParam = req.query.date as string;
            const date = dateParam ? new Date(dateParam) : new Date();

            if (isNaN(date.getTime())) {
                return res.status(400).json({ error: 'Fecha inválida' });
            }

            const stats = await monitoringService.getDailyStatistics(date);
            res.json(stats);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    /**
     * GET /api/monitoring/availability
     * Verificar disponibilidad de recursos
     * Query params: date (ISO string, opcional, default: hoy)
     */
    async checkAvailability(req: Request, res: Response) {
        try {
            const dateParam = req.query.date as string;
            const date = dateParam ? new Date(dateParam) : new Date();

            if (isNaN(date.getTime())) {
                return res.status(400).json({ error: 'Fecha inválida' });
            }

            const availability = await monitoringService.checkResourceAvailability(date);
            res.json(availability);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }
}
