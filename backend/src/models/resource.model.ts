import { Table, Column, Model, DataType, ForeignKey, BelongsTo, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Patient } from './patient.model';
import { Doctor } from './doctor.model';

export enum ResourceType {
    CONSULTORIO = 'CONSULTORIO',
    TRATAMIENTO = 'TRATAMIENTO',
    ESTANCIA = 'ESTANCIA'
}

export enum ResourceStatus {
    DISPONIBLE = 'DISPONIBLE',
    OCUPADO = 'OCUPADO',
    INHABILITADO = 'INHABILITADO'
}

export enum InhabilitadoReason {
    MANTENIMIENTO = 'MANTENIMIENTO',
    LIMPIEZA = 'LIMPIEZA',
    FALLA = 'FALLA'
}

@Table({ tableName: 'resources' })
export class Resource extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string; // e.g., "Consultorio 1", "Sala Tratamiento 1", "Cama 1"

    @Column({
        type: DataType.ENUM(...Object.values(ResourceType)),
        allowNull: false
    })
    type!: ResourceType;

    @Column({
        type: DataType.ENUM(...Object.values(ResourceStatus)),
        defaultValue: ResourceStatus.DISPONIBLE
    })
    status!: ResourceStatus;

    @Column({
        type: DataType.ENUM(...Object.values(InhabilitadoReason)),
        allowNull: true
    })
    statusReason!: InhabilitadoReason | null;

    @Column({ type: DataType.INTEGER, defaultValue: 1 })
    capacity!: number; // Para camas en estancia, normalmente 1

    @Column({ type: DataType.INTEGER, defaultValue: 0 })
    currentOccupancy!: number; // Cuántos pacientes están usando el recurso

    @ForeignKey(() => Patient)
    @Column({ type: DataType.INTEGER, allowNull: true })
    currentPatientId!: number | null;

    @BelongsTo(() => Patient)
    currentPatient!: Patient | null;

    @Column({ type: DataType.TEXT, allowNull: true })
    notes!: string | null; // Notas adicionales

    @Column({ type: DataType.INTEGER, defaultValue: 20, allowNull: false })
    timing!: number; // Tiempo estimado en minutos para el recurso

    @ForeignKey(() => Doctor)
    @Column({ type: DataType.INTEGER, allowNull: true })
    doctorId!: number | null;

    @BelongsTo(() => Doctor)
    doctor!: Doctor | null;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
