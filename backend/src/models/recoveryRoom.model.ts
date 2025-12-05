import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';

@Table({ tableName: 'recovery_rooms' })
export class RecoveryRoom extends Model {
    @Column({ type: DataType.STRING, allowNull: false, unique: true })
    roomLabel!: string; // e.g., "Habitación 1"

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    isOccupied!: boolean;

    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: true })
    occupiedByPatientId!: number | null;

    @BelongsTo(() => Patient)
    patient!: Patient | null;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
