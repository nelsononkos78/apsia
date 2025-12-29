
import { sequelize } from './src/config/database';
import { Doctor } from './src/models/doctor.model';
import { Specialty } from './src/models/specialty.model';

async function checkData() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        const specialties = await Specialty.findAll();
        console.log('Specialties:', JSON.stringify(specialties, null, 2));

        const doctors = await Doctor.findAll({ include: [Specialty] });
        console.log('Doctors:', JSON.stringify(doctors, null, 2));

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await sequelize.close();
    }
}

checkData();
