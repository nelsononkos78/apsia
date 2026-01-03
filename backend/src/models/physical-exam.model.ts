import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Appointment } from './appointment.model';
import { Staff } from './staff.model';

@Table({ tableName: 'physical_exams' })
export class PhysicalExam extends Model {
    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: false })
    patientId!: number;

    @BelongsTo(() => Patient)
    patient!: Patient;

    @ForeignKey(() => Appointment)
    @Column({ type: DataType.INTEGER, allowNull: false })
    appointmentId!: number;

    @BelongsTo(() => Appointment)
    appointment!: Appointment;

    @ForeignKey(() => Staff)
    @Column({ type: DataType.INTEGER, allowNull: false })
    staffId!: number;

    @BelongsTo(() => Staff)
    staff!: Staff;

    @Column({ type: DataType.DECIMAL(5, 2) })
    temperature!: number;

    @Column({ type: DataType.INTEGER })
    pulse!: number;

    @Column({ type: DataType.INTEGER })
    respiration!: number;

    @Column({ type: DataType.DECIMAL(5, 2) })
    height!: number;

    @Column({ type: DataType.DECIMAL(5, 2) })
    weight!: number;

    @Column({ type: DataType.INTEGER })
    systolic!: number;

    @Column({ type: DataType.INTEGER })
    diastolic!: number;

    @Column({ type: DataType.DECIMAL(5, 2) })
    imc!: number;

    @Column({ type: DataType.DECIMAL(5, 2) })
    bodySurfaceArea!: number;

    @Column({ type: DataType.DECIMAL(5, 2) })
    waist!: number;

    @Column({ type: DataType.STRING })
    risk!: string;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
