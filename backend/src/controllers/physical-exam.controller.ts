import { Request, Response } from 'express';
import { PhysicalExamService } from '../services/physical-exam.service';

const physicalExamService = new PhysicalExamService();

export class PhysicalExamController {
    async savePhysicalExam(req: Request, res: Response) {
        try {
            const data = req.body;
            const result = await physicalExamService.createOrUpdatePhysicalExam(data);
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async getPhysicalExam(req: Request, res: Response) {
        try {
            const { appointmentId } = req.params;
            const result = await physicalExamService.getPhysicalExamByAppointment(parseInt(appointmentId));
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async getPatientAllergies(req: Request, res: Response) {
        try {
            const { patientId } = req.params;
            const result = await physicalExamService.getPatientAllergies(parseInt(patientId));
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async addAllergy(req: Request, res: Response) {
        try {
            const data = req.body;
            const result = await physicalExamService.addAllergy(data);
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }

    async removeAllergy(req: Request, res: Response) {
        try {
            const { id } = req.params;
            const result = await physicalExamService.removeAllergy(parseInt(id));
            res.json(result);
        } catch (error: any) {
            res.status(500).json({ error: error.message });
        }
    }
}
