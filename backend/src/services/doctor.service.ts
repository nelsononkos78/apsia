import { Doctor } from '../models/doctor.model';
import { Resource, ResourceStatus } from '../models/resource.model';
import { WaitingRoom, WaitingRoomStatus } from '../models/waiting-room.model';
import { Appointment, AppointmentStatus } from '../models/appointment.model';
import { Patient } from '../models/patient.model';
import { ServiceType } from '../models/service-type.model';
import { Queue } from '../models/queue.model';
import { getWebSocketService } from './websocket.service';
import { getTvService } from './tv.service';
import { Op } from 'sequelize';

export class DoctorService {

    async getDoctorByEmail(email: string): Promise<Doctor | null> {
        return await Doctor.findOne({ where: { email } });
    }

    async getDashboardData(email: string) {
        const doctor = await this.getDoctorByEmail(email);
        if (!doctor) {
            throw new Error('Doctor not found for this user');
        }

        // Get assigned resource (Consultorio)
        const resource = await Resource.findOne({
            where: { doctorId: doctor.id },
            include: [
                { model: Patient, as: 'currentPatient' },
                { model: Doctor, as: 'doctor' }
            ]
        });

        // Get waiting list for this doctor (appointments scheduled for today that are checked in)
        // Or just all checked in patients if no specific doctor assignment logic in waiting room yet
        // For now, let's assume we fetch patients waiting for this doctor's specialty or explicitly assigned

        // Simple logic: Fetch all waiting patients for now, or filter by doctor if appointment has it
        const waitingList = await WaitingRoom.findAll({
            where: {
                status: WaitingRoomStatus.ESPERANDO
            },
            include: [
                { model: Patient },
                {
                    model: Appointment,
                    where: {
                        [Op.and]: [
                            {
                                [Op.or]: [
                                    { doctorId: doctor.id },
                                    { doctorId: null }
                                ]
                            },
                            {
                                triajeCompleted: true
                            }
                        ]
                    },
                    include: [{ model: ServiceType, as: 'serviceType' }],
                    required: true
                }
            ],
            order: [['priority', 'DESC'], ['checkInTime', 'ASC']]
        });

        let currentAppointment = null;
        if (resource?.currentAppointmentId) {
            currentAppointment = await Appointment.findByPk(resource.currentAppointmentId, {
                include: [{ model: ServiceType, as: 'serviceType' }]
            });
        } else if (resource?.currentPatientId) {
            // Fallback for older data or if currentAppointmentId is missing
            currentAppointment = await Appointment.findOne({
                where: {
                    patientId: resource.currentPatientId,
                    status: {
                        [Op.notIn]: [AppointmentStatus.COMPLETED, AppointmentStatus.CANCELLED]
                    }
                },
                include: [{ model: ServiceType, as: 'serviceType' }],
                order: [['dateTime', 'DESC']]
            });
        }

        // Get count of attended patients today
        const attendedCount = await Appointment.count({
            where: {
                doctorId: doctor.id,
                status: AppointmentStatus.COMPLETED,
                dateTime: {
                    [Op.gte]: new Date(new Date().setHours(0, 0, 0, 0)),
                    [Op.lte]: new Date(new Date().setHours(23, 59, 59, 999))
                }
            }
        });

        // Get count of patients pending triaje for this doctor
        const pendingTriajeCount = await WaitingRoom.count({
            where: {
                status: WaitingRoomStatus.ESPERANDO
            },
            include: [
                {
                    model: Appointment,
                    where: {
                        [Op.and]: [
                            {
                                [Op.or]: [
                                    { doctorId: doctor.id },
                                    { doctorId: null }
                                ]
                            },
                            {
                                triajeCompleted: false
                            }
                        ]
                    },
                    required: true
                }
            ]
        });

        return {
            doctor,
            resource,
            waitingList,
            currentAppointment,
            attendedCount,
            pendingTriajeCount
        };
    }

