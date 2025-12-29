import { sequelize } from '../config/database';
import { Resource, ResourceType, ResourceStatus } from '../models/resource.model';
import { WaitingRoom, WaitingRoomPriority } from '../models/waiting-room.model';
import { Appointment, AppointmentStatus, ServiceTypeEnum } from '../models/appointment.model';
import { ServiceType as ServiceTypeModel } from '../models/service-type.model';
import { seedServiceTypes } from './seed-service-types';
import { Patient } from '../models/patient.model';
import { Doctor } from '../models/doctor.model';

async function seedResources() {
    console.log('🌱 Seeding resources...');

    // Crear Consultorios
    const consultorios = [];
    for (let i = 1; i <= 4; i++) {
        consultorios.push(await Resource.create({
            name: `Consultorio ${i}`,
            type: ResourceType.CONSULTORIO,
            capacity: 1,
            status: ResourceStatus.DISPONIBLE,
            currentOccupancy: 0,
            notes: `Consultorio médico ${i}`
        }));
    }
    console.log(`✅ Created ${consultorios.length} consultorios`);

    // Crear Salas de Tratamiento
    const tratamientos = [];
    for (let i = 1; i <= 9; i++) {
        tratamientos.push(await Resource.create({
            name: `Sala Tratamiento ${i}`,
            type: ResourceType.TRATAMIENTO,
            capacity: 1,
            status: ResourceStatus.DISPONIBLE,
            currentOccupancy: 0,
            notes: `Sala de tratamiento ${i}`
        }));
    }
    console.log(`✅ Created ${tratamientos.length} salas de tratamiento`);

    // Crear Camas de Estancia
    const estancias = [];
    for (let i = 1; i <= 3; i++) {
        estancias.push(await Resource.create({
            name: `Cama ${i}`,
            type: ResourceType.ESTANCIA,
            capacity: 1,
            status: ResourceStatus.DISPONIBLE,
            currentOccupancy: 0,
            notes: `Cama de recuperación ${i}`
        }));
    }
    console.log(`✅ Created ${estancias.length} camas de estancia`);

    return { consultorios, tratamientos, estancias };
}

async function seedPatients() {
    console.log('🌱 Seeding patients...');

    const patients = [];
    const firstNames = ['Juan', 'María', 'Carlos', 'Ana', 'Luis', 'Carmen', 'Pedro', 'Laura', 'Miguel', 'Sofia'];
    const lastNames = ['García', 'Rodríguez', 'Martínez', 'López', 'González', 'Pérez', 'Sánchez', 'Ramírez', 'Torres', 'Flores'];

    for (let i = 0; i < 20; i++) {
        patients.push(await Patient.create({
            name: `${firstNames[i % firstNames.length]} ${lastNames[i % lastNames.length]}`,
            dni: `DOC${1000 + i}`,
            birthDate: new Date(1950 + (i * 2), i % 12, (i % 28) + 1),
            phone: `555-${1000 + i}`,
            email: `patient${i}@example.com`
        }));
    }

    console.log(`✅ Created ${patients.length} patients`);
    return patients;
}

async function seedDoctors() {
    console.log('🌱 Seeding doctors...');

    const doctors = [];
    const doctorData = [
        { name: 'Dr. Roberto Hernández', specialty: 'Oncología' },
        { name: 'Dra. Patricia Morales', specialty: 'Hematología' },
        { name: 'Dr. Fernando Castro', specialty: 'Oncología' },
        { name: 'Dra. Isabel Vargas', specialty: 'Radiología' }
    ];

    for (const doc of doctorData) {
        doctors.push(await Doctor.create({
            name: doc.name,
            specialty: doc.specialty,
            licenseNumber: `LIC${Math.floor(Math.random() * 10000)}`,
            phone: `555-${Math.floor(Math.random() * 9000) + 1000}`,
            email: `${doc.name.toLowerCase().replace(/\s+/g, '.')}@hospital.com`
        }));
    }

    console.log(`✅ Created ${doctors.length} doctors`);
    return doctors;
}

