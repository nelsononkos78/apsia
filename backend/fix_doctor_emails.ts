import { sequelize } from './src/config/database';
import { Doctor } from './src/models/doctor.model';

async function fixDoctorEmails() {
    try {
        await sequelize.authenticate();

        const updates = [
            { id: 1, email: 'antonio.camargo@onkos.pe' },
            { id: 3, email: 'yinno.custodio@onkos.pe' },
            { id: 4, email: 'cavero@onkos.pe' }
        ];

        for (const update of updates) {
            await Doctor.update({ email: update.email }, { where: { id: update.id } });
            console.log(`Updated doctor ${update.id} with email ${update.email}`);
        }
    } catch (error) {
        console.error(error);
    } finally {
        await sequelize.close();
    }
}

fixDoctorEmails();
