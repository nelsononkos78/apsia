import { ResourceService } from './resource.service';
import { WaitingRoomService } from './waiting-room.service';
import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { Resource, ResourceType } from '../models/resource.model';
import { Op } from 'sequelize';

export class MonitoringService {
    private resourceService: ResourceService;
    private waitingRoomService: WaitingRoomService;

    constructor() {
        this.resourceService = new ResourceService();
        this.waitingRoomService = new WaitingRoomService();
    }

    /**
     * Obtener snapshot completo del sistema para una fecha específica
     */
    async getMonitoringSnapshot(date: Date) {
        const startOfDay = new Date(date);
        startOfDay.setHours(0, 0, 0, 0);

        const endOfDay = new Date(date);
        endOfDay.setHours(23, 59, 59, 999);

        // Obtener todos los recursos
        const resources = await this.resourceService.getAllResources();

        // Obtener citas del día
        const appointments = await Appointment.findAll({
            where: {
                dateTime: {
                    [Op.between]: [startOfDay, endOfDay]
                }
            },
            include: ['patient', 'doctor', 'resource'],
            order: [['dateTime', 'ASC']]
        });

        // Obtener sala de espera
        const waitingRoom = await this.waitingRoomService.getCurrentWaitingList();

        // Estadísticas de recursos
        const resourceStats = await this.resourceService.getResourceStatistics();

        // Estadísticas de sala de espera
        const waitingRoomStats = await this.waitingRoomService.getWaitingRoomStatistics();

        return {
            date: date.toISOString(),
            resources: {
                all: resources,
                byType: {
                    consultorios: resources.filter(r => r.type === ResourceType.CONSULTORIO),
                    tratamientos: resources.filter(r => r.type === ResourceType.TRATAMIENTO),
                    estancias: resources.filter(r => r.type === ResourceType.ESTANCIA)
                },
                statistics: resourceStats
            },
            appointments: {
                total: appointments.length,
                byStatus: {
                    scheduled: appointments.filter(a => a.status === AppointmentStatus.SCHEDULED).length,
                    checkedIn: appointments.filter(a => a.status === AppointmentStatus.CHECKED_IN).length,
                    inProgress: appointments.filter(a => a.status === AppointmentStatus.IN_PROGRESS).length,
                    completed: appointments.filter(a => a.status === AppointmentStatus.COMPLETED).length,
                    cancelled: appointments.filter(a => a.status === AppointmentStatus.CANCELLED).length,
                    noShow: appointments.filter(a => a.status === AppointmentStatus.NO_SHOW).length
                },
                list: appointments
            },
            waitingRoom: {
                current: waitingRoom,
                statistics: waitingRoomStats,
                averageWaitTime: await this.waitingRoomService.getAverageWaitTime()
            }
        };
    }

    /**
     * Obtener ocupación de un recurso específico para una fecha
     */
    async getResourceOccupancy(resourceId: number, date: Date) {
        const startOfDay = new Date(date);
        startOfDay.setHours(0, 0, 0, 0);

        const endOfDay = new Date(date);
        endOfDay.setHours(23, 59, 59, 999);

        const resource = await this.resourceService.getResourceById(resourceId);
        if (!resource) {
            throw new Error('Recurso no encontrado');
        }

        const appointments = await Appointment.findAll({
            where: {
                resourceId,
                dateTime: {
                    [Op.between]: [startOfDay, endOfDay]
                }
            },
            include: ['patient'],
            order: [['dateTime', 'ASC']]
        });

        return {
            resource,
            date: date.toISOString(),
            appointments,
            occupancyRate: (appointments.length / 24) * 100, // Asumiendo 24 slots por día
            isFullyBooked: appointments.length >= 24
        };
    }

    /**
     * Obtener estadísticas diarias
     */
    async getDailyStatistics(date: Date) {
        const startOfDay = new Date(date);
        startOfDay.setHours(0, 0, 0, 0);

        const endOfDay = new Date(date);
        endOfDay.setHours(23, 59, 59, 999);

        const appointments = await Appointment.findAll({
            where: {
                dateTime: {
                    [Op.between]: [startOfDay, endOfDay]
                }
            }
        });

        const resourceStats = await this.resourceService.getResourceStatistics();
        const waitingRoomStats = await this.waitingRoomService.getWaitingRoomStatistics();

        return {
            date: date.toISOString(),
            appointments: {
                total: appointments.length,
                completed: appointments.filter(a => a.status === AppointmentStatus.COMPLETED).length,
                cancelled: appointments.filter(a => a.status === AppointmentStatus.CANCELLED).length,
                noShow: appointments.filter(a => a.status === AppointmentStatus.NO_SHOW).length,
                pending: appointments.filter(a =>
                    a.status === AppointmentStatus.SCHEDULED ||
                    a.status === AppointmentStatus.CHECKED_IN ||
                    a.status === AppointmentStatus.IN_PROGRESS
                ).length
            },
            resources: resourceStats,
            waitingRoom: waitingRoomStats,
            averageWaitTime: await this.waitingRoomService.getAverageWaitTime()
        };
    }

    /**
     * Verificar disponibilidad de recursos para una fecha
     */
    async checkResourceAvailability(date: Date) {
        const startOfDay = new Date(date);
        startOfDay.setHours(0, 0, 0, 0);

        const endOfDay = new Date(date);
        endOfDay.setHours(23, 59, 59, 999);

        const allResources = await this.resourceService.getAllResources();

        const availability = await Promise.all(
            allResources.map(async (resource) => {
                const appointments = await Appointment.count({
                    where: {
                        resourceId: resource.id,
                        dateTime: {
                            [Op.between]: [startOfDay, endOfDay]
                        }
                    }
                });

                return {
                    resourceId: resource.id,
                    resourceName: resource.name,
                    resourceType: resource.type,
                    status: resource.status,
                    appointmentsCount: appointments,
                    availableSlots: Math.max(0, 24 - appointments),
                    isFullyBooked: appointments >= 24
                };
            })
        );

        return availability;
    }
}
