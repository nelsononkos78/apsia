import { Doctor } from './src/models/doctor.model';
import { ServiceType } from './src/models/service-type.model';
import { Patient } from './src/models/patient.model';
import { Appointment, AppointmentStatus } from './src/models/appointment.model';
import { WaitingRoom, WaitingRoomStatus, WaitingRoomPriority } from './src/models/waiting-room.model';
import { Queue } from './src/models/queue.model';
import { sequelize } from './src/config/database';

async function seedTestData() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        const doctors = await Doctor.findAll({ limit: 3 });
        const serviceTypes = await ServiceType.findAll({ limit: 3 });

        if (doctors.length === 0 || serviceTypes.length === 0) {
            console.error('No doctors or service types found.');
            return;
        }

        console.log(`Found ${doctors.length} doctors and ${serviceTypes.length} service types.`);

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        for (let i = 0; i < 10; i++) {
            for (const doctor of doctors) {
                const patientName = `Paciente Test ${i + 1} - ${doctor.name}`;
                const dni = Math.floor(10000000 + Math.random() * 90000000).toString();

                const patient = await Patient.create({
                    name: patientName,
                    dni: dni,
                    documentNumber: dni,
                    phone: '999888777',
                    email: `test${i}${doctor.id}@example.com`
                });

                // Interleave times: 8:00, 8:15, 8:30...
                const appointmentTime = new Date(today);
                appointmentTime.setHours(8 + Math.floor((i * doctors.length + doctors.indexOf(doctor)) * 15 / 60));
                appointmentTime.setMinutes(((i * doctors.length + doctors.indexOf(doctor)) * 15) % 60);

                const appointment = await Appointment.create({
                    patientId: patient.id,
                    doctorId: doctor.id,
                    serviceTypeId: serviceTypes[0].id,
                    dateTime: appointmentTime,
                    status: AppointmentStatus.CHECKED_IN,
                    checkinTime: new Date(appointmentTime.getTime() - 10 * 60000), // Checked in 10 mins before
                    notes: `Cita de prueba ${i + 1} para ${doctor.name}`,
                    contactName: patientName,
                    phoneNumber: '999888777'
                });

                const prefix = serviceTypes[0].code ? serviceTypes[0].code.substring(0, 2) : 'T';
                const ticketNumber = `${prefix}-${String(i * doctors.length + doctors.indexOf(doctor) + 1).padStart(3, '0')}`;

                await Queue.create({
                    appointmentId: appointment.id,
                    ticketNumber,
                    serviceArea: serviceTypes[0].name,
                    isCurrent: false,
                    isCompleted: false
                });

                await WaitingRoom.create({
                    patientId: patient.id,
                    appointmentId: appointment.id,
                    priority: WaitingRoomPriority.NORMAL,
                    checkInTime: appointment.checkinTime,
                    status: WaitingRoomStatus.ESPERANDO,
                    notes: 'Auto-seeded test data'
                });

                console.log(`Created appointment for ${patientName} at ${appointmentTime.toLocaleTimeString()} with ${doctor.name}`);
            }
        }

        console.log('Seeding completed successfully.');
    } catch (error) {
        console.error('Error seeding data:', error);
    } finally {
        await sequelize.close();
    }
}

seedTestData();
