import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Appointment } from './appointment.model';

export enum QuoteStatus {
    PENDING = 'PENDING',
    READY = 'READY',
    SENT = 'SENT',
    APPROVED = 'APPROVED',
    REJECTED = 'REJECTED'
}

@Table({ tableName: 'quotes' })
export class Quote extends Model {
    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: false })
    patientId!: number;

    @BelongsTo(() => Patient)
    patient!: Patient;

    @ForeignKey(() => Appointment)
    @Column({ type: DataType.INTEGER, allowNull: true })
    appointmentId!: number | null;

    @BelongsTo(() => Appointment)
    appointment!: Appointment | null;

    @Column({ type: DataType.JSON })
    items!: any; // Array of items (medicines, procedures) with costs

    @Column({ type: DataType.DECIMAL(10, 2), allowNull: false })
    totalAmount!: number;

    @Column({ type: DataType.ENUM(...Object.values(QuoteStatus)), defaultValue: QuoteStatus.PENDING })
    status!: QuoteStatus;

    @Column({ type: DataType.DATE })
    validUntil!: Date;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
