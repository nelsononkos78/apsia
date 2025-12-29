
import { sequelize } from './src/config/database';

async function addColumn() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        await sequelize.query(`
      ALTER TABLE doctors 
      ADD COLUMN IF NOT EXISTS daily_quota INTEGER DEFAULT 10;
    `);

        console.log('Column daily_quota added successfully.');

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await sequelize.close();
    }
}

addColumn();
