import { Request, Response } from 'express';
import { Appointment } from '../models/appointment.model';
import { Doctor } from '../models/doctor.model';
import { Specialty } from '../models/specialty.model';
import { DoctorSchedule } from '../models/doctor-schedule.model';
import { Op } from 'sequelize';

export const getAvailability = async (req: Request, res: Response) => {
    try {
        const { date, specialty, doctorId } = req.query;

        if (!date) {
            return res.status(400).json({ error: 'Date is required' });
        }

        const [year, month, day] = (date as string).split('-').map(Number);
        const startOfDay = new Date(year, month - 1, day, 0, 0, 0, 0);
        const endOfDay = new Date(year, month - 1, day, 23, 59, 59, 999);

        // Logic:
        // 1. If doctorId is provided, check that doctor's quota vs appointments.
        // 2. If only specialty is provided, check if ANY doctor in that specialty has quota.

        let isAvailable = false;
        let message = '';
        let remainingQuota = 0;

        if (doctorId) {
            console.log(`Checking availability for doctorId: ${doctorId} on date: ${date} (Day: ${startOfDay.getDay()})`);
            const doctor = await Doctor.findByPk(doctorId as string, {
                include: [{
                    model: DoctorSchedule,
                    where: { dayOfWeek: startOfDay.getDay(), isActive: true },
                    required: true // Changed to true to correctly filter
                }]
            });

            if (!doctor) {
                return res.status(404).json({ error: 'Doctor not found' });
            }

            if (doctor.schedules.length === 0) {
                return res.json({
                    date: date,
                    available: false,
                    message: 'El médico no atiende este día de la semana',
                    remainingQuota: 0
                });
            }

            const appointmentCount = await Appointment.count({
                where: {
                    doctorId: doctorId as string,
                    dateTime: {
                        [Op.between]: [startOfDay, endOfDay]
                    },
                    status: {
                        [Op.not]: 'CANCELLED'
                    }
                }
            });

            remainingQuota = Math.max(0, doctor.dailyQuota - appointmentCount);
            isAvailable = remainingQuota > 0;
            message = isAvailable
                ? `Disponible (${remainingQuota} cupos restantes)`
                : 'Agenda llena para este día';

        } else if (specialty) {
            const doctors = await Doctor.findAll({
                include: [
                    {
                        model: Specialty,
                        where: { name: specialty as string }
                    },
                    {
                        model: DoctorSchedule,
                        where: { dayOfWeek: startOfDay.getDay(), isActive: true },
                        required: true // Only doctors with a schedule for this day
                    }
                ],
                where: { status: 'activo' }
            });

            if (doctors.length === 0) {
                return res.json({ available: false, message: 'No hay médicos disponibles para esta especialidad', remainingQuota: 0 });
            }

            let totalQuota = 0;
            let totalAppointments = 0;

            for (const doctor of doctors) {
                const count = await Appointment.count({
                    where: {
                        doctorId: doctor.id,
                        dateTime: {
                            [Op.between]: [startOfDay, endOfDay]
                        },
                        status: { [Op.not]: 'CANCELLED' }
                    }
                });
                totalQuota += doctor.dailyQuota;
                totalAppointments += count;
            }

            remainingQuota = Math.max(0, totalQuota - totalAppointments);
            isAvailable = remainingQuota > 0;
            message = isAvailable
                ? `Hay cupos disponibles (${remainingQuota} cupos totales)`
                : 'Agenda llena para esta especialidad';
        } else {
            return res.json({ available: false, message: 'Seleccione especialidad o médico', remainingQuota: 0 });
        }

        res.json({
            date: date,
            available: isAvailable,
            message: message,
            remainingQuota: remainingQuota
        });

    } catch (error) {
        console.error('Error in getAvailability:', error);
        res.status(500).json({ error: 'Failed to fetch availability' });
    }
};
