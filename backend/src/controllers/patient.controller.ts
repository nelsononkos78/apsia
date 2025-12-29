import { Request, Response } from 'express';
import { Patient } from '../models/patient.model';

export const getPatients = async (req: Request, res: Response) => {
    try {
        const { documentId } = req.query;
        // Map documentId query param to documentNumber model field
        const whereClause = documentId ? { documentNumber: documentId as string } : {};
        const patients = await Patient.findAll({ where: whereClause });
        res.json(patients);
    } catch (error) {
        console.error('Error fetching patients:', error);
        res.status(500).json({ error: 'Failed to fetch patients' });
    }
};

export const createPatient = async (req: Request, res: Response) => {
    try {
        const patient = await Patient.create(req.body);
        res.status(201).json(patient);
    } catch (error) {
        res.status(500).json({ error: 'Failed to create patient' });
    }
};
