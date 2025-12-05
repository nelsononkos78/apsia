import { Request, Response } from 'express';
import { Queue } from '../models/queue.model';

export const getTvState = async (req: Request, res: Response) => {
    try {
        // Get current called patient and upcoming list
        const current = await Queue.findOne({ where: { isCurrent: true } });
        const upcoming = await Queue.findAll({ where: { isCurrent: false, isCompleted: false }, limit: 5 });
        res.json({ current, upcoming });
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch TV state' });
    }
};
