import { Table, Column, Model, DataType, CreatedAt, UpdatedAt } from 'sequelize-typescript';

export enum StaffRole {
    ADMIN = 'ADMIN',
    DOCTOR = 'DOCTOR',
    NURSE_CHEMO = 'NURSE_CHEMO',
    NURSE_PROCEDURE = 'NURSE_PROCEDURE',
    NURSE_ULTRASOUND = 'NURSE_ULTRASOUND',
    NURSE_GENERAL = 'NURSE_GENERAL',
    RECEPTIONIST = 'RECEPTIONIST',
    LAB_ONCO = 'LAB_ONCO',
    LAB_GENERAL = 'LAB_GENERAL',
    PHARMACY = 'PHARMACY',
    QUOTE_MANAGER = 'QUOTE_MANAGER',
    COMMERCIAL = 'COMMERCIAL',
    TRIAJE = 'TRIAJE'
}

@Table({ tableName: 'staff' })
export class Staff extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string;

    @Column({ type: DataType.STRING, unique: true, allowNull: false })
    email!: string;

    @Column({ type: DataType.STRING, allowNull: false })
    password!: string; // Hashed

    @Column({ type: DataType.ENUM(...Object.values(StaffRole)), allowNull: false })
    role!: StaffRole;

    @CreatedAt
    createdAt!: Date;

    @UpdatedAt
    updatedAt!: Date;
}
