import { sequelize } from './config/database';
import { Patient } from './models/patient.model';
import { Appointment, AppointmentStatus } from './models/appointment.model';
import { Queue } from './models/queue.model';
import { WaitingRoom, WaitingRoomStatus } from './models/waiting-room.model';
import { ServiceType } from './models/service-type.model';
import { Doctor } from './models/doctor.model';

async function seedWaitingPatient() {
    try {
        await sequelize.authenticate();
        console.log('✅ Database connected');

        // 1. Get or Create Patient
        const [patient] = await Patient.findOrCreate({
            where: { document_number: '99999999' },
            defaults: {
                name: 'Test Patient Doorbell',
                document_type: 'DNI',
                document_number: '99999999',
                phone: '555-555-555',
                status: 'active'
            }
        });
        console.log(`👤 Patient ready: ${patient.name} (${patient.id})`);

        // 2. Get Doctor (Antonio Camargo - ID 1)
        const doctor = await Doctor.findByPk(1);
        if (!doctor) throw new Error('Doctor ID 1 not found');
        console.log(`👨‍⚕️ Doctor ready: ${doctor.name}`);

        // 3. Get Service Type
        const serviceType = await ServiceType.findOne();
        if (!serviceType) throw new Error('No service type found');

        // 4. Create Appointment for Today
        const appointment = await Appointment.create({
            patientId: patient.id,
            doctorId: doctor.id,
            serviceTypeId: serviceType.id,
            dateTime: new Date(),
            status: AppointmentStatus.CHECKED_IN,
            contactName: patient.name,
            phoneNumber: patient.phone,
            checkinTime: new Date()
        });
        console.log(`📅 Appointment created: ${appointment.id}`);

        // 5. Create Queue Entry
        const ticketNumber = `T-${Math.floor(Math.random() * 1000)}`;
        await Queue.create({
            appointmentId: appointment.id,
            serviceArea: 'Consultorio 1',
            ticketNumber: ticketNumber,
            isCurrent: false,
            isCompleted: false
        });
        console.log(`🎫 Queue created: ${ticketNumber}`);

        // 6. Add to Waiting Room
        await WaitingRoom.create({
            patientId: patient.id,
            appointmentId: appointment.id,
            status: WaitingRoomStatus.ESPERANDO,
            checkInTime: new Date(),
            priority: 'NORMAL'
        });
        console.log(`⏳ Added to Waiting Room`);

    } catch (error) {
        console.error('❌ Error seeding:', error);
    } finally {
        await sequelize.close();
    }
}

seedWaitingPatient();
