import api from './api';

export interface WaitingRoomRecord {
    id: number;
    patientId: number;
    appointmentId?: number | null;
    checkInTime: string;
    estimatedWaitTime?: number | null;
    priority: 'NORMAL' | 'URGENTE';
    status: 'ESPERANDO' | 'LLAMADO' | 'ATENDIDO';
    notes?: string | null;
    patient?: {
        id: number;
        name: string;
        firstName?: string;
        lastName?: string;
        documentNumber: string;
    };
    appointment?: {
        id: number;
        dateTime: string;
        serviceType: string;
        doctorId?: number;
        resourceId?: number;
    };
    createdAt: string;
    updatedAt: string;
}

export interface AddToWaitingRoomData {
    patientId: number;
    appointmentId?: number;
    priority?: 'NORMAL' | 'URGENTE';
    estimatedWaitTime?: number;
    notes?: string;
}

export class WaitingRoomService {
    /**
     * Obtener lista actual de espera
     */
    async getCurrentList(): Promise<WaitingRoomRecord[]> {
        const response = await api.get('/waiting-room');
        return response.data;
    }

    /**
     * Obtener todos los registros
     */
    async getAllRecords(): Promise<WaitingRoomRecord[]> {
        const response = await api.get('/waiting-room/all');
        return response.data;
    }

    /**
     * Agregar paciente a la sala de espera
     */
    async addPatient(data: AddToWaitingRoomData): Promise<WaitingRoomRecord> {
        const response = await api.post('/waiting-room', data);
        return response.data;
    }

    /**
     * Actualizar estado de un paciente
     */
    async updateStatus(id: number, status: string): Promise<WaitingRoomRecord> {
        const response = await api.put(`/waiting-room/${id}/status`, { status });
        return response.data;
    }

    /**
     * Llamar a un paciente
     */
    async callPatient(id: number): Promise<WaitingRoomRecord> {
        const response = await api.post(`/waiting-room/${id}/call`);
        return response.data;
    }

    /**
     * Marcar paciente como atendido
     */
    async markAsAttended(id: number): Promise<WaitingRoomRecord> {
        const response = await api.post(`/waiting-room/${id}/attend`);
        return response.data;
    }

    /**
     * Remover paciente de la sala de espera
     */
    async removePatient(id: number): Promise<void> {
        await api.delete(`/waiting-room/${id}`);
    }

    /**
     * Obtener estadísticas
     */
    async getStatistics(): Promise<any> {
        const response = await api.get('/waiting-room/statistics');
        return response.data;
    }
}

export const waitingRoomService = new WaitingRoomService();
