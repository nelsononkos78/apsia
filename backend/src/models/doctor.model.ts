import { Table, Column, Model, DataType, HasMany, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Appointment } from './appointment.model';

export enum Specialty {
    ONCOLOGIA_CLINICA = 'Oncología Clínica',
    ONCOLOGIA_QUIRURGICA = 'Oncología Quirúrgica',
    RADIOTERAPIA = 'Radioterapia',
    HEMATOLOGIA = 'Hematología',
    CIRUGIA_ONCOLOGICA = 'Cirugía Oncológica'
}

@Table({ tableName: 'doctors' })
export class Doctor extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string;

    @Column({ type: DataType.ENUM(...Object.values(Specialty)), allowNull: false })
    specialty!: Specialty;

    @Column({ type: DataType.BOOLEAN, defaultValue: true })
    isAvailable!: boolean;

    @HasMany(() => Appointment)
    appointments!: Appointment[];

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
