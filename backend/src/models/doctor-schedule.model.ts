import { Table, Column, Model, DataType, ForeignKey, BelongsTo } from 'sequelize-typescript';
import { Doctor } from './doctor.model';

@Table({ tableName: 'doctor_schedules', timestamps: false })
export class DoctorSchedule extends Model {
    @ForeignKey(() => Doctor)
    @Column({ type: DataType.INTEGER, field: 'doctor_id', allowNull: false })
    doctorId!: number;

    @BelongsTo(() => Doctor)
    doctor!: Doctor;

    @Column({
        type: DataType.INTEGER,
        field: 'day_of_week',
        allowNull: false,
        validate: {
            min: 0,
            max: 6
        }
    })
    dayOfWeek!: number; // 0 = Sunday, 1 = Monday, ..., 6 = Saturday

    @Column({ type: DataType.BOOLEAN, defaultValue: true, field: 'is_active' })
    isActive!: boolean;
}
