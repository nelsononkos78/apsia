import { Request, Response } from 'express';
import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { Queue } from '../models/queue.model';

import { Op } from 'sequelize';

export const getAppointments = async (req: Request, res: Response) => {
    try {
        const { patientId, date } = req.query;
        const whereClause: any = {};

        if (patientId) whereClause.patientId = patientId;

        if (date) {
            const startOfDay = new Date(date as string);
            startOfDay.setHours(0, 0, 0, 0);
            const endOfDay = new Date(date as string);
            endOfDay.setHours(23, 59, 59, 999);
            whereClause.dateTime = {
                [Op.between]: [startOfDay, endOfDay]
            };
        }

        const appointments = await Appointment.findAll({
            where: whereClause,
            include: ['patient']
        });
        res.json(appointments);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch appointments' });
    }
};

export const createAppointment = async (req: Request, res: Response) => {
    try {
        const appointment = await Appointment.create(req.body);
        res.status(201).json(appointment);
    } catch (error) {
        res.status(500).json({ error: 'Failed to create appointment' });
    }
};

export const checkInAppointment = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const appointment = await Appointment.findByPk(id);

        if (!appointment) {
            return res.status(404).json({ error: 'Appointment not found' });
        }

        appointment.status = AppointmentStatus.CHECKED_IN;
        await appointment.save();

        // Add to Queue
        // In a real app, we would determine service area based on appointment type
        const serviceAreaMap: any = {
            'CONSULTATION': 'Consultorio 1',
            'LABORATORY': 'Laboratorio',
            'CHEMOTHERAPY': 'Sala Quimio',
            'RECOVERY': 'Recuperación'
        };

        const ticketNumber = `${appointment.serviceType[0]}-${Math.floor(Math.random() * 1000).toString().padStart(3, '0')}`;

        await Queue.create({
            appointmentId: appointment.id,
            serviceArea: serviceAreaMap[appointment.serviceType] || 'General',
            ticketNumber,
            isCurrent: false,
            isCompleted: false
        });

        res.json({ message: 'Check-in successful', ticketNumber });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to check-in' });
    }
};
