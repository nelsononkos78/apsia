import { Request, Response } from 'express';
import { getTvService } from '../services/tv.service';

export const getTvState = async (req: Request, res: Response) => {
    try {
        const tvService = getTvService();
        const state = await tvService.getTvState();
        res.json(state);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch TV state' });
    }
};
