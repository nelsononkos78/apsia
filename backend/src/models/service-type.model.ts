import { Table, Column, Model, DataType, HasMany } from 'sequelize-typescript';
import { Appointment } from './appointment.model';

@Table({ tableName: 'service_types' })
export class ServiceType extends Model {
    @Column({ type: DataType.STRING, allowNull: false, unique: true })
    name!: string;

    @Column({ type: DataType.STRING, allowNull: true })
    description!: string;

    @Column({ type: DataType.STRING, allowNull: true })
    code!: string;

    @Column({ type: DataType.STRING, allowNull: true })
    icon!: string;

    @Column({ type: DataType.BOOLEAN, defaultValue: true, field: 'show_patient' })
    showPatient!: boolean;

    @HasMany(() => Appointment)
    appointments!: Appointment[];
}
