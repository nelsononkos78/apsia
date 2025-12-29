import { sequelize } from './config/database';
import { WaitingRoom, WaitingRoomStatus } from './models/waiting-room.model';
import { Appointment } from './models/appointment.model';
import { Patient } from './models/patient.model';
import { Resource } from './models/resource.model';

async function debug() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        // 1. Inspect raw values in waiting_room
        const [results] = await sequelize.query('SELECT * FROM waiting_room LIMIT 1');
        console.log('Raw waiting_room row:', results[0]);

        // 2. Try the query that is failing
        console.log('Attempting Sequelize query...');
        const nextPatient = await WaitingRoom.findOne({
            where: {
                status: WaitingRoomStatus.ESPERANDO
            },
            include: [{
                model: Appointment,
                // where: { doctorId: 1 } // Hardcoded for test
            }, {
                model: Patient
            }],
            order: [['priority', 'DESC'], ['checkInTime', 'ASC']]
        });
        // 3. Inspect Resource table
        const [resourceResults] = await sequelize.query('SELECT * FROM resources WHERE id = 18');
        console.log('Raw resource row:', resourceResults[0]);

        if (resourceResults.length > 0) {
            const resource = await Resource.findByPk(18);
            if (resource) {
                console.log('Resource model found:', resource.toJSON());
                console.log('Attempting to update resource status...');
                try {
                    await resource.update({
                        status: 'OCUPADO', // Try updating to OCUPADO
                        currentPatientId: nextPatient ? nextPatient.patientId : null
                    });
                    console.log('Resource update successful.');
                } catch (err) {
                    console.error('Resource update failed:', err);
                }
            }
        }



    } catch (error) {
        console.error('Debug Error:', error);
    } finally {
        await sequelize.close();
    }
}

debug();