    async callPatient(doctorId: number, waitingRoomId: number) {
        const waitingRoomEntry = await WaitingRoom.findByPk(waitingRoomId, {
            include: [
                Patient,
                {
                    model: Appointment,
                    include: [Queue]
                }
            ]
        });

        if (!waitingRoomEntry) {
            throw new Error('Waiting room entry not found');
        }

        const resource = await Resource.findOne({ where: { doctorId } });
        if (!resource) {
            throw new Error('No consulting room assigned to this doctor');
        }

        // Update Waiting Room
        waitingRoomEntry.status = WaitingRoomStatus.LLAMADO;
        await waitingRoomEntry.save();

        // Update Queue status
        if (waitingRoomEntry.appointmentId) {
            // Set all other items as not current
            await Queue.update({ isCurrent: false }, { where: { isCompleted: false } });

            // Set this item as current and update serviceArea
            await Queue.update(
                {
                    isCurrent: true,
                    serviceArea: resource.name
                },
                { where: { appointmentId: waitingRoomEntry.appointmentId } }
            );

            // Link appointment to resource and doctor
            await Appointment.update(
                {
                    resourceId: resource.id,
                    doctorId: doctorId // Assign doctor if not already assigned
                },
                { where: { id: waitingRoomEntry.appointmentId } }
            );

            // Update the instance in memory so the emitted JSON has the resourceId
            if (waitingRoomEntry.appointment) {
                waitingRoomEntry.appointment.resourceId = resource.id;
            }
        }

        // Update Resource
        resource.currentPatientId = waitingRoomEntry.patientId;
        resource.currentAppointmentId = waitingRoomEntry.appointmentId;
        resource.currentOccupancy = 1;
        resource.status = ResourceStatus.OCUPADO;
        await resource.save();

        // Emit Socket Event for TV
        const wsService = getWebSocketService();
        const ticketNumber = waitingRoomEntry.appointment?.queue?.ticketNumber || `T-${waitingRoomEntry.id}`;

        wsService.emitToTv({
            patientName: `${waitingRoomEntry.patient.firstName} ${waitingRoomEntry.patient.lastName}`,
            patient: `${waitingRoomEntry.patient.firstName} ${waitingRoomEntry.patient.lastName}`, // Compatibility
            ticketNumber: ticketNumber,
            ticket: ticketNumber, // Compatibility
            destination: resource.name,
            doctorName: (await Doctor.findByPk(doctorId))?.name
        });

        // Broadcast TV state to update waiting list on TV
        await getTvService().broadcastTvState();

        // Also emit resource update
        const resourceWithData = await Resource.findByPk(resource.id, {
            include: [
                { model: Patient, as: 'currentPatient' },
                {
                    model: Doctor,
                    as: 'doctor',
                    include: ['schedules']
                }
            ]
        });

        if (resourceWithData) {
            wsService.emitResourceUpdate(resourceWithData.toJSON());
        }
        wsService.emitWaitingRoomUpdate(waitingRoomEntry.toJSON());

        return { success: true, message: 'Patient called' };
    }

    async startConsultation(doctorId: number, appointmentId: number) {
        const appointment = await Appointment.findByPk(appointmentId, {
            include: [
                { model: Patient, as: 'patient' },
                { model: Doctor, as: 'doctor' },
                { model: ServiceType, as: 'serviceType' }
            ]
        });
        if (!appointment) {
            throw new Error('Appointment not found');
        }

        appointment.status = AppointmentStatus.IN_PROGRESS;
        appointment.startTime = new Date();

        // Ensure resourceId is set if not already
        if (!appointment.resourceId) {
            const resource = await Resource.findOne({ where: { doctorId } });
            if (resource) {
                appointment.resourceId = resource.id;
            }
        }

        await appointment.save();

        // Update waiting room to ATENDIDO if linked
        const waitingEntry = await WaitingRoom.findOne({ where: { appointmentId } });
        if (waitingEntry) {
            waitingEntry.status = WaitingRoomStatus.ATENDIDO;
            await waitingEntry.save();
            getWebSocketService().emitWaitingRoomUpdate(waitingEntry.toJSON());
        }

        // Update resource status if linked
        if (appointment.resourceId) {
            const resource = await Resource.findByPk(appointment.resourceId);
            if (resource) {
                resource.status = ResourceStatus.OCUPADO;
                resource.currentPatientId = appointment.patientId;
                resource.doctorId = appointment.doctorId;
                resource.currentOccupancy = 1;
                await resource.save();

                // Emit resource update with associations
                const resourceWithAssoc = await Resource.findByPk(resource.id, {
                    include: [
                        { model: Patient, as: 'currentPatient' },
                        { model: Doctor, as: 'doctor' }
                    ]
                });
                if (resourceWithAssoc) {
                    getWebSocketService().emitResourceUpdate(resourceWithAssoc.toJSON());
                }
            }
        }

        getWebSocketService().emitAppointmentUpdate(appointment.toJSON());

        return appointment;
    }

    async finishConsultation(doctorId: number, appointmentId: number) {
        const appointment = await Appointment.findByPk(appointmentId);
        if (!appointment) {
            throw new Error('Appointment not found');
        }

        appointment.status = AppointmentStatus.COMPLETED;
        await appointment.save();

        // Update Queue status
        await Queue.update(
            { isCompleted: true, isCurrent: false },
            { where: { appointmentId } }
        );

        // Free the resource
        const resource = await Resource.findOne({ where: { doctorId } });
        if (resource) {
            resource.currentPatientId = null;
            resource.currentOccupancy = 0;
            resource.status = ResourceStatus.DISPONIBLE;
            await resource.save();

            // Reload with associations for complete data (includes doctor info)
            const resourceWithData = await Resource.findByPk(resource.id, {
                include: [
                    { model: Patient, as: 'currentPatient' },
                    {
                        model: Doctor,
                        as: 'doctor',
                        include: ['schedules']
                    }
                ]
            });

            if (resourceWithData) {
                getWebSocketService().emitResourceUpdate(resourceWithData.toJSON());
            }
        }

        // Broadcast TV state to update TV display
        await getTvService().broadcastTvState();

        getWebSocketService().emitAppointmentUpdate(appointment.toJSON());

        return appointment;
    }
}
