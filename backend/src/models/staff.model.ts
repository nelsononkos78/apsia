import { Table, Column, Model, DataType, CreatedAt, UpdatedAt } from 'sequelize-typescript';

export enum StaffRole {
    ADMIN = 'ADMIN',
    DOCTOR = 'DOCTOR',
    NURSE = 'NURSE',
    RECEPTIONIST = 'RECEPTIONIST'
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
