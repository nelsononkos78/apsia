import { WaitingRoom, WaitingRoomStatus, WaitingRoomPriority } from '../models/waiting-room.model';
import { Patient } from '../models/patient.model';
import { Appointment } from '../models/appointment.model';
import { getWebSocketService } from './websocket.service';

export class WaitingRoomService {
    /**
     * Agregar paciente a la sala de espera
     */
    async addToWaitingRoom(data: {
        patientId: number;
        appointmentId?: number;
        priority?: WaitingRoomPriority;
        estimatedWaitTime?: number;
        notes?: string;
    }): Promise<WaitingRoom> {
        const newRecord = await WaitingRoom.create({
            patientId: data.patientId,
            appointmentId: data.appointmentId || null,
            priority: data.priority || WaitingRoomPriority.NORMAL,
            estimatedWaitTime: data.estimatedWaitTime || null,
            notes: data.notes || null,
            checkInTime: new Date(),
            status: WaitingRoomStatus.ESPERANDO
        });

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting waitingRoom:added via WebSocket:', { id: newRecord.id });
            wsService.emitWaitingRoomAdded(newRecord.toJSON());
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }

        return newRecord;
    }

    /**
     * Obtener lista actual de espera
     */
    async getCurrentWaitingList(): Promise<WaitingRoom[]> {
        return await WaitingRoom.findAll({
            where: {
                status: WaitingRoomStatus.ESPERANDO
            },
            include: [
                {
                    model: Patient,
                    attributes: ['id', 'firstName', 'lastName', 'documentId']
                },
                {
                    model: Appointment,
                    attributes: ['id', 'dateTime', 'serviceType']
                }
            ],
            order: [
                ['priority', 'DESC'], // URGENTE primero
                ['checkInTime', 'ASC'] // Más antiguos primero
            ]
        });
    }

    /**
     * Obtener todos los registros (incluyendo atendidos)
     */
    async getAllWaitingRoomRecords(): Promise<WaitingRoom[]> {
        return await WaitingRoom.findAll({
            include: [
                {
                    model: Patient,
                    attributes: ['id', 'firstName', 'lastName', 'documentId']
                },
                {
                    model: Appointment,
                    attributes: ['id', 'dateTime', 'serviceType']
                }
            ],
            order: [['checkInTime', 'DESC']]
        });
    }

    /**
     * Actualizar estado de un paciente en sala de espera
     */
    async updatePatientStatus(id: number, status: WaitingRoomStatus): Promise<WaitingRoom> {
        const record = await WaitingRoom.findByPk(id);
        if (!record) {
            throw new Error('Registro no encontrado');
        }

        record.status = status;
        await record.save();

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting waitingRoom:updated via WebSocket:', { id: record.id, status: record.status });
            wsService.emitWaitingRoomUpdate(record.toJSON());
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }

        return record;
    }

    /**
     * Llamar a un paciente (cambiar estado a LLAMADO)
     */
    async callPatient(id: number): Promise<WaitingRoom> {
        return await this.updatePatientStatus(id, WaitingRoomStatus.LLAMADO);
    }

    /**
     * Marcar paciente como atendido
     */
    async markAsAttended(id: number): Promise<WaitingRoom> {
        return await this.updatePatientStatus(id, WaitingRoomStatus.ATENDIDO);
    }

    /**
     * Remover paciente de la sala de espera
     */
    async removeFromWaitingRoom(id: number): Promise<void> {
        const record = await WaitingRoom.findByPk(id);
        if (!record) {
            throw new Error('Registro no encontrado');
        }

        await record.destroy();

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting waitingRoom:removed via WebSocket:', { id });
            wsService.emitWaitingRoomRemoved(id);
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }
    }

    /**
     * Obtener estadísticas de la sala de espera
     */
    async getWaitingRoomStatistics() {
        const allRecords = await WaitingRoom.findAll();

        return {
            total: allRecords.length,
            esperando: allRecords.filter(r => r.status === WaitingRoomStatus.ESPERANDO).length,
            llamados: allRecords.filter(r => r.status === WaitingRoomStatus.LLAMADO).length,
            atendidos: allRecords.filter(r => r.status === WaitingRoomStatus.ATENDIDO).length,
            urgentes: allRecords.filter(r => r.priority === WaitingRoomPriority.URGENTE).length,
            normales: allRecords.filter(r => r.priority === WaitingRoomPriority.NORMAL).length
        };
    }

    /**
     * Calcular tiempo de espera promedio
     */
    async getAverageWaitTime(): Promise<number> {
        const attendedRecords = await WaitingRoom.findAll({
            where: {
                status: WaitingRoomStatus.ATENDIDO
            }
        });

        if (attendedRecords.length === 0) return 0;

        const totalWaitTime = attendedRecords.reduce((sum, record) => {
            const waitTime = (record.updatedAt.getTime() - record.checkInTime.getTime()) / 1000 / 60; // en minutos
            return sum + waitTime;
        }, 0);

        return Math.round(totalWaitTime / attendedRecords.length);
    }
}
