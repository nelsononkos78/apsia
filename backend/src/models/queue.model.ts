import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Appointment } from './appointment.model';

@Table({ tableName: 'queues' })
export class Queue extends Model {
    @ForeignKey(() => Appointment)
    @Column({ type: DataType.INTEGER, allowNull: false })
    appointmentId!: number;

    @BelongsTo(() => Appointment)
    appointment!: Appointment;

    @Column({ type: DataType.STRING, allowNull: false })
    ticketNumber!: string; // e.g., C-001, L-002

    @Column({ type: DataType.STRING, allowNull: false })
    serviceArea!: string; // CONSULTORIO_1, LAB, CHEMO_AREA

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    isCurrent!: boolean; // If currently being called/served

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    isCompleted!: boolean;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
