import { sequelize } from './src/config/database';
import { Staff } from './src/models/staff.model';
import { Doctor } from './src/models/doctor.model';

async function checkUsers() {
    try {
        await sequelize.authenticate();
        const staff = await Staff.findAll();
        console.log('Staff:', staff.map(s => ({ email: s.email, role: s.role })));
        const doctors = await Doctor.findAll();
        console.log('Doctors:', doctors.map(d => ({ email: d.email, name: d.name })));
    } catch (error) {
        console.error(error);
    } finally {
        await sequelize.close();
    }
}

checkUsers();
