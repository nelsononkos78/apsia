import { Request, Response } from 'express';
import { Doctor } from '../models/doctor.model';
import { Specialty } from '../models/specialty.model';
import { DoctorSchedule } from '../models/doctor-schedule.model';

export const getSpecialties = async (req: Request, res: Response) => {
    try {
        const specialties = await Specialty.findAll({
            include: [{
                model: Doctor,
                where: { status: 'activo' },
                required: true // This ensures only specialties with at least one active doctor are returned
            }]
        });
        // Return array of names to match frontend expectation
        res.json(specialties.map(s => s.name));
    } catch (error) {
        console.error('Error fetching specialties:', error);
        res.status(500).json({ error: 'Failed to fetch specialties' });
    }
};

export const getDoctors = async (req: Request, res: Response) => {
    try {
        const { specialty } = req.query;
        const whereClause: any = { status: 'activo' }; // Match DB value 'activo'
        const includeClause: any[] = [
            { model: Specialty },
            { model: DoctorSchedule, where: { isActive: true }, required: false }
        ];

        if (specialty) {
            // Filter by specialty name via association
            includeClause[0].where = { name: specialty };
        }

        const doctors = await Doctor.findAll({
            where: whereClause,
            include: includeClause
        });
        res.json(doctors);
    } catch (error) {
        console.error('Error fetching doctors:', error);
        res.status(500).json({ error: 'Failed to fetch doctors' });
    }
};
