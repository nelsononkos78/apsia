import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Doctor } from './doctor.model';
import { Appointment } from './appointment.model';

@Table({ tableName: 'medical_records' })
export class MedicalRecord extends Model {
    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: false })
    patientId!: number;

    @BelongsTo(() => Patient)
    patient!: Patient;

    @ForeignKey(() => Doctor)
    @Column({ type: DataType.INTEGER, allowNull: false })
    doctorId!: number;

    @BelongsTo(() => Doctor)
    doctor!: Doctor;

    @ForeignKey(() => Appointment)
    @Column({ type: DataType.INTEGER, allowNull: false })
    appointmentId!: number;

    @BelongsTo(() => Appointment)
    appointment!: Appointment;

    @Column({ type: DataType.TEXT })
    anamnesis!: string;

    @Column({ type: DataType.TEXT })
    physicalExam!: string;

    @Column({ type: DataType.TEXT })
    evolution!: string;

    @Column({ type: DataType.TEXT })
    interconsultation!: string;

    @Column({ type: DataType.STRING })
    emergencyNumber!: string;

    @Column({ type: DataType.STRING })
    diagnosisCode!: string; // CIE10

    @Column({ type: DataType.TEXT })
    diagnosisDescription!: string;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
