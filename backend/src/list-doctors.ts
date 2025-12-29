import { sequelize } from './config/database';
import { Doctor } from './models/doctor.model';

async function listDoctors() {
    try {
        await sequelize.authenticate();
        const doctors = await Doctor.findAll({ where: { status: 'active' } }); // Assuming 'active' or similar
        // Actually, let's just list all and see their status
        const allDoctors = await Doctor.findAll();
        console.log('Doctors:', allDoctors.map(d => ({ id: d.id, name: d.name, status: d.status })));
    } catch (error) {
        console.error(error);
    } finally {
        await sequelize.close();
    }
}

listDoctors();
