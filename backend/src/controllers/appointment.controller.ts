import { Request, Response } from 'express';
import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { Queue } from '../models/queue.model';
import { getWebSocketService } from '../services/websocket.service';

import { Op } from 'sequelize';

export const getAppointments = async (req: Request, res: Response) => {
    try {
        const { patientId, date } = req.query;
        const whereClause: any = {};

        if (patientId) whereClause.patientId = patientId;

        if (date) {
            const [year, month, day] = (date as string).split('-').map(Number);
            const startOfDay = new Date(year, month - 1, day, 0, 0, 0, 0);
            const endOfDay = new Date(year, month - 1, day, 23, 59, 59, 999);
            whereClause.dateTime = {
                [Op.between]: [startOfDay, endOfDay]
            };
        }

        const appointments = await Appointment.findAll({
            where: whereClause,
            include: ['patient', 'doctor', 'serviceType']
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

        // Reload with associations for complete data
        const appointmentWithData = await Appointment.findByPk(appointment.id, {
            include: ['patient', 'doctor', 'serviceType']
        });

        // Emit WebSocket event
        try {
            const wsService = getWebSocketService();
            if (appointmentWithData) {
                wsService.emitAppointmentUpdate(appointmentWithData.toJSON());
            }
            wsService.emitDashboardUpdate();
        } catch (wsError) {
            console.error('WebSocket emission failed:', wsError);
        }

        res.status(201).json(appointment);
    } catch (error) {
        console.error('Error creating appointment:', error);
        res.status(500).json({ error: 'Failed to create appointment' });
    }
};

export const checkInAppointment = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { patientId } = req.body;
        const appointment = await Appointment.findByPk(id, { include: ['serviceType'] });

        if (!appointment) {
            return res.status(404).json({ error: 'Appointment not found' });
        }

        // Associate patient if provided (for appointments created without patientId)
        if (patientId) {
            appointment.patientId = patientId;
        }

        if (!appointment.patientId) {
            return res.status(400).json({ error: 'Appointment must be associated with a patient before check-in' });
        }

        appointment.status = AppointmentStatus.CHECKED_IN;
        appointment.checkinTime = new Date();

        // Auto-mark triajeCompleted for services that don't require triage
        // Only CONSULTATION_NEW requires triage
        if (appointment.serviceType?.code !== 'CONSULTATION_NEW') {
            appointment.triajeCompleted = true;
        }

        await appointment.save();

        // Emit WebSocket event for dashboard update
        try {
            getWebSocketService().emitDashboardUpdate();
        } catch (wsError) {
            console.error('WebSocket emission failed for dashboard update after check-in:', wsError);
        }

        // Add to Queue
        // In a real app, we would determine service area based on appointment type
        const serviceAreaMap: any = {
            'CONSULTATION_NEW': 'Consultorio 1',
            'CONSULTATION_FOLLOWUP': 'Consultorio 2',
            'LABORATORY_ONCO': 'Laboratorio',
            'CHEMOTHERAPY': 'Sala Quimio',
            'RECOVERY': 'Recuperación'
        };

        const serviceCode = appointment.serviceType?.code || 'G';
        const ticketNumber = `${serviceCode[0]}-${Math.floor(Math.random() * 1000).toString().padStart(3, '0')}`;

        await Queue.create({
            appointmentId: appointment.id,
            serviceArea: serviceAreaMap[serviceCode] || 'General',
            ticketNumber,
            isCurrent: false,
            isCompleted: false
        });

        // Add to WaitingRoom for Monitoring View
        const waitingRoomService = new (require('../services/waiting-room.service').WaitingRoomService)();
        await waitingRoomService.addToWaitingRoom({
            patientId: appointment.patientId,
            appointmentId: appointment.id,
            priority: 'NORMAL', // Default priority
            notes: appointment.notes
        });

        res.json({ message: 'Check-in successful', ticketNumber });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to check-in' });
    }
};
