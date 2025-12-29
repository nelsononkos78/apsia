import { Queue } from '../models/queue.model';
import { Appointment, ServiceTypeEnum } from '../models/appointment.model';
import { Patient } from '../models/patient.model';
import { Doctor } from '../models/doctor.model';
import { WaitingRoom, WaitingRoomStatus } from '../models/waiting-room.model';
import { Resource } from '../models/resource.model';
import { getWebSocketService } from './websocket.service';
import { Op } from 'sequelize';

export class TvService {
    async getTvState() {
        // Get all active queue items
        // Get all active queue items + recently completed (last 5 mins)
        const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
        const queueItems = await Queue.findAll({
            where: {
                [Op.or]: [
                    { isCompleted: false },
                    {
                        isCompleted: true,
                        updatedAt: { [Op.gte]: fiveMinutesAgo }
                    }
                ]
            },
            include: [
                {
                    model: Appointment,
                    include: [Patient, Doctor]
                }
            ],
            order: [['updatedAt', 'DESC']]
        });

        // 1. Determine "Turno Actual" (The most recently called/updated item that isCurrent=true)
        const currentCall = queueItems.find(item => item.isCurrent);

        // Determine specific area name (e.g., Consultorio 1)
        let currentAreaName = currentCall ? this.formatServiceName(currentCall.serviceArea) : '';

        if (currentCall && currentCall.appointment?.doctorId) {
            const resource = await Resource.findOne({
                where: { doctorId: currentCall.appointment.doctorId }
            });
            if (resource) {
                currentAreaName = resource.name;
            }
        }

        // 2. Get Waiting Room Patients (those physically in the clinic but not yet called)
        const waitingRoomItems = await WaitingRoom.findAll({
            where: { status: WaitingRoomStatus.ESPERANDO },
            include: [
                Patient,
                {
                    model: Appointment,
                    include: [Queue]
                }
            ],
            order: [['priority', 'DESC'], ['checkInTime', 'ASC']]
        });

        // 2. Group by Area (Dynamic grouping)
        const areasMap: Record<string, any[]> = {};

        queueItems.forEach(item => {
            const serviceType = item.serviceArea;
            if (!areasMap[serviceType]) {
                areasMap[serviceType] = [];
            }

            areasMap[serviceType].push({
                ticket: item.ticketNumber,
                patient: item.appointment?.patient ? `${item.appointment.patient.firstName.charAt(0)}. ${item.appointment.patient.lastName.split(' ')[0]}.` : 'Anon',
                status: item.isCurrent ? 'En Atención' : (item.isCompleted ? 'Atendido' : 'Espera')
            });
        });

        // Filter out empty areas
        const activeAreas = Object.entries(areasMap)
            .filter(([_, items]) => items.length > 0)
            .map(([name, items]) => ({
                name: this.formatServiceName(name),
                items
            }));

        return {
            currentCall: currentCall ? {
                ticket: currentCall.ticketNumber,
                area: currentAreaName,
                patient: currentCall.appointment?.patient ? `${currentCall.appointment.patient.firstName} ${currentCall.appointment.patient.lastName}` : '',
                updatedAt: currentCall.updatedAt
            } : null,
            activeAreas,
            waitingRoom: waitingRoomItems.map(item => {
                const patientName = item.patient
                    ? `${item.patient.firstName} ${item.patient.lastName}`.toLowerCase().replace(/\b\w/g, l => l.toUpperCase())
                    : 'Anon';

                return {
                    id: item.id,
                    patient: patientName,
                    ticket: item.appointment?.queue?.ticketNumber || '---',
                    checkInTime: item.checkInTime,
                    priority: item.priority
                };
            })
        };
    }

    async broadcastTvState() {
        try {
            const state = await this.getTvState();
            const wsService = getWebSocketService();
            wsService.emitTvStateUpdate(state);
        } catch (error) {
            console.error('Error broadcasting TV state:', error);
        }
    }

    private formatServiceName(type: string): string {
        const map: Record<string, string> = {
            [ServiceTypeEnum.CONSULTATION_NEW]: 'Consultorio',
            [ServiceTypeEnum.CONSULTATION_FOLLOWUP]: 'Consultorio',
            [ServiceTypeEnum.CHEMOTHERAPY]: 'Quimioterapia',
            [ServiceTypeEnum.PROCEDURE]: 'Procedimientos',
            [ServiceTypeEnum.LABORATORY_ONCO]: 'Lab. Oncológico',
            [ServiceTypeEnum.ULTRASOUND_ONCO]: 'Ecografía',
            [ServiceTypeEnum.RECOVERY]: 'Recuperación',
            [ServiceTypeEnum.EMERGENCY_ONCO]: 'Urgencias',
            [ServiceTypeEnum.GENERAL_HEALTH]: 'Atención General'
        };
        return map[type] || type;
    }
}

let tvService: TvService | null = null;

export function getTvService(): TvService {
    if (!tvService) {
        tvService = new TvService();
    }
    return tvService;
}
