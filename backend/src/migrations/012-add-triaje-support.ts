import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        // Add triajeCompleted to appointments
        await queryInterface.addColumn('appointments', 'triajeCompleted', {
            type: DataTypes.BOOLEAN,
            defaultValue: false,
            allowNull: false
        });

        // Add currentAppointmentId to resources
        await queryInterface.addColumn('resources', 'currentAppointmentId', {
            type: DataTypes.INTEGER,
            allowNull: true,
            references: {
                model: 'appointments',
                key: 'id',
            },
            onUpdate: 'CASCADE',
            onDelete: 'SET NULL',
        });

        // Add TRIAJE to ResourceType ENUM
        // Note: This is dialect specific. For Postgres we need ALTER TYPE.
        // For SQLite, it's more complex as it doesn't support ALTER TYPE.
        const dialect = queryInterface.sequelize.getDialect();

        if (dialect === 'postgres') {
            await queryInterface.sequelize.query("ALTER TYPE \"enum_resources_type\" ADD VALUE 'TRIAJE'");
        } else if (dialect === 'sqlite') {
            // SQLite doesn't strictly enforce ENUMs in the same way, 
            // but we might need to recreate the table if we wanted strictness.
            // For now, we'll assume it works or skip strict ENUM update for SQLite.
        }
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.removeColumn('appointments', 'triajeCompleted');
        await queryInterface.removeColumn('resources', 'currentAppointmentId');

        // Removing from ENUM is not easily supported in Postgres without recreating the type.
        // Usually, we leave it as is in down migrations for ENUM values.
    },
};
