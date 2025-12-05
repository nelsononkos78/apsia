import { Request, Response } from 'express';
import { ResourceService } from '../services/resource.service';
import { ResourceType, ResourceStatus, InhabilitadoReason } from '../models/resource.model';

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

            const resource = await resourceService.updateResourceStatus(
                parseInt(id),
                status,
                reason
            );

            res.json(resource);
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
            const resource = await resourceService.releaseResource(parseInt(id));
            res.json(resource);
        } catch (error: any) {
            if (error.message === 'Recurso no encontrado') {
                return res.status(404).json({ error: error.message });
            }
            res.status(500).json({ error: error.message });
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
