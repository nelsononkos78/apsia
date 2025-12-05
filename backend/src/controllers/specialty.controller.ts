import { Request, Response } from 'express';
import { Doctor, Specialty } from '../models/doctor.model';

export const getSpecialties = async (req: Request, res: Response) => {
    try {
        const specialties = Object.values(Specialty);
        res.json(specialties);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch specialties' });
    }
};

export const getDoctors = async (req: Request, res: Response) => {
    try {
        const { specialty } = req.query;
        const whereClause: any = { isAvailable: true };

        if (specialty) {
            whereClause.specialty = specialty;
        }

        const doctors = await Doctor.findAll({ where: whereClause });
        res.json(doctors);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch doctors' });
    }
};
