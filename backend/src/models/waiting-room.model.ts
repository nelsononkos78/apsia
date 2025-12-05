import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Appointment } from './appointment.model';

export enum WaitingRoomStatus {
    ESPERANDO = 'ESPERANDO',
    LLAMADO = 'LLAMADO',
    ATENDIDO = 'ATENDIDO'
}

export enum WaitingRoomPriority {
    NORMAL = 'NORMAL',
    URGENTE = 'URGENTE'
}

@Table({ tableName: 'waiting_room' })
export class WaitingRoom extends Model {
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

    @Column({ type: DataType.DATE, allowNull: false, defaultValue: DataType.NOW })
    checkInTime!: Date;

    @Column({ type: DataType.INTEGER, allowNull: true })
    estimatedWaitTime!: number | null; // En minutos

    @Column({
        type: DataType.ENUM(...Object.values(WaitingRoomPriority)),
        defaultValue: WaitingRoomPriority.NORMAL
    })
    priority!: WaitingRoomPriority;

    @Column({
        type: DataType.ENUM(...Object.values(WaitingRoomStatus)),
        defaultValue: WaitingRoomStatus.ESPERANDO
    })
    status!: WaitingRoomStatus;

    @Column({ type: DataType.TEXT, allowNull: true })
    notes!: string | null;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
