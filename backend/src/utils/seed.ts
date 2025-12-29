import { sequelize } from '../config/database';
import { Patient } from '../models/patient.model';
import { Appointment, AppointmentStatus, ServiceTypeEnum } from '../models/appointment.model';
import { ChemoChair } from '../models/chemoChair.model';
import { RecoveryRoom } from '../models/recoveryRoom.model';
import { Staff, StaffRole } from '../models/staff.model';
import { Doctor } from '../models/doctor.model';
import { Specialty, SpecialtyType } from '../models/specialty.model';
import { Resource, ResourceType, ResourceStatus } from '../models/resource.model';
import { Queue } from '../models/queue.model';
import { ServiceType as ServiceTypeModel } from '../models/service-type.model';
import { seedServiceTypes } from './seed-service-types';

const seed = async () => {
    try {
        await sequelize.authenticate();
        await sequelize.sync({ force: true }); // Reset DB
        console.log('Database synced.');

        await seedServiceTypes();
        const allServiceTypes = await ServiceTypeModel.findAll();

        // Seed Staff (12 Roles)
        const staffMembers = [
            { name: 'Admin User', email: 'admin@onkos.pe', role: StaffRole.ADMIN },
            { name: 'Reception User', email: 'recepcion@onkos.pe', role: StaffRole.RECEPTIONIST },
            { name: 'Quote Manager', email: 'cotizaciones@onkos.pe', role: StaffRole.QUOTE_MANAGER },
            { name: 'Pharmacy User', email: 'farmacia@onkos.pe', role: StaffRole.PHARMACY },
            { name: 'Nurse Chemo', email: 'enfermeria.quimio@onkos.pe', role: StaffRole.NURSE_CHEMO },
            { name: 'Nurse Procedure', email: 'enfermeria.proc@onkos.pe', role: StaffRole.NURSE_PROCEDURE },
            { name: 'Nurse Ultrasound', email: 'enfermeria.eco@onkos.pe', role: StaffRole.NURSE_ULTRASOUND },
            { name: 'Nurse General', email: 'enfermeria.general@onkos.pe', role: StaffRole.NURSE_GENERAL },
            { name: 'Lab Onco', email: 'lab.onco@onkos.pe', role: StaffRole.LAB_ONCO },
            { name: 'Lab General', email: 'lab.general@onkos.pe', role: StaffRole.LAB_GENERAL },
            { name: 'Commercial User', email: 'comercial@onkos.pe', role: StaffRole.COMMERCIAL },
            // Doctor user is separate in Doctor model, but maybe we need a login for them too?
            // For now, assuming Doctors login via Staff table or similar. 
            // Let's add a generic Doctor login
            { name: 'Doctor User', email: 'doctor@onkos.pe', role: StaffRole.DOCTOR }
        ];

        for (const member of staffMembers) {
            await Staff.create({
                name: member.name,
                email: member.email,
                password: 'password123', // Default password
                role: member.role
            });
        }
        console.log('Staff seeded (12 roles).');

        // Seed Doctors
        // First, ensure specialties exist
        for (const specName of Object.values(SpecialtyType)) {
            await Specialty.findOrCreate({ where: { name: specName } });
        }

        const oncologySpec = await Specialty.findOne({ where: { name: SpecialtyType.ONCOLOGIA_CLINICA } });
        const radiotSpec = await Specialty.findOne({ where: { name: SpecialtyType.RADIOTERAPIA } });
        const hematSpec = await Specialty.findOne({ where: { name: SpecialtyType.HEMATOLOGIA } });
        const surgerySpec = await Specialty.findOne({ where: { name: SpecialtyType.CIRUGIA_ONCOLOGICA } });

        const doctors = await Doctor.bulkCreate([
            { name: 'Dr. Alejandro Vargas', specialtyId: oncologySpec?.id, dni: '11111111' },
            { name: 'Dra. María González', specialtyId: oncologySpec?.id, dni: '22222222' },
            { name: 'Dr. Carlos Mendoza', specialtyId: radiotSpec?.id, dni: '33333333' },
            { name: 'Dra. Ana Torres', specialtyId: hematSpec?.id, dni: '44444444' },
            { name: 'Dr. Luis Ramírez', specialtyId: surgerySpec?.id, dni: '55555555' },
        ]);
        console.log('Doctors seeded.');

        // Seed Resources - 4 Consultorios
        const consultorios = [];
        for (let i = 1; i <= 4; i++) {
            consultorios.push({
                name: `Consultorio ${i}`,
                type: ResourceType.CONSULTORIO,
                status: i <= 2 ? ResourceStatus.OCUPADO : ResourceStatus.DISPONIBLE,
                capacity: 1,
                currentOccupancy: i <= 2 ? 1 : 0
            });
        }
        await Resource.bulkCreate(consultorios);
        console.log('Consultorios seeded (4).');

        // Seed Resources - 9 Salas de Tratamiento
        const tratamientos = [];
        for (let i = 1; i <= 9; i++) {
            tratamientos.push({
                name: `Sala Tratamiento ${i}`,
                type: ResourceType.TRATAMIENTO,
                status: i <= 5 ? ResourceStatus.OCUPADO : ResourceStatus.DISPONIBLE,
                capacity: 1,
                currentOccupancy: i <= 5 ? 1 : 0
            });
        }
        await Resource.bulkCreate(tratamientos);
        console.log('Salas de Tratamiento seeded (9).');

        // Seed Resources - 4 Camas de Estancia
        const estancias = [];
        for (let i = 1; i <= 4; i++) {
            estancias.push({
                name: `Cama Estancia ${i}`,
                type: ResourceType.ESTANCIA,
                status: i <= 2 ? ResourceStatus.OCUPADO : ResourceStatus.DISPONIBLE,
                capacity: 1,
                currentOccupancy: i <= 2 ? 1 : 0
            });
        }
        await Resource.bulkCreate(estancias);
        console.log('Camas de Estancia seeded (4).');

        // Seed Patients
        const patients = [];
        const firstNames = ['Juan', 'María', 'Carlos', 'Ana', 'Luis', 'Carmen', 'Pedro', 'Rosa', 'Miguel', 'Laura',
            'José', 'Isabel', 'Antonio', 'Elena', 'Francisco', 'Patricia', 'Manuel', 'Sofía', 'David', 'Lucía'];
        const lastNames = ['García', 'Rodríguez', 'Martínez', 'López', 'González', 'Pérez', 'Sánchez', 'Ramírez',
            'Torres', 'Flores', 'Rivera', 'Gómez', 'Díaz', 'Cruz', 'Morales', 'Reyes', 'Jiménez', 'Hernández'];

        for (let i = 1; i <= 40; i++) {
            patients.push({
                name: `${firstNames[i % firstNames.length]} ${lastNames[i % lastNames.length]} ${lastNames[(i + 5) % lastNames.length]}`,
                dni: `${10000000 + i}`,
                birthDate: new Date(1940 + (i % 50), (i % 12), (i % 28) + 1),
                phone: `987-${100000 + i}`,
                email: `paciente${i}@example.com`
            });
        }
        const createdPatients = await Patient.bulkCreate(patients);
        console.log('Patients seeded (40).');

        // Seed Appointments
        const appointments = [];
        const services = Object.values(ServiceTypeEnum);
        const specialties = Object.values(Specialty);
        const today = new Date();

        // Create appointments for today with various statuses
        for (let i = 0; i < 30; i++) {
            const patient = createdPatients[i % createdPatients.length];
            const doctor = doctors[i % doctors.length];
            const appointmentDate = new Date(today);
            appointmentDate.setHours(7 + (i % 10), (i % 4) * 15, 0, 0);

            let status: AppointmentStatus;
            if (i < 8) {
                status = AppointmentStatus.CHECKED_IN; // En espera
            } else if (i < 15) {
                status = AppointmentStatus.IN_PROGRESS; // En atención
            } else if (i < 20) {
                status = AppointmentStatus.SCHEDULED; // Programadas
            } else {
                status = AppointmentStatus.COMPLETED; // Completadas
            }

            const st = allServiceTypes[i % allServiceTypes.length];
            appointments.push({
                patientId: patient.id,
                doctorId: doctor.id,
                dateTime: appointmentDate,
                serviceTypeId: st.id,
                specialty: oncologySpec?.name || 'Oncología',
                status: status,
                notes: `Cita de ${st.name}`,
                phoneNumber: patient.phone,
                emergencyContact: `Contacto Emergencia ${i}`
            });
        }
        const createdAppointments = await Appointment.bulkCreate(appointments);
        console.log('Appointments seeded (30).');

        // Seed Queue - Cola de espera con pacientes que ya hicieron check-in
        const queueEntries = [];
        const serviceAreas = ['Consulta General', 'Oncología', 'Quimioterapia', 'Radioterapia', 'Hematología'];

        let ticketCounter = 1;
        for (let i = 0; i < 15; i++) {
            const appointment = createdAppointments.find(a => a.status === AppointmentStatus.CHECKED_IN);
            if (appointment) {
                queueEntries.push({
                    appointmentId: appointment.id,
                    ticketNumber: `T${String(ticketCounter).padStart(3, '0')}`,
                    serviceArea: serviceAreas[i % serviceAreas.length],
                    isCurrent: i === 0, // El primero es el actual
                    isCompleted: false
                });
                ticketCounter++;
            }
        }
        await Queue.bulkCreate(queueEntries);
        console.log('Queue seeded (15 patients waiting).');

        // Seed Chemo Chairs (legacy - mantenemos compatibilidad)
        const chairs = [];
        for (let i = 1; i <= 9; i++) {
            chairs.push({
                chairLabel: `Silla ${i}`,
                isOccupied: i <= 5
            });
        }
        await ChemoChair.bulkCreate(chairs);
        console.log('Chemo Chairs seeded (9).');

        // Seed Recovery Rooms (legacy - mantenemos compatibilidad)
        const rooms = [];
        for (let i = 1; i <= 4; i++) {
            rooms.push({
                roomLabel: `Habitación ${i}`,
                isOccupied: i <= 2
            });
        }
        await RecoveryRoom.bulkCreate(rooms);
        console.log('Recovery Rooms seeded (4).');

        console.log('✅ Seeding complete!');
        console.log('📊 Summary:');
        console.log('   - 4 Consultorios (2 ocupados, 2 disponibles)');
        console.log('   - 9 Salas de Tratamiento (5 ocupadas, 4 disponibles)');
        console.log('   - 4 Camas de Estancia (2 ocupadas, 2 disponibles)');
        console.log('   - 40 Pacientes registrados');
        console.log('   - 30 Citas del día');
        console.log('   - 15 Pacientes en cola de espera');
        console.log('   - 5 Doctores disponibles');
        process.exit(0);
    } catch (error) {
        console.error('❌ Seeding failed:', error);
        process.exit(1);
    }
};

seed();
