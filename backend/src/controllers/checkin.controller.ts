import { Request, Response } from 'express';
import { Patient } from '../models/patient.model';
import { Appointment, AppointmentStatus, ServiceTypeEnum } from '../models/appointment.model';
import { ServiceType as ServiceTypeModel } from '../models/service-type.model';
import { Queue } from '../models/queue.model';
import { Op } from 'sequelize';

export class CheckinController {

    // GET /api/checkin/search?dni=12345678
    static async searchPatient(req: Request, res: Response) {
        try {
            const { dni } = req.query;
            if (!dni) return res.status(400).json({ message: 'DNI is required' });

            let patient = await Patient.findOne({ where: { dni: dni as string } });

            if (!patient) {
                return res.status(404).json({ message: 'Patient not found', found: false });
            }

            // Generate medical record number if it doesn't exist
            let medicalRecordNumberGenerated = false;
            if (!patient.medicalRecordNumber && patient.documentNumber) {
                patient.medicalRecordNumber = Patient.generateMedicalRecordNumber(patient.documentNumber);
                await patient.save();
                medicalRecordNumberGenerated = true;
                console.log(`✅ Medical record number generated: ${patient.medicalRecordNumber}`);
            }

            // Check for existing appointments today
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);

            const appointments = await Appointment.findAll({
                where: {
                    patientId: patient.id,
                    dateTime: {
                        [Op.gte]: today,
                        [Op.lt]: tomorrow
                    }
                }
            });

            res.json({
                found: true,
                patient,
                appointments,
                hasOncCode: !!patient.onc_dni,
                hasSsgCode: !!patient.ssg_dni,
                medicalRecordNumber: patient.medicalRecordNumber,
                medicalRecordNumberGenerated
            });

        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }

    // POST /api/checkin/register
    static async registerPatient(req: Request, res: Response) {
        try {
            const { firstName, lastName, documentId, birthDate, phone, email, address } = req.body;

            // Check if exists
            let patient = await Patient.findOne({ where: { dni: documentId } });
            if (patient) {
                return res.status(400).json({ message: 'Patient already exists' });
            }

            patient = await Patient.create({
                name: `${firstName} ${lastName}`,
                dni: documentId,
                birthDate,
                phone,
                email
                // address not in model yet, ignoring for now or add to model
            });

            res.status(201).json(patient);
        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }

    // POST /api/checkin/create-ticket
    static async createTicket(req: Request, res: Response) {
        try {
            const { patientId, serviceTypeId, doctorId } = req.body;

            const patient = await Patient.findByPk(patientId);
            if (!patient) return res.status(404).json({ message: 'Patient not found' });

            // Generate medical record number if it doesn't exist
            if (!patient.medicalRecordNumber && patient.documentNumber) {
                patient.medicalRecordNumber = Patient.generateMedicalRecordNumber(patient.documentNumber);
                await patient.save();
                console.log(`✅ Medical record number generated during check-in: ${patient.medicalRecordNumber}`);
            }

            const serviceType = await ServiceTypeModel.findByPk(serviceTypeId);
            if (!serviceType) return res.status(404).json({ message: 'Service type not found' });

            // Generate Code if needed
            if (serviceType.code !== ServiceTypeEnum.GENERAL_HEALTH) {
                if (!patient.onc_dni) {
                    patient.onc_dni = `ONC-${patient.dni}`;
                    await patient.save();
                }
            } else if (serviceType.code === ServiceTypeEnum.GENERAL_HEALTH) {
                if (!patient.ssg_dni) {
                    patient.ssg_dni = `SSG-${patient.dni}`;
                    await patient.save();
                }
            }

            // Create Appointment (Walk-in or confirm existing?)
            // If walk-in (Consulta Nueva/SSG), create appointment.
            // If scheduled (Chemo/Proc), find existing?
            // For simplicity, we create a "Checked In" appointment for the queue.

            const appointment = await Appointment.create({
                patientId,
                doctorId: doctorId || null,
                dateTime: new Date(),
                serviceTypeId,
                status: AppointmentStatus.CHECKED_IN,
                notes: 'Walk-in / Check-in',
                // Auto-mark triajeCompleted for services that don't require triage
                // Only CONSULTATION_NEW requires triage
                triajeCompleted: serviceType.code !== ServiceTypeEnum.CONSULTATION_NEW
            });

            const prefix = serviceType.code ? serviceType.code.substring(0, 2) : 'X';
            const count = await Queue.count() + 1;
            const ticketNumber = `${prefix}-${String(count).padStart(3, '0')}`;

            // Add to Queue
            const queueItem = await Queue.create({
                appointmentId: appointment.id,
                ticketNumber,
                serviceArea: serviceType.name,
                isCurrent: false,
                isCompleted: false
            });

            // Add to WaitingRoom for Monitoring and TV
            const waitingRoomService = new (require('../services/waiting-room.service').WaitingRoomService)();
            await waitingRoomService.addToWaitingRoom({
                patientId,
                appointmentId: appointment.id,
                priority: 'NORMAL',
                notes: 'Check-in via ticket'
            });

            res.status(201).json({
                ticketNumber,
                patientName: patient.name,
                service: serviceType.name,
                medicalRecordNumber: patient.medicalRecordNumber
            });

        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }
}
