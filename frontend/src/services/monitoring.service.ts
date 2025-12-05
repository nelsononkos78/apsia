import api from './api';

export interface MonitoringSnapshot {
    date: string;
    resources: any;
    appointments: any;
    waitingRoom: any;
}

export class MonitoringService {
    /**
     * Obtener snapshot completo del sistema
     */
    async getSnapshot(date?: Date): Promise<MonitoringSnapshot> {
        const params = date ? { date: date.toISOString() } : {};
        const response = await api.get('/monitoring/snapshot', { params });
        return response.data;
    }

    /**
     * Obtener ocupación de un recurso específico
     */
    async getResourceOccupancy(resourceId: number, date?: Date): Promise<any> {
        const params = date ? { date: date.toISOString() } : {};
        const response = await api.get(`/monitoring/resource/${resourceId}/occupancy`, { params });
        return response.data;
    }

    /**
     * Obtener estadísticas diarias
     */
    async getDailyStatistics(date?: Date): Promise<any> {
        const params = date ? { date: date.toISOString() } : {};
        const response = await api.get('/monitoring/statistics', { params });
        return response.data;
    }

    /**
     * Verificar disponibilidad de recursos
     */
    async checkAvailability(date?: Date): Promise<any> {
        const params = date ? { date: date.toISOString() } : {};
        const response = await api.get('/monitoring/availability', { params });
        return response.data;
    }
}

export const monitoringService = new MonitoringService();
