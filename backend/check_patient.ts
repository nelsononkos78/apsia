
import { sequelize } from './src/config/database';
import { Patient } from './src/models/patient.model';

async function checkPatient() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        const patient = await Patient.findByPk(1);
        if (patient) {
            console.log('Patient 1 found:', JSON.stringify(patient.toJSON(), null, 2));
        } else {
            console.log('Patient 1 NOT found.');
        }

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await sequelize.close();
    }
}

checkPatient();
