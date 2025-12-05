import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Doctor } from './doctor.model';
import { Resource } from './resource.model';

export enum AppointmentStatus {
    SCHEDULED = 'SCHEDULED',
    CHECKED_IN = 'CHECKED_IN',
    IN_PROGRESS = 'IN_PROGRESS',
    COMPLETED = 'COMPLETED',
    CANCELLED = 'CANCELLED',
    NO_SHOW = 'NO_SHOW'
}

export enum ServiceType {
    CONSULTATION = 'CONSULTATION',
    LABORATORY = 'LABORATORY',
    CHEMOTHERAPY = 'CHEMOTHERAPY',
    RECOVERY = 'RECOVERY'
}

@Table({ tableName: 'appointments' })
export class Appointment extends Model {
    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: false })
    patientId!: number;

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

    @Column({ type: DataType.DATE, allowNull: false })
    dateTime!: Date;

    @Column({ type: DataType.ENUM(...Object.values(ServiceType)), allowNull: false })
    serviceType!: ServiceType;

    @Column({ type: DataType.ENUM(...Object.values(AppointmentStatus)), defaultValue: AppointmentStatus.SCHEDULED })
    status!: AppointmentStatus;

    @Column({ type: DataType.STRING })
    specialty!: string;

    @Column({ type: DataType.TEXT })
    notes!: string;

    @Column({ type: DataType.STRING })
    phoneNumber!: string;

    @Column({ type: DataType.STRING })
    emergencyContact!: string;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
