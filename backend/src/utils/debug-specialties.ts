import { sequelize } from '../config/database';
import { Specialty } from '../models/specialty.model';
import { Doctor } from '../models/doctor.model';

async function debugSpecialties() {
    try {
        await sequelize.authenticate();
        console.log('✅ Database connected');

        const specialties = await Specialty.findAll({
            include: [{
                model: Doctor,
                where: { status: 'activo' },
                required: true
            }]
        });

        console.log(`Found ${specialties.length} specialties with active doctors:`);
        specialties.forEach(s => {
            console.log(`- ${s.name} (ID: ${s.id}, Doctors: ${s.doctors.length})`);
        });

        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error);
        process.exit(1);
    }
}

debugSpecialties();
