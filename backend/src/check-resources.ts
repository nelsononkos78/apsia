import { sequelize } from './config/database';
import { Resource } from './models/resource.model';
import { Doctor } from './models/doctor.model';

async function checkResources() {
    try {
        await sequelize.authenticate();
        console.log('✅ Database connected\n');

        // Get all CONSULTORIO resources with doctor info
        const resources = await Resource.findAll({
            where: { type: 'CONSULTORIO' },
            include: [{ model: Doctor, as: 'doctor' }],
            order: [['id', 'ASC']]
        });

        console.log('📋 CONSULTORIO Resources:\n');
        resources.forEach(r => {
            console.log(`ID: ${r.id}`);
            console.log(`  Name: ${r.name}`);
            console.log(`  Status: ${r.status}`);
            console.log(`  Doctor ID: ${r.doctorId}`);
            console.log(`  Doctor Name: ${r.doctor?.name || 'NULL'}`);
            console.log(`  Doctor Status: ${r.doctor?.status || 'N/A'}`);
            console.log('---');
        });

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await sequelize.close();
    }
}

checkResources();
