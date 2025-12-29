import { sequelize } from './config/database';
import { Doctor } from './models/doctor.model';
import { Resource, ResourceType } from './models/resource.model';
import { Specialty } from './models/specialty.model';
import { MedicalCenter } from './models/medical-center.model';

async function seed() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');
        await sequelize.sync({ alter: true });
        console.log('Database synced.');

        // Reset sequence for doctors to avoid primary key violation if manual inserts happened
        await sequelize.query("SELECT setval('doctors_id_seq', (SELECT MAX(id) FROM doctors));");
        console.log('Doctors sequence reset.');

        // Ensure Medical Center exists
        const [center] = await MedicalCenter.findOrCreate({
            where: { name: 'Instituto Oncológico' },
            defaults: { address: 'Av. Principal 123', phone: '123456789' }
        });

        // Ensure Specialty exists (Oncología General)
        const [specialty] = await Specialty.findOrCreate({
            where: { name: 'Oncología General' },
            defaults: { description: 'General Oncology' }
        });

        // Doctors Data
        const doctorsData = [
            { name: 'Antonio Camargo', email: 'antonio.camargo@onkos.pe', dni: '10000001', room: 'Consultorio 1' },
            { name: 'Yinno Custodio', email: 'yinno.custodio@onkos.pe', dni: '10000002', room: 'Consultorio 2' },
            { name: 'Cavero', email: 'cavero@onkos.pe', dni: '10000003', room: 'Consultorio 4' }
        ];

        for (const data of doctorsData) {
            // Check if doctor exists
            let doctor = await Doctor.findOne({ where: { dni: data.dni } });

            if (doctor) {
                // Update existing
                await doctor.update({
                    name: data.name,
                    email: data.email,
                    specialtyId: specialty.id,
                    medicalCenterId: center.id,
                    status: 'activo'
                });
                console.log(`Doctor ${doctor.name} updated.`);
            } else {
                // Create new
                doctor = await Doctor.create({
                    name: data.name,
                    dni: data.dni,
                    email: data.email,
                    phone: '999999999',
                    specialtyId: specialty.id,
                    medicalCenterId: center.id,
                    status: 'activo'
                });
                console.log(`Doctor ${doctor.name} created.`);
            }

            // Find Resource
            let resource = await Resource.findOne({ where: { name: data.room } });

            if (!resource) {
                // Create if not exists
                resource = await Resource.create({
                    name: data.room,
                    type: ResourceType.CONSULTORIO,
                    status: 'DISPONIBLE',
                    capacity: 1
                });
                console.log(`Resource ${data.room} created.`);
            }

            // Associate
            resource.doctorId = doctor.id;
            await resource.save();
            console.log(`Associated ${doctor.name} with ${resource.name}`);
        }

        console.log('Seeding completed successfully.');
        process.exit(0);
    } catch (error) {
        console.error('Error seeding:', error);
        process.exit(1);
    }
}

seed();
