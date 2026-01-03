import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.addColumn('physical_exams', 'bodySurfaceArea', {
            type: DataTypes.DECIMAL(5, 2),
            allowNull: true,
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.removeColumn('physical_exams', 'bodySurfaceArea');
    },
};
