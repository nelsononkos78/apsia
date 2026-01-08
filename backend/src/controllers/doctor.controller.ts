import { Request, Response } from 'express';
import { DoctorService } from '../services/doctor.service';

const doctorService = new DoctorService();

export class DoctorController {

    async getDashboardData(req: Request, res: Response) {
        try {
            // Assuming auth middleware populates req.user with email
            // For now, we might need to pass email in query or body if auth isn't fully set up with user object
            // But let's assume standard req.user or pass email for testing
            const email = req.query.email as string || req.body.email;

            if (!email) {
                return res.status(400).json({ error: 'Email is required' });
            }

            const data = await doctorService.getDashboardData(email);
            res.json(data);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async callPatient(req: Request, res: Response) {
        try {
            const { doctorId, waitingRoomId } = req.body;
            if (!doctorId || !waitingRoomId) {
                return res.status(400).json({ error: 'Doctor ID and Waiting Room ID are required' });
            }

            const result = await doctorService.callPatient(doctorId, waitingRoomId);
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async startConsultation(req: Request, res: Response) {
        try {
            const { doctorId, appointmentId } = req.body;
            if (!doctorId || !appointmentId) {
                return res.status(400).json({ error: 'Doctor ID and Appointment ID are required' });
            }

            const result = await doctorService.startConsultation(doctorId, appointmentId);
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async finishConsultation(req: Request, res: Response) {
        try {
            const { doctorId, appointmentId, medicalRecord } = req.body;
            if (!doctorId || !appointmentId) {
                return res.status(400).json({ error: 'Doctor ID and Appointment ID are required' });
            }

            const result = await doctorService.finishConsultation(doctorId, appointmentId, medicalRecord);
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }
}
