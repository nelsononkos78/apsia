import { Table, Column, Model, DataType, HasMany, CreatedAt, UpdatedAt } from 'sequelize-typescript';
import { Appointment } from './appointment.model';

@Table({ tableName: 'patients', timestamps: false })
export class Patient extends Model {
    @Column({ type: DataType.STRING, allowNull: false })
    name!: string;

    @Column({ type: DataType.STRING, unique: true })
    dni!: string;

    @Column({ type: DataType.STRING })
    phone!: string;

    @Column({ type: DataType.STRING })
    email!: string;

    @Column({ type: DataType.DATEONLY, field: 'birth_date' })
    birthDate!: Date;

    @Column({ type: DataType.STRING, field: 'vital_status', defaultValue: 'alive' })
    vitalStatus!: string;

    @Column({ type: DataType.DATE, field: 'registration_date', defaultValue: DataType.NOW })
    registrationDate!: Date;

    @Column({ type: DataType.STRING, defaultValue: 'activo' })
    status!: string;

    @Column({ type: DataType.STRING, field: 'document_type', defaultValue: 'DNI' })
    documentType!: string;

    @Column({ type: DataType.STRING, field: 'document_number' })
    documentNumber!: string;

    @Column({ type: DataType.STRING(50), field: 'medical_record_number', unique: true })
    medicalRecordNumber!: string;

    @Column({ type: DataType.STRING, field: 'onc_dni' })
    onc_dni!: string;

    @Column({ type: DataType.STRING, field: 'ssg_dni' })
    ssg_dni!: string;

    @HasMany(() => Appointment)
    appointments!: Appointment[];

    // Virtual fields for frontend compatibility
    @Column({ type: DataType.VIRTUAL })
    get firstName(): string {
        return this.name ? this.name.split(' ')[0] : '';
    }

    @Column({ type: DataType.VIRTUAL })
    get lastName(): string {
        return this.name ? this.name.split(' ').slice(1).join(' ') : '';
    }

    /**
     * Generate medical record number in format ONC-{document_number}
     * @param documentNumber - Patient's document number (DNI)
     * @returns Medical record number string
     */
    static generateMedicalRecordNumber(documentNumber: string): string {
        if (!documentNumber || documentNumber.trim() === '') {
            throw new Error('Document number is required to generate medical record number');
        }
        return `ONC-${documentNumber.trim()}`;
    }
}

