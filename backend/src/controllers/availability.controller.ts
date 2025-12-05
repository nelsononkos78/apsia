import { Request, Response } from 'express';
import { Appointment } from '../models/appointment.model';
import { Op } from 'sequelize';

export const getAvailability = async (req: Request, res: Response) => {
    try {
        const { date, specialty, doctorId } = req.query;

        if (!date) {
            return res.status(400).json({ error: 'Date is required' });
        }

        // Define time slots (9 AM to 5 PM, every 30 minutes)
        const timeSlots = [
            '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
            '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
            '15:00', '15:30', '16:00', '16:30', '17:00'
        ];

        const selectedDate = new Date(date as string);
        const startOfDay = new Date(selectedDate);
        startOfDay.setHours(0, 0, 0, 0);
        const endOfDay = new Date(selectedDate);
        endOfDay.setHours(23, 59, 59, 999);

        // Get existing appointments for this date
        const whereClause: any = {
            dateTime: {
                [Op.between]: [startOfDay, endOfDay]
            }
        };

        if (specialty) whereClause.specialty = specialty;
        if (doctorId) whereClause.doctorId = doctorId;

        const existingAppointments = await Appointment.findAll({ where: whereClause });

        // Mark occupied time slots
        const availability = timeSlots.map(slot => {
            const [hours, minutes] = slot.split(':');
            const slotDateTime = new Date(selectedDate);
            slotDateTime.setHours(parseInt(hours), parseInt(minutes), 0, 0);

            const isOccupied = existingAppointments.some(apt => {
                const aptTime = new Date(apt.dateTime);
                return aptTime.getHours() === slotDateTime.getHours() &&
                    aptTime.getMinutes() === slotDateTime.getMinutes();
            });

            return {
                time: slot,
                available: !isOccupied
            };
        });

        res.json(availability);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch availability' });
    }
};
