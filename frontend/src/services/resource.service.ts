import api from './api';

export interface Resource {
    id: number;
    name: string;
    type: 'CONSULTORIO' | 'TRATAMIENTO' | 'ESTANCIA';
    status: 'DISPONIBLE' | 'OCUPADO' | 'INHABILITADO';
    statusReason?: 'MANTENIMIENTO' | 'LIMPIEZA' | 'FALLA' | null;
    capacity: number;
    currentOccupancy: number;
    currentPatientId?: number | null;
    notes?: string | null;
    createdAt: string;
    updatedAt: string;
}

export interface CreateResourceData {
    name: string;
    type: 'CONSULTORIO' | 'TRATAMIENTO' | 'ESTANCIA';
    capacity?: number;
    notes?: string;
}

export interface UpdateResourceStatusData {
    status: 'DISPONIBLE' | 'OCUPADO' | 'INHABILITADO';
    reason?: 'MANTENIMIENTO' | 'LIMPIEZA' | 'FALLA';
}

export class ResourceService {
    /**
     * Obtener todos los recursos
     */
    async getAllResources(): Promise<Resource[]> {
        const response = await api.get('/resources');
        return response.data;
    }

    /**
     * Obtener recursos por tipo
     */
    async getResourcesByType(type: string): Promise<Resource[]> {
        const response = await api.get(`/resources/type/${type}`);
        return response.data;
    }

    /**
     * Obtener un recurso por ID
     */
    async getResourceById(id: number): Promise<Resource> {
        const response = await api.get(`/resources/${id}`);
        return response.data;
    }

    /**
     * Crear un nuevo recurso
     */
    async createResource(data: CreateResourceData): Promise<Resource> {
        const response = await api.post('/resources', data);
        return response.data;
    }

    /**
     * Actualizar estado de un recurso
     */
    async updateResourceStatus(id: number, data: UpdateResourceStatusData): Promise<Resource> {
        const response = await api.put(`/resources/${id}/status`, data);
        return response.data;
    }

    /**
     * Asignar paciente a un recurso
     */
    async assignPatient(id: number, patientId: number): Promise<Resource> {
        const response = await api.post(`/resources/${id}/assign`, { patientId });
        return response.data;
    }

    /**
     * Liberar un recurso
     */
    async releaseResource(id: number): Promise<Resource> {
        const response = await api.post(`/resources/${id}/release`);
        return response.data;
    }

    /**
     * Obtener recursos disponibles por tipo
     */
    async getAvailableResources(type: string): Promise<Resource[]> {
        const response = await api.get(`/resources/available/${type}`);
        return response.data;
    }

    /**
     * Obtener estadísticas de recursos
     */
    async getStatistics(): Promise<any> {
        const response = await api.get('/resources/statistics');
        return response.data;
    }
}

export const resourceService = new ResourceService();
