import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';

@Table({ tableName: 'chemo_chairs' })
export class ChemoChair extends Model {
    @Column({ type: DataType.STRING, allowNull: false, unique: true })
    chairLabel!: string; // e.g., "Silla 1", "Silla 2"

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
