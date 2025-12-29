import { Request, Response } from 'express';
import { ServiceType } from '../models/service-type.model';

export const getServiceTypes = async (req: Request, res: Response) => {
    try {
        const serviceTypes = await ServiceType.findAll({
            where: { showPatient: true }
        });
        res.json(serviceTypes);
    } catch (error) {
        console.error('Error fetching service types:', error);
        res.status(500).json({ error: 'Failed to fetch service types' });
    }
};
