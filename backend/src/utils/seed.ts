import { sequelize } from '../config/database';
import { Patient } from '../models/patient.model';
import { Appointment, AppointmentStatus, ServiceType } from '../models/appointment.model';
import { ChemoChair } from '../models/chemoChair.model';
import { RecoveryRoom } from '../models/recoveryRoom.model';
import { Staff, StaffRole } from '../models/staff.model';
import { Doctor, Specialty } from '../models/doctor.model';

const seed = async () => {
    try {
        await sequelize.authenticate();
        await sequelize.sync({ force: true }); // Reset DB
        console.log('Database synced.');

        // Seed Staff
        await Staff.create({
            name: 'Admin User',
            email: 'admin@onkos.pe',
            password: 'admin', // In real app, hash this
            role: StaffRole.ADMIN
        });
        console.log('Staff seeded.');

        // Seed Doctors
        const doctors = await Doctor.bulkCreate([
            { name: 'Dr. Alejandro Vargas', specialty: Specialty.ONCOLOGIA_CLINICA, isAvailable: true },
            { name: 'Dra. María González', specialty: Specialty.ONCOLOGIA_CLINICA, isAvailable: true },
            { name: 'Dr. Carlos Mendoza', specialty: Specialty.RADIOTERAPIA, isAvailable: true },
            { name: 'Dra. Ana Torres', specialty: Specialty.HEMATOLOGIA, isAvailable: true },
            { name: 'Dr. Luis Ramírez', specialty: Specialty.CIRUGIA_ONCOLOGICA, isAvailable: true },
        ]);
        console.log('Doctors seeded.');

        // Seed Patients
        const patients = [];
        for (let i = 1; i <= 30; i++) {
            patients.push({
                firstName: `Patient${i}`,
                lastName: `Test${i}`,
                documentId: `100000${i}`,
                birthDate: new Date(1980, 0, i),
                phone: `555-00${i}`,
                email: `patient${i}@example.com`
            });
        }
        const createdPatients = await Patient.bulkCreate(patients);
        console.log('Patients seeded.');

        // Seed Appointments
        const appointments = [];
        const services = Object.values(ServiceType);
        const statuses = Object.values(AppointmentStatus);
        const specialties = Object.values(Specialty);

        for (let i = 0; i < 50; i++) {
            const patient = createdPatients[i % createdPatients.length];
            const doctor = doctors[i % doctors.length];
            const today = new Date();
            const appointmentDate = new Date(today);
            appointmentDate.setHours(8 + (i % 8), 0, 0, 0);

            appointments.push({
                patientId: patient.id,
                doctorId: Math.random() > 0.3 ? doctor.id : null, // 70% assigned to doctor
                dateTime: appointmentDate,
                serviceType: services[i % services.length],
                specialty: specialties[i % specialties.length],
                status: statuses[i % statuses.length],
                notes: `Routine checkup ${i}`,
                phoneNumber: `555-${1000 + i}`,
                emergencyContact: `Emergency Contact ${i}`
            });
        }
        await Appointment.bulkCreate(appointments);
        console.log('Appointments seeded.');

        // Seed Chemo Chairs
        const chairs = [];
        for (let i = 1; i <= 9; i++) {
            chairs.push({
                chairLabel: `Silla ${i}`,
                isOccupied: false
            });
        }
        await ChemoChair.bulkCreate(chairs);
        console.log('Chemo Chairs seeded.');

        // Seed Recovery Rooms
        const rooms = [];
        for (let i = 1; i <= 2; i++) {
            rooms.push({
                roomLabel: `Habitación ${i}`,
                isOccupied: false
            });
        }
        await RecoveryRoom.bulkCreate(rooms);
        console.log('Recovery Rooms seeded.');

        console.log('Seeding complete.');
        process.exit(0);
    } catch (error) {
        console.error('Seeding failed:', error);
        process.exit(1);
    }
};

seed();
