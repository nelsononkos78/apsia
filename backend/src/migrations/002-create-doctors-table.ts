import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('doctors', {
            id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                allowNull: false,
            },
            name: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            specialty: {
                type: DataTypes.ENUM(
                    'Oncología Clínica',
                    'Oncología Quirúrgica',
                    'Radioterapia',
                    'Hematología',
                    'Cirugía Oncológica'
                ),
                allowNull: false,
            },
            isAvailable: {
                type: DataTypes.BOOLEAN,
                defaultValue: true,
            },
            createdAt: {
                type: DataTypes.DATE,
                allowNull: false,
                defaultValue: DataTypes.NOW,
            },
            updatedAt: {
                type: DataTypes.DATE,
                allowNull: false,
                defaultValue: DataTypes.NOW,
            },
        });

        // Add index on specialty for filtering
        await queryInterface.addIndex('doctors', ['specialty'], {
            name: 'doctors_specialty_idx',
        });

        // Add index on isAvailable for quick availability checks
        await queryInterface.addIndex('doctors', ['isAvailable'], {
            name: 'doctors_is_available_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('doctors');
    },
};
