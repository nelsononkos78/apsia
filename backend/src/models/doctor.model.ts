import { Table, Column, Model, DataType, HasMany, CreatedAt, UpdatedAt, ForeignKey, BelongsTo } from 'sequelize-typescript';
import { Appointment } from './appointment.model';
import { Specialty } from './specialty.model';
import { MedicalCenter } from './medical-center.model';
import { DoctorSchedule } from './doctor-schedule.model';

@Table({ tableName: 'doctors', timestamps: false })
export class Doctor extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string;

    @Column({ type: DataType.STRING, allowNull: false, unique: true })
    dni!: string;

    @Column({ type: DataType.STRING })
    email!: string;

    @Column({ type: DataType.STRING })
    phone!: string;

    @Column({ type: DataType.STRING, defaultValue: 'activo' })
    status!: string;

    @Column({ type: DataType.INTEGER, defaultValue: 10, field: 'daily_quota' })
    dailyQuota!: number;

    @ForeignKey(() => Specialty)
    @Column({ type: DataType.INTEGER, field: 'specialty_id' })
    specialtyId!: number;

    @BelongsTo(() => Specialty)
    specialty!: Specialty;

    @ForeignKey(() => MedicalCenter)
    @Column({ type: DataType.INTEGER, field: 'medical_center_id' })
    medicalCenterId!: number;

    @BelongsTo(() => MedicalCenter)
    medicalCenter!: MedicalCenter;

    @HasMany(() => Appointment)
    appointments!: Appointment[];

    @HasMany(() => DoctorSchedule)
    schedules!: DoctorSchedule[];
}

