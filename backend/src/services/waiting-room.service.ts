import { WaitingRoom, WaitingRoomStatus, WaitingRoomPriority } from '../models/waiting-room.model';
import { Patient } from '../models/patient.model';
import { Appointment } from '../models/appointment.model';
import { Queue } from '../models/queue.model';
import { getWebSocketService } from './websocket.service';
import { getTvService } from './tv.service';

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

        // Fetch with associations for the UI
        const recordWithData = await WaitingRoom.findByPk(newRecord.id, {
            include: [
                {
                    model: Patient
                },
                {
                    model: Appointment,
                    include: ['serviceType', 'doctor']
                }
            ]
        });

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting waitingRoom:added via WebSocket:', { id: newRecord.id });
            if (recordWithData) {
                wsService.emitWaitingRoomAdded(recordWithData.toJSON());
            }

            // Broadcast TV state
            const tvService = getTvService();
            await tvService.broadcastTvState();
        } catch (error) {
            console.error('❌ WebSocket or TV Service error:', error);
        }

        return newRecord;
    }

    /**
     * Obtener lista actual de espera
     */
    async getCurrentWaitingList(): Promise<WaitingRoom[]> {
        // Limpieza reactiva de citas antiguas
        const { NoShowService } = require('./noshow.service');
        await NoShowService.cleanupOldAppointments();

        return await WaitingRoom.findAll({
            where: {
                status: WaitingRoomStatus.ESPERANDO
            },
            include: [
                {
                    model: Patient
                },
                {
                    model: Appointment,
                    include: ['serviceType', 'doctor']
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
                    model: Patient
                },
                {
                    model: Appointment,
                    include: ['serviceType', 'doctor']
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

        // Fetch with associations for the UI
        const recordWithData = await WaitingRoom.findByPk(record.id, {
            include: [
                {
                    model: Patient
                },
                {
                    model: Appointment,
                    include: ['serviceType', 'doctor']
                }
            ]
        });

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            console.log('🔄 Emitting waitingRoom:updated via WebSocket:', { id: record.id, status: record.status });
            if (recordWithData) {
                wsService.emitWaitingRoomUpdate(recordWithData.toJSON());
            }
        } catch (error) {
            console.error('❌ WebSocket not initialized:', error);
        }

        return record;
    }

    /**
     * Llamar a un paciente (cambiar estado a LLAMADO)
     */
    async callPatient(id: number): Promise<WaitingRoom> {
        const record = await WaitingRoom.findByPk(id);
        if (!record) {
            throw new Error('Registro no encontrado');
        }

        // Update WaitingRoom status
        record.status = WaitingRoomStatus.LLAMADO;
        await record.save();

        // Update Queue status
        if (record.appointmentId) {
            // Set all other items as not current
            await Queue.update({ isCurrent: false }, { where: { isCompleted: false } });

            // Set this item as current
            await Queue.update({ isCurrent: true }, { where: { appointmentId: record.appointmentId } });
        }

        // Emit specific TV call event
        try {
            const wsService = getWebSocketService();
            const recordWithData = await WaitingRoom.findByPk(id, {
                include: [
                    { model: Patient },
                    {
                        model: Appointment,
                        include: [Queue, 'doctor']
                    }
                ]
            });
            if (recordWithData) {
                const ticket = recordWithData.appointment?.queue?.ticketNumber || '---';
                const patientName = recordWithData.patient ? `${recordWithData.patient.firstName} ${recordWithData.patient.lastName}` : '';

                console.log(`🔔 Emitting tv:call for ticket ${ticket} (${patientName})`);

                wsService.emitTvCall({
                    ticket,
                    patient: patientName,
                    patientName, // Compatibility
                    ticketNumber: ticket, // Compatibility
                    destination: 'Sala de Espera',
                    timestamp: new Date()
                });
            }
        } catch (error) {
            console.error('❌ Error emitting tv:call:', error);
        }

        // Broadcast TV state
        const tvService = getTvService();
        await tvService.broadcastTvState();

        // Emit standard waiting room update
        await this.updatePatientStatus(id, WaitingRoomStatus.LLAMADO);

        return record;
    }

    /**
     * Marcar paciente como atendido
     */
    async markAsAttended(id: number): Promise<WaitingRoom> {
        const record = await WaitingRoom.findByPk(id);
        if (!record) {
            throw new Error('Registro no encontrado');
        }

        // Update WaitingRoom status
        record.status = WaitingRoomStatus.ATENDIDO;
        await record.save();

        // Update Queue status
        if (record.appointmentId) {
            await Queue.update(
                { isCompleted: true, isCurrent: false },
                { where: { appointmentId: record.appointmentId } }
            );
        }

        // Broadcast TV state
        const tvService = getTvService();
        await tvService.broadcastTvState();

        // Emit standard waiting room update
        await this.updatePatientStatus(id, WaitingRoomStatus.ATENDIDO);

        return record;
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

            // Broadcast TV state
            const tvService = getTvService();
            await tvService.broadcastTvState();
        } catch (error) {
            console.error('❌ WebSocket or TV Service error:', error);
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

    /**
     * Marcar todos los pacientes en espera como atendidos
     */
    async markAllAsAttended(): Promise<void> {
        const waitingRecords = await WaitingRoom.findAll({
            where: {
                status: [WaitingRoomStatus.ESPERANDO, WaitingRoomStatus.LLAMADO]
            }
        });

        for (const record of waitingRecords) {
            record.status = WaitingRoomStatus.ATENDIDO;
            await record.save();

            if (record.appointmentId) {
                await Queue.update(
                    { isCompleted: true, isCurrent: false },
                    { where: { appointmentId: record.appointmentId } }
                );
            }
        }

        // Broadcast TV state and notify clients
        try {
            const tvService = getTvService();
            await tvService.broadcastTvState();

            const wsService = getWebSocketService();
            // Emit a general update event to refresh the list on all clients
            wsService.emitWaitingRoomUpdate({ bulk: true } as any);
        } catch (error) {
            console.error('❌ Error in bulk update broadcast:', error);
        }
    }
}
