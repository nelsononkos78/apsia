import { Table, Column, Model, DataType, HasMany, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Appointment } from './appointment.model';

@Table({ tableName: 'patients' })
export class Patient extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    firstName!: string;

    @Column({ type: DataType.STRING, allowNull: false })
    lastName!: string;

    @Column({ type: DataType.STRING, unique: true, allowNull: false })
    documentId!: string; // DNI/Cedula

    @Column({ type: DataType.DATEONLY, allowNull: false })
    birthDate!: Date;

    @Column({ type: DataType.STRING })
    phone!: string;

    @Column({ type: DataType.STRING })
    email!: string;

    @HasMany(() => Appointment)
    appointments!: Appointment[];

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
