import { sequelize } from '../config/database';
import { Specialty } from '../models/specialty.model';
import { Doctor } from '../models/doctor.model';
import { Patient } from '../models/patient.model';
import { MedicalCenter } from '../models/medical-center.model';
import { Appointment } from '../models/appointment.model';
import { Queue } from '../models/queue.model';
import { WaitingRoom } from '../models/waiting-room.model';
import { Resource } from '../models/resource.model';
import { ChemoChair } from '../models/chemoChair.model';
import { RecoveryRoom } from '../models/recoveryRoom.model';
import { DoctorSchedule } from '../models/doctor-schedule.model';
import * as fs from 'fs';
import * as path from 'path';

async function seedMigratedData() {
    try {
        console.log('🚀 Starting restoration of migrated data...');

        await sequelize.authenticate();
        console.log('✅ Database connected');

        // We don't use force: true here to avoid dropping the service_types table and other refactors
        // Instead, we clear the tables we're about to restore in order of dependency
        await Queue.destroy({ where: {}, cascade: true });
        await WaitingRoom.destroy({ where: {}, cascade: true });
        await Appointment.destroy({ where: {}, cascade: true });
        await ChemoChair.destroy({ where: {}, cascade: true });
        await RecoveryRoom.destroy({ where: {}, cascade: true });
        await Resource.destroy({ where: {}, cascade: true });
        await DoctorSchedule.destroy({ where: {}, cascade: true });
        await Doctor.destroy({ where: {}, cascade: true });
        await Patient.destroy({ where: {}, cascade: true });
        await Specialty.destroy({ where: {}, cascade: true });
        await MedicalCenter.destroy({ where: {}, cascade: true });
        console.log('✅ Tables cleared');

        const rootDir = path.join(__dirname, '../../..');

        // 1. Seed Specialties
        console.log('🌱 Seeding specialties...');
        const specialtiesCsv = fs.readFileSync(path.join(rootDir, 'specialties.csv'), 'utf-8');
        const specialtyLines = specialtiesCsv.split('\n').filter(line => line.trim());
        for (const line of specialtyLines) {
            const [id, name] = line.split(',');
            await Specialty.create({
                id: parseInt(id),
                name: name.trim()
            });
        }
        console.log(`✅ Created ${specialtyLines.length} specialties`);

        // 2. Seed Medical Centers (if any)
        console.log('🌱 Seeding medical centers...');
        const medicalCentersCsv = fs.readFileSync(path.join(rootDir, 'medical_centers.csv'), 'utf-8');
        const medicalCenterLines = medicalCentersCsv.split('\n').filter(line => line.trim());
        for (const line of medicalCenterLines) {
            const [id, name, address, phone, email, taxId] = line.split(',');
            await MedicalCenter.create({
                id: parseInt(id),
                name: name.trim(),
                address: address?.trim(),
                phone: phone?.trim(),
                email: email?.trim(),
                taxId: taxId?.trim()
            });
        }
        console.log(`✅ Created ${medicalCenterLines.length} medical centers`);

        // 3. Seed Doctors
        console.log('🌱 Seeding doctors...');
        const doctorsCsv = fs.readFileSync(path.join(rootDir, 'doctors.csv'), 'utf-8');
        const doctorLines = doctorsCsv.split('\n').filter(line => line.trim());
        for (const line of doctorLines) {
            const [id, name, dni, email, phone, status, specialtyId, medicalCenterId] = line.split(',');
            console.log(`Creating doctor ${name.trim()} with status: ${status?.trim()}`);
            await Doctor.create({
                id: parseInt(id),
                name: name.trim(),
                dni: dni.trim(),
                email: email?.trim() || null,
                phone: phone?.trim() || null,
                status: status?.trim() || 'activo',
                specialtyId: specialtyId ? parseInt(specialtyId) : null,
                medicalCenterId: medicalCenterId ? parseInt(medicalCenterId) : null
            });

            // Add default schedule: Monday to Friday (1-5)
            for (let day = 1; day <= 5; day++) {
                await DoctorSchedule.create({
                    doctorId: parseInt(id),
                    dayOfWeek: day,
                    isActive: true
                });
            }
        }
        console.log(`✅ Created ${doctorLines.length} doctors`);

        // 4. Seed Patients
        console.log('🌱 Seeding patients...');
        const patientsCsv = fs.readFileSync(path.join(rootDir, 'patients.csv'), 'utf-8');
        const patientLines = patientsCsv.split('\n').filter(line => line.trim());
        for (const line of patientLines) {
            const parts = line.split(',');
            if (parts.length < 2) continue;

            const [id, name, dni, phone, email, birthDate, vitalStatus, registrationDate, status, documentType, documentNumber] = parts;

            await Patient.create({
                id: parseInt(id),
                name: name.trim(),
                dni: dni?.trim() || null,
                phone: phone?.trim() || null,
                email: email?.trim() || null,
                birthDate: birthDate?.trim() ? new Date(birthDate.trim()) : null,
                vitalStatus: vitalStatus?.trim() || 'alive',
                registrationDate: registrationDate?.trim() ? new Date(registrationDate.trim()) : new Date(),
                status: status?.trim() || 'active',
                documentType: documentType?.trim() || 'DNI',
                documentNumber: documentNumber?.trim() || null
            });
        }
        console.log(`✅ Created ${patientLines.length} patients`);

        console.log('✅ Restoration completed successfully!');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error restoring migrated data:', error);
        process.exit(1);
    }
}

seedMigratedData();
