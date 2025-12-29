
import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.addColumn('appointments', 'internalStatus', {
            type: DataTypes.ENUM(
                'NONE',
                'RECIPE_REGISTERED',
                'PENDING_QUOTE',
                'QUOTE_READY',
                'QUOTE_WITH_STOCK',
                'QUOTE_SENT',
                'QUOTE_APPROVED',
                'SESSION_PROGRAMMED'
            ),
            defaultValue: 'NONE',
            allowNull: false
        });

        await queryInterface.addIndex('appointments', ['internalStatus'], {
            name: 'appointments_internal_status_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.removeIndex('appointments', 'appointments_internal_status_idx');
        await queryInterface.removeColumn('appointments', 'internalStatus');
        // Note: Removing ENUM types in Postgres is more involved, usually requires dropping the type.
        // For simplicity in this fix, we are just removing the column.
        await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_appointments_internalStatus";');
    },
};
