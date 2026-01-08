import { Request, Response } from 'express';
import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { Patient } from '../models/patient.model';
import { Quote, QuoteStatus } from '../models/quote.model';
import { MedicalRecord } from '../models/medical-record.model';
import { ServiceType } from '../models/service-type.model';
import { Op, fn, col } from 'sequelize';

export class DashboardController {
    static async getStats(req: Request, res: Response) {
        try {
            const { month, year } = req.query;
            const targetMonth = parseInt(month as string) || new Date().getMonth() + 1;
            const targetYear = parseInt(year as string) || new Date().getFullYear();

            const startDate = new Date(targetYear, targetMonth - 1, 1);
            const endDate = new Date(targetYear, targetMonth, 0, 23, 59, 59, 999);

            // 0. Limpieza reactiva de citas antiguas antes de calcular estadísticas
            const { NoShowService } = require('../services/noshow.service');
            await NoShowService.cleanupOldAppointments();

            // 1. Citas Atendidas de Pacientes Nuevos (registrados en el periodo)
            const newPatients = await Appointment.count({
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] },
                    status: AppointmentStatus.COMPLETED
                },
                include: [{
                    model: Patient,
                    where: {
                        registrationDate: { [Op.between]: [startDate, endDate] }
                    },
                    required: true
                }]
            });

            // 2. Citas Atendidas de Seguimientos (registrados antes)
            const continuingPatients = await Appointment.count({
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] },
                    status: AppointmentStatus.COMPLETED
                },
                include: [{
                    model: Patient,
                    where: {
                        registrationDate: { [Op.lt]: startDate }
                    },
                    required: true
                }]
            });

            // 3. No Show + Canceladas
            const noShows = await Appointment.count({
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] },
                    status: { [Op.in]: [AppointmentStatus.NO_SHOW, AppointmentStatus.CANCELLED] }
                }
            });

            // 4. Total Citas (Suma de Atendidos + No Show/Canceladas) para que cuadre
            const totalAppointments = newPatients + continuingPatients + noShows;

            // 5. Pendientes (Separados por estado para mayor claridad)
            // Por Llegar: Solo SCHEDULED
            const scheduledAppointments = await Appointment.count({
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] },
                    status: AppointmentStatus.SCHEDULED
                }
            });

            // En Espera: Solo CHECKED_IN
            const waitingAppointments = await Appointment.count({
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] },
                    status: AppointmentStatus.CHECKED_IN
                }
            });

            // En Atención: Solo IN_PROGRESS
            const inConsultationAppointments = await Appointment.count({
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] },
                    status: AppointmentStatus.IN_PROGRESS
                }
            });



            // 7. Top 5 Diagnósticos (CIE10)
            // ... (rest of the logic remains same but we need to return pendingAppointments)

            // (I will replace the whole block to be safe and clean)
            const topDiagnostics = await MedicalRecord.findAll({
                attributes: [
                    'diagnosisCode',
                    'diagnosisDescription',
                    [fn('COUNT', col('diagnosisCode')), 'count']
                ],
                where: {
                    createdAt: { [Op.between]: [startDate, endDate] }
                },
                group: ['diagnosisCode', 'diagnosisDescription'],
                order: [[fn('COUNT', col('diagnosisCode')), 'DESC']],
                limit: 5
            });

            const serviceDistribution = await Appointment.findAll({
                attributes: [
                    [col('serviceType.name'), 'name'],
                    [fn('COUNT', col('Appointment.id')), 'count']
                ],
                where: {
                    dateTime: { [Op.between]: [startDate, endDate] }
                },
                include: [{
                    model: ServiceType,
                    as: 'serviceType',
                    attributes: []
                }],
                group: ['serviceType.name'],
                raw: true
            });

            res.json({
                kpis: {
                    newPatients,
                    continuingPatients,
                    totalAppointments,
                    noShows,
                    scheduledAppointments,
                    waitingAppointments,
                    inConsultationAppointments,
                },
                topDiagnostics,
                serviceDistribution
            });
        } catch (error: any) {
            console.error('Error fetching dashboard stats:', error);
            res.status(500).json({ error: error.message });
        }
    }
}
