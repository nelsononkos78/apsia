import { Appointment, AppointmentStatus, InternalStatus, ServiceTypeEnum } from '../models/appointment.model';
import { Recipe } from '../models/recipe.model';
import { Quote, QuoteStatus } from '../models/quote.model';
import { ProcedureOrder } from '../models/procedure-order.model';
import { Patient } from '../models/patient.model';

export class InternalFlowService {

    // 1. Doctor creates a recipe (Chemo)
    static async createRecipe(patientId: number, doctorId: number, content: string, suggestedDate: Date) {
        const recipe = await Recipe.create({
            patientId,
            doctorId,
            content,
            suggestedDate
        });

        // Create an appointment placeholder or update patient status?
        // For now, we just track the recipe. The appointment is created later or we create a placeholder appointment.
        // The guide says: "Estado inicial: Receta registrada" -> "Pendiente de cotización"

        // We might want to create a "Potential Appointment" or just track this via the Recipe/Quote flow until it's scheduled.
        // For simplicity, let's assume we create an Appointment with status SCHEDULED but internalStatus PENDING_QUOTE

        return recipe;
    }

    // 2. Pharmacy/Admin creates a quote based on Recipe or ProcedureOrder
    static async createQuote(patientId: number, items: any[], totalAmount: number, recipeId?: number, procedureOrderId?: number) {
        const quote = await Quote.create({
            patientId,
            items,
            totalAmount,
            status: QuoteStatus.PENDING
        });

        // Update related entities if needed
        if (recipeId) {
            const recipe = await Recipe.findByPk(recipeId);
            if (recipe) {
                // Logic to link quote to recipe if we had a foreign key, or just update status
            }
        }

        return quote;
    }

    // 3. Patient approves quote
    static async approveQuote(quoteId: number) {
        const quote = await Quote.findByPk(quoteId);
        if (!quote) throw new Error('Quote not found');

        quote.status = QuoteStatus.APPROVED;
        await quote.save();

        try {
            const { getWebSocketService } = require('./websocket.service');
            getWebSocketService().emitDashboardUpdate();
        } catch (error) {
            console.error('Error emitting dashboard update from internal flow:', error);
        }

        return quote;
    }

    // 4. Counter programs the final session
    static async programSession(patientId: number, doctorId: number, date: Date, serviceTypeId: number, resourceId: number) {
        // Verify if there is an approved quote? 
        // For now, allow creation.

        const appointment = await Appointment.create({
            patientId,
            doctorId,
            resourceId,
            dateTime: date,
            serviceTypeId,
            status: AppointmentStatus.SCHEDULED,
            internalStatus: InternalStatus.SESSION_PROGRAMMED
        });

        return appointment;
    }
}
