import { sequelize } from './config/database';
import { Patient } from './models/patient.model';
import { Appointment, AppointmentStatus } from './models/appointment.model';
import { Queue } from './models/queue.model';
import { WaitingRoom, WaitingRoomStatus } from './models/waiting-room.model';
import { ServiceType } from './models/service-type.model';
import { Doctor } from './models/doctor.model';

const FIRST_NAMES = [
    'Juan', 'Maria', 'Carlos', 'Ana', 'Luis', 'Elena', 'Pedro', 'Sofia', 'Miguel', 'Lucia',
    'Jose', 'Carmen', 'David', 'Laura', 'Jorge', 'Isabel', 'Fernando', 'Patricia', 'Ricardo', 'Teresa'
];

const LAST_NAMES = [
    'Garcia', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Perez', 'Sanchez', 'Ramirez', 'Torres',
    'Flores', 'Rivera', 'Gomez', 'Diaz', 'Reyes', 'Morales', 'Ortiz', 'Castillo', 'Chavez', 'Vasquez'
];

const DOCTOR_IDS = [1, 3, 4]; // Active doctors
const SERVICE_IDS = [1, 2]; // Consultation New, Followup

function getRandomElement<T>(array: T[]): T {
    return array[Math.floor(Math.random() * array.length)];
}

function generateDNI(): string {
    return Math.floor(10000000 + Math.random() * 90000000).toString();
}

function generatePhone(): string {
    return `9${Math.floor(10000000 + Math.random() * 90000000)}`;
}

async function seedDummyData() {
    try {
        await sequelize.authenticate();
        console.log('✅ Database connected\n');

        console.log('🚀 Starting seed of 10 dummy appointments PER active doctor...');

        const today = new Date();
        today.setHours(8, 0, 0, 0); // Start at 8 AM

        for (const doctorId of DOCTOR_IDS) {
            console.log(`\n👨‍⚕️ Seeding for Doctor ID: ${doctorId}`);

            for (let i = 0; i < 10; i++) {
                // 1. Create Patient
                const firstName = getRandomElement(FIRST_NAMES);
                const lastName = getRandomElement(LAST_NAMES);
                const dni = generateDNI();

                const patient = await Patient.create({
                    name: `${firstName} ${lastName}`,
                    firstName: firstName,
                    lastName: lastName,
                    document_type: 'DNI',
                    document_number: dni,
                    phone: generatePhone(),
                    email: `${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com`,
                    status: 'active'
                });
                console.log(`   👤 Created Patient: ${patient.name} (DNI: ${dni})`);

                // 2. Select Service
                const serviceTypeId = getRandomElement(SERVICE_IDS);

                // Time: spread throughout the day
                const appointmentTime = new Date(today);
                appointmentTime.setMinutes(today.getMinutes() + (i * 20)); // Every 20 mins per doctor

                // 3. Create Appointment (CHECKED_IN)
                const appointment = await Appointment.create({
                    patientId: patient.id,
                    doctorId: doctorId,
                    serviceTypeId: serviceTypeId,
                    dateTime: appointmentTime,
                    status: AppointmentStatus.CHECKED_IN,
                    contactName: patient.name,
                    phoneNumber: patient.phone,
                    checkinTime: new Date() // Checked in "now"
                });
                console.log(`   📅 Created Appointment #${appointment.id} at ${appointmentTime.toLocaleTimeString()}`);

                // 4. Create Queue Entry
                const serviceCode = serviceTypeId === 1 ? 'C' : 'S';
                const ticketNumber = `${serviceCode}-${Math.floor(Math.random() * 1000).toString().padStart(3, '0')}`;

                await Queue.create({
                    appointmentId: appointment.id,
                    serviceArea: 'Consultorio', // Generic area
                    ticketNumber: ticketNumber,
                    isCurrent: false,
                    isCompleted: false
                });
                console.log(`   🎫 Created Queue Ticket: ${ticketNumber}`);

                // 5. Add to Waiting Room
                await WaitingRoom.create({
                    patientId: patient.id,
                    appointmentId: appointment.id,
                    status: WaitingRoomStatus.ESPERANDO,
                    checkInTime: new Date(),
                    priority: 'NORMAL'
                });
            }
        }

        console.log('✅ Seed completed successfully!');

    } catch (error) {
        console.error('❌ Error seeding:', error);
    } finally {
        await sequelize.close();
    }
}

seedDummyData();
