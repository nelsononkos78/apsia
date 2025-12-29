import { Request, Response } from 'express';
import { InternalFlowService } from '../services/internal-flow.service';
import { ServiceTypeEnum } from '../models/appointment.model';

export class InternalFlowController {

    // POST /internal/recipe
    static async createRecipe(req: Request, res: Response) {
        try {
            const { patientId, doctorId, content, suggestedDate } = req.body;
            const recipe = await InternalFlowService.createRecipe(patientId, doctorId, content, suggestedDate);
            res.status(201).json(recipe);
        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }

    // POST /internal/quote
    static async createQuote(req: Request, res: Response) {
        try {
            const { patientId, items, totalAmount, recipeId, procedureOrderId } = req.body;
            const quote = await InternalFlowService.createQuote(patientId, items, totalAmount, recipeId, procedureOrderId);
            res.status(201).json(quote);
        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }

    // POST /internal/approve-quote
    static async approveQuote(req: Request, res: Response) {
        try {
            const { quoteId } = req.body;
            const quote = await InternalFlowService.approveQuote(quoteId);
            res.status(200).json(quote);
        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }

    // POST /internal/program-session
    static async programSession(req: Request, res: Response) {
        try {
            const { patientId, doctorId, date, serviceTypeId, resourceId } = req.body;

            const appointment = await InternalFlowService.programSession(patientId, doctorId, date, serviceTypeId, resourceId);
            res.status(201).json(appointment);
        } catch (error: any) {
            res.status(500).json({ message: error.message });
        }
    }
}
