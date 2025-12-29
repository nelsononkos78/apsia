import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Doctor } from './doctor.model';

@Table({ tableName: 'procedure_orders' })
export class ProcedureOrder extends Model {
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

    @Column({ type: DataType.STRING, allowNull: false })
    procedureType!: string; // e.g., "Biopsia Mama"

    @Column({ type: DataType.STRING })
    lateralidad!: string; // e.g., "Izquierda", "Derecha"

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    urgency!: boolean;

    @Column({ type: DataType.DATEONLY })
    suggestedDate!: Date;

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    processed!: boolean;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
