import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';

@Table({ tableName: 'allergies' })
export class Allergy extends Model {
    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: false })
    patientId!: number;

    @BelongsTo(() => Patient)
    patient!: Patient;

    @Column({ type: DataType.STRING, allowNull: false })
    substance!: string;

    @Column({ type: DataType.STRING })
    type!: string; // MEDICAMENTO, ALIMENTO, etc.

    @Column({ type: DataType.STRING })
    severity!: string; // LEVE, MODERADO, SEVERO

    @Column({ type: DataType.TEXT })
    comments!: string;

    @Column({ type: DataType.BOOLEAN, defaultValue: true })
    isActive!: boolean;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
