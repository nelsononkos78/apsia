import { sequelize } from './config/database';
import { Doctor } from './models/doctor.model';
import { DoctorSchedule } from './models/doctor-schedule.model';

async function seedSchedules() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');
        await sequelize.sync({ alter: true });

        const doctors = await Doctor.findAll();

        for (const doctor of doctors) {
            console.log(`Seeding schedule for ${doctor.name}...`);

            // Create schedule for Mon-Fri (1-5)
            // Or just all days for testing
            for (let day = 0; day <= 6; day++) {
                const [schedule, created] = await DoctorSchedule.findOrCreate({
                    where: {
                        doctorId: doctor.id,
                        dayOfWeek: day
                    },
                    defaults: {
                        isActive: true
                    }
                });

                if (!created) {
                    schedule.isActive = true;
                    await schedule.save();
                }
            }
        }

        console.log('Schedules seeded successfully.');
        process.exit(0);
    } catch (error) {
        console.error('Error seeding schedules:', error);
        process.exit(1);
    }
}

seedSchedules();
