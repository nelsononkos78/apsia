import { Request, Response } from 'express';
import { Queue } from '../models/queue.model';

export const getQueue = async (req: Request, res: Response) => {
    try {
        const queue = await Queue.findAll({ where: { isCompleted: false } });
        res.json(queue);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch queue' });
    }
};

export const nextPatient = async (req: Request, res: Response) => {
    // Logic to call next patient
    res.json({ message: 'Next patient called' });
};
