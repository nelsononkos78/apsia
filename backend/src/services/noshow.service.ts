import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { WaitingRoom, WaitingRoomStatus } from '../models/waiting-room.model';
import { Queue } from '../models/queue.model';
import { Op } from 'sequelize';

export class NoShowService {
    /**
     * Marca como NO_SHOW todas las citas de fechas anteriores a hoy que quedaron en espera o sin check-in.
     * Se llama reactivamente al cargar vistas de monitoreo.
     */
    static async cleanupOldAppointments() {
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        // 1. Buscar citas de días anteriores que no se completaron ni cancelaron
        const oldAppointments = await Appointment.findAll({
            where: {
                dateTime: { [Op.lt]: today },
                status: {
                    [Op.in]: [
                        AppointmentStatus.SCHEDULED,
                        AppointmentStatus.CHECKED_IN,
                        AppointmentStatus.IN_PROGRESS
                    ]
                }
            }
        });

        if (oldAppointments.length === 0) return 0;

        for (const appointment of oldAppointments) {
            appointment.status = AppointmentStatus.NO_SHOW;
            await appointment.save();

            // Actualizar Sala de Espera si existe registro
            await WaitingRoom.update(
                { status: WaitingRoomStatus.NO_SHOW },
                { where: { appointmentId: appointment.id } }
            );

            // Actualizar Cola
            await Queue.update(
                { isCompleted: true, isCurrent: false },
                { where: { appointmentId: appointment.id } }
            );

            // Liberar recurso si está asignado
            await this.releaseResourceIfAssigned(appointment.id);
        }

        console.log(`[NoShowService] Limpieza reactiva completada: ${oldAppointments.length} citas marcadas como NO_SHOW.`);
        return oldAppointments.length;
    }

    /**
     * Proceso diario (ej. 11 PM) para marcar como NO_SHOW las citas del día actual que no se confirmaron.
     */
    static async processDailyNoShows() {
        const now = new Date();
        const startOfDay = new Date(now);
        startOfDay.setHours(0, 0, 0, 0);
        const endOfDay = new Date(now);
        endOfDay.setHours(23, 59, 59, 999);

        const pendingToday = await Appointment.findAll({
            where: {
                dateTime: { [Op.between]: [startOfDay, endOfDay] },
                status: AppointmentStatus.SCHEDULED
            }
        });
        try {
            const now = new Date();
            const startOfDay = new Date(now);
            startOfDay.setHours(0, 0, 0, 0);
            const endOfDay = new Date(now);
            endOfDay.setHours(23, 59, 59, 999);

            const pendingToday = await Appointment.findAll({
                where: {
                    dateTime: { [Op.between]: [startOfDay, endOfDay] },
                    status: AppointmentStatus.SCHEDULED
                }
            });

            if (pendingToday.length === 0) {
                console.log(`[NoShowService] Proceso diario: No hay citas pendientes para marcar como NO_SHOW.`);
                return 0;
            }

            for (const appointment of pendingToday) {
                appointment.status = AppointmentStatus.NO_SHOW;
                await appointment.save();
            }

            console.log(`[NoShowService] Proceso diario completado: ${pendingToday.length} citas marcadas como NO_SHOW.`);

            const { getWebSocketService } = require('./websocket.service');
            getWebSocketService().emitDashboardUpdate();
            return pendingToday.length;
        } catch (error) {
            console.error('[NoShowService] Error en proceso diario:', error);
            return 0; // Or rethrow, depending on desired error handling
        }
    }

    /**
     * Marca manualmente un paciente de la sala de espera como NO_SHOW (se retiró).
     */
    static async markManualNoShow(waitingRoomId: number) {
        const record = await WaitingRoom.findByPk(waitingRoomId);
        if (!record) throw new Error('Registro de sala de espera no encontrado');

        record.status = WaitingRoomStatus.NO_SHOW;
        await record.save();

        if (record.appointmentId) {
            const appointment = await Appointment.findByPk(record.appointmentId);
            if (appointment) {
                appointment.status = AppointmentStatus.NO_SHOW;
                await appointment.save();
            }

            await Queue.update(
                { isCompleted: true, isCurrent: false },
                { where: { appointmentId: record.appointmentId } }
            );

            // Liberar recurso si está asignado
            await this.releaseResourceIfAssigned(record.appointmentId);
        }

        return record;
    }

    /**
     * Libera un recurso si la cita está asignada a uno.
     */
    private static async releaseResourceIfAssigned(appointmentId: number) {
        try {
            const { Resource, ResourceStatus } = require('../models/resource.model');
            const resource = await Resource.findOne({ where: { currentAppointmentId: appointmentId } });

            if (resource) {
                console.log(`[NoShowService] Liberando recurso ${resource.name} (ID: ${resource.id}) para cita ${appointmentId}`);
                resource.currentPatientId = null;
                resource.currentAppointmentId = null;
                resource.currentOccupancy = 0;
                resource.status = ResourceStatus.DISPONIBLE;
                await resource.save();

                // Emitir actualización vía WebSocket
                const { getWebSocketService } = require('./websocket.service');
                const wsService = getWebSocketService();
                wsService.emitResourceUpdate(resource.toJSON());
            }
        } catch (error) {
            console.error('[NoShowService] Error al liberar recurso:', error);
        }
    }
}
