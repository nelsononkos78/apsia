import { Table, Column, Model, DataType, HasMany } from 'sequelize-typescript';
import { Doctor } from './doctor.model';

@Table({ tableName: 'medical_centers', timestamps: false })
export class MedicalCenter extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string;

    @Column({ type: DataType.STRING })
    address!: string;

    @Column({ type: DataType.STRING })
    phone!: string;

    @Column({ type: DataType.STRING })
    email!: string;

    @Column({ type: DataType.STRING, field: 'tax_id' })
    taxId!: string;

    @HasMany(() => Doctor)
    doctors!: Doctor[];
}
