import { Sequelize } from 'sequelize';
import * as fs from 'fs';
import * as path from 'path';
import dotenv from 'dotenv';

dotenv.config();

// Database connection configuration
const databaseUrl = process.env.DATABASE_URL || 'postgresql://localhost:5432/appointment_central';

const sequelize = new Sequelize(databaseUrl, {
    dialect: 'postgres',
    logging: console.log,
});

async function runMigrations() {
    try {
        console.log('🔄 Starting database migrations...\n');

        // Test database connection
        await sequelize.authenticate();
        console.log('✅ Database connection established successfully.\n');

        // Get all migration files
        const migrationsPath = path.join(__dirname, '../migrations');
        const migrationFiles = fs
            .readdirSync(migrationsPath)
            .filter((file) => file.endsWith('.ts') || file.endsWith('.js'))
            .sort();

        console.log(`📁 Found ${migrationFiles.length} migration files:\n`);
        migrationFiles.forEach((file) => console.log(`   - ${file}`));
        console.log('');

        // Run each migration
        for (const file of migrationFiles) {
            const migrationPath = path.join(migrationsPath, file);
            console.log(`⏳ Running migration: ${file}`);

            try {
                const migration = require(migrationPath).default;
                await migration.up(sequelize.getQueryInterface());
                console.log(`✅ Migration completed: ${file}\n`);
            } catch (error: any) {
                if (error.message && error.message.includes('already exists')) {
                    console.log(`⚠️  Skipping migration (already applied): ${file}\n`);
                } else {
                    throw error;
                }
            }
        }

        console.log('🎉 All migrations completed successfully!');
    } catch (error) {
        console.error('❌ Migration failed:', error);
        process.exit(1);
    } finally {
        await sequelize.close();
    }
}

// Run migrations
runMigrations();
