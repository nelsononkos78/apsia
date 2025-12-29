import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Doctor } from './doctor.model';

@Table({ tableName: 'recipes' })
export class Recipe extends Model {
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

    @Column({ type: DataType.TEXT, allowNull: false })
    content!: string; // Details of the recipe/chemo scheme

    @Column({ type: DataType.DATEONLY })
    suggestedDate!: Date; // Fecha propuesta para próxima sesión

    @Column({ type: DataType.BOOLEAN, defaultValue: false })
    processed!: boolean; // If it has been processed by Pharmacy/Counter

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
