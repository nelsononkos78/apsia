import { sequelize } from '../config/database';

const migrate = async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connected for migration.');
        await sequelize.sync({ alter: true });
        console.log('Database synced successfully.');
        process.exit(0);
    } catch (error) {
        console.error('Migration failed:', error);
        process.exit(1);
    }
};

migrate();