async function seedAppointments(patients: Patient[], doctors: Doctor[], resources: any) {
    console.log('🌱 Seeding appointments for the next 7 days...');

    const appointments = [];
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Generar citas para los próximos 7 días
    for (let day = 0; day < 7; day++) {
        const currentDate = new Date(today);
        currentDate.setDate(currentDate.getDate() + day);

        // Determinar cuántas citas crear (días con alta ocupación)
        let appointmentsPerDay = 15;
        if (day === 2 || day === 4) {
            // Días con recursos copados
            appointmentsPerDay = 40;
        } else if (day === 1 || day === 5) {
            // Días con media ocupación
            appointmentsPerDay = 25;
        }

        for (let i = 0; i < appointmentsPerDay; i++) {
            const hour = 8 + Math.floor(i / 3); // 8 AM a 6 PM
            const minute = (i % 3) * 20; // 0, 20, 40 minutos

            const appointmentDate = new Date(currentDate);
            appointmentDate.setHours(hour, minute, 0, 0);

            // Seleccionar recurso basado en el tipo de servicio
            const allServiceTypes = await ServiceTypeModel.findAll();
            const st = allServiceTypes[i % allServiceTypes.length];
            const serviceType = st.code;

            let resource;
            if (serviceType === ServiceTypeEnum.CONSULTATION_NEW) {
                resource = resources.consultorios[i % resources.consultorios.length];
            } else if (serviceType === ServiceTypeEnum.CHEMOTHERAPY) {
                resource = resources.tratamientos[i % resources.tratamientos.length];
            } else {
                resource = resources.estancias[i % resources.estancias.length];
            }

            const patient = patients[i % patients.length];
            const doctor = doctors[i % doctors.length];

            const statuses = [
                AppointmentStatus.SCHEDULED,
                AppointmentStatus.CHECKED_IN,
                AppointmentStatus.IN_PROGRESS,
                AppointmentStatus.COMPLETED
            ];

            // Citas futuras siempre SCHEDULED
            const status = day > 0 ? AppointmentStatus.SCHEDULED : statuses[i % statuses.length];

            appointments.push(await Appointment.create({
                patientId: patient.id,
                doctorId: doctor.id,
                resourceId: resource.id,
                dateTime: appointmentDate,
                serviceTypeId: st.id,
                status,
                specialty: doctor.specialty,
                notes: `Cita ${i + 1} del día ${day + 1}`,
                phoneNumber: patient.phone,
                emergencyContact: `Emergency ${patient.phone}`
            }));
        }

        console.log(`✅ Created ${appointmentsPerDay} appointments for day ${day + 1}`);
    }

    return appointments;
}

async function seedWaitingRoom(patients: Patient[], appointments: Appointment[]) {
    console.log('🌱 Seeding waiting room...');

    const waitingRoomRecords = [];
    const now = new Date();

    // Agregar algunos pacientes a la sala de espera
    for (let i = 0; i < 5; i++) {
        const checkInTime = new Date(now);
        checkInTime.setMinutes(checkInTime.getMinutes() - (i * 10)); // Escalonar llegadas

        const priority = i === 0 || i === 3 ? WaitingRoomPriority.URGENTE : WaitingRoomPriority.NORMAL;
        const estimatedWaitTime = priority === WaitingRoomPriority.URGENTE ? 5 : 15 + (i * 5);

        waitingRoomRecords.push(await WaitingRoom.create({
            patientId: patients[i].id,
            appointmentId: appointments[i]?.id || null,
            checkInTime,
            estimatedWaitTime,
            priority,
            notes: priority === WaitingRoomPriority.URGENTE ? 'Paciente prioritario' : null
        }));
    }

    console.log(`✅ Created ${waitingRoomRecords.length} waiting room records`);
    return waitingRoomRecords;
}

async function main() {
    try {
        console.log('🚀 Starting seed process...\n');

        // Conectar a la base de datos
        await sequelize.authenticate();
        console.log('✅ Database connected\n');

        // Sincronizar modelos (esto creará las tablas si no existen)
        await sequelize.sync({ force: true }); // CUIDADO: force: true borra todas las tablas
        console.log('✅ Database synced\n');

        await seedServiceTypes();

        // Seed data
        const resources = await seedResources();
        console.log('');

        const patients = await seedPatients();
        console.log('');

        const doctors = await seedDoctors();
        console.log('');

        const appointments = await seedAppointments(patients, doctors, resources);
        console.log('');

        await seedWaitingRoom(patients, appointments);
        console.log('');

        console.log('✅ Seed completed successfully!');
        console.log('\n📊 Summary:');
        console.log(`   - ${resources.consultorios.length} Consultorios`);
        console.log(`   - ${resources.tratamientos.length} Salas de Tratamiento`);
        console.log(`   - ${resources.estancias.length} Camas de Estancia`);
        console.log(`   - ${patients.length} Patients`);
        console.log(`   - ${doctors.length} Doctors`);
        console.log(`   - ${appointments.length} Appointments (7 days)`);
        console.log(`   - 5 Waiting Room Records\n`);

        process.exit(0);
    } catch (error) {
        console.error('❌ Error seeding database:', error);
        process.exit(1);
    }
}

main();
