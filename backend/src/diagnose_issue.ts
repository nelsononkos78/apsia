import { Resource } from './models/resource.model';
import { Appointment } from './models/appointment.model';
import { WaitingRoom } from './models/waiting-room.model';
import { sequelize } from './config/database';

async function diagnose() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        const count = await Resource.count();
        console.log(`Total resources: ${count}`);

        const resources = await Resource.findAll();
        console.log('--- ALL RESOURCES ---');
        resources.forEach(r => {
            console.log(`ID: ${r.id}, Name: ${r.name}, Type: ${r.type}, Status: ${r.status}, PatientID: ${r.currentPatientId}, ApptID: ${r.currentAppointmentId}`);
        });

    } catch (error) {
        console.error('Diagnosis failed:', error);
    } finally {
        await sequelize.close();
    }
}

diagnose();
