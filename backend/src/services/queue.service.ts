import { Queue } from '../models/queue.model';

export class QueueService {
    static async addToQueue(appointmentId: number, serviceArea: string) {
        // Logic to add to queue
        // Generate ticket number logic here
        const ticketNumber = 'C-' + Math.floor(Math.random() * 1000);
        return await Queue.create({
            appointmentId,
            serviceArea,
            ticketNumber
        });
    }

    static async getNext(serviceArea: string) {
        // Logic to get next patient
    }
}
