import { Table, Column, Model, DataType, ForeignKey, BelongsTo, HasOne, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Doctor } from './doctor.model';
import { Resource } from './resource.model';
import { ServiceType as ServiceTypeModel } from './service-type.model';
import { Queue } from './queue.model';

export enum AppointmentStatus {
    SCHEDULED = 'SCHEDULED',
    CHECKED_IN = 'CHECKED_IN',
    IN_PROGRESS = 'IN_PROGRESS',
    COMPLETED = 'COMPLETED',
    CANCELLED = 'CANCELLED',
    NO_SHOW = 'NO_SHOW'
}

export enum ServiceTypeEnum {
    CONSULTATION_NEW = 'CONSULTATION_NEW',
    CONSULTATION_FOLLOWUP = 'CONSULTATION_FOLLOWUP',
    CHEMOTHERAPY = 'CHEMOTHERAPY',
    PROCEDURE = 'PROCEDURE',
    LABORATORY_ONCO = 'LABORATORY_ONCO',
    ULTRASOUND_ONCO = 'ULTRASOUND_ONCO',
    RECOVERY = 'RECOVERY',
    EMERGENCY_ONCO = 'EMERGENCY_ONCO',
    GENERAL_HEALTH = 'GENERAL_HEALTH'
}

export enum InternalStatus {
    NONE = 'NONE',
    RECIPE_REGISTERED = 'RECIPE_REGISTERED',
    PENDING_QUOTE = 'PENDING_QUOTE',
    QUOTE_READY = 'QUOTE_READY',
    QUOTE_WITH_STOCK = 'QUOTE_WITH_STOCK',
    QUOTE_SENT = 'QUOTE_SENT',
    QUOTE_APPROVED = 'QUOTE_APPROVED',
    SESSION_PROGRAMMED = 'SESSION_PROGRAMMED'
}

@Table({ tableName: 'appointments' })
export class Appointment extends Model {
    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: true })
    patientId!: number | null;

    @BelongsTo(() => Patient)
    patient!: Patient;

    @ForeignKey(() => Doctor)
    @Column({ type: DataType.INTEGER, allowNull: true })
    doctorId!: number | null;

    @BelongsTo(() => Doctor)
    doctor!: Doctor | null;

    @ForeignKey(() => Resource)
    @Column({ type: DataType.INTEGER, allowNull: true })
    resourceId!: number | null;

    @BelongsTo(() => Resource)
    resource!: Resource | null;

    @ForeignKey(() => ServiceTypeModel)
    @Column({ type: DataType.INTEGER, allowNull: false })
    serviceTypeId!: number;

    @BelongsTo(() => ServiceTypeModel)
    serviceType!: ServiceTypeModel;

    @Column({ type: DataType.DATE, allowNull: false })
    dateTime!: Date;

    @Column({ type: DataType.ENUM(...Object.values(InternalStatus)), defaultValue: InternalStatus.NONE })
    internalStatus!: InternalStatus;

    @Column({ type: DataType.ENUM(...Object.values(AppointmentStatus)), defaultValue: AppointmentStatus.SCHEDULED })
    status!: AppointmentStatus;

    @Column({ type: DataType.STRING })
    specialty!: string;

    @Column({ type: DataType.TEXT })
    notes!: string;

    @Column({ type: DataType.STRING })
    contactName!: string;

    @Column({ type: DataType.DATE })
    checkinTime!: Date | null;

    @Column({ type: DataType.DATE })
    startTime!: Date | null;

    @Column({ type: DataType.STRING })
    phoneNumber!: string;

    @Column({ type: DataType.STRING })
    emergencyContact!: string;

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    triajeCompleted!: boolean;

    @HasOne(() => Queue)
    queue!: Queue;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
