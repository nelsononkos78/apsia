import { Table, Column, Model, DataType, HasMany } from 'sequelize-typescript';
import { Doctor } from './doctor.model';

export enum SpecialtyType {
    ONCOLOGIA_CLINICA = 'Oncología Clínica',
    RADIOTERAPIA = 'Radioterapia',
    HEMATOLOGIA = 'Hematología',
    CIRUGIA_ONCOLOGICA = 'Cirugía Oncológica',
    GINECOLOGIA_ONCOLOGICA = 'Ginecología Oncológica',
    PATOLOGIA = 'Patología',
    RADIOLOGIA = 'Radiología',
    PSICO_ONCOLOGIA = 'Psico-oncología',
    NUTRICION = 'Nutrición',
    CUIDADOS_PALIATIVOS = 'Cuidados Paliativos'
}

@Table({ tableName: 'specialties', timestamps: false })
export class Specialty extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string;

    @Column({ type: DataType.STRING })
    description!: string;

    @Column({ type: DataType.STRING })
    icon!: string;

    @HasMany(() => Doctor)
    doctors!: Doctor[];
}
