import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('chemo_chairs', {
            id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                allowNull: false,
            },
            chairLabel: {
                type: DataTypes.STRING,
                allowNull: false,
                unique: true,
            },
            isOccupied: {
                type: DataTypes.BOOLEAN,
                defaultValue: false,
            },
            occupiedByPatientId: {
                type: DataTypes.INTEGER,
                allowNull: true,
                references: {
                    model: 'patients',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'SET NULL',
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

        // Add indexes for efficient querying
        await queryInterface.addIndex('chemo_chairs', ['chairLabel'], {
            name: 'chemo_chairs_chair_label_idx',
            unique: true,
        });

        await queryInterface.addIndex('chemo_chairs', ['isOccupied'], {
            name: 'chemo_chairs_is_occupied_idx',
        });

        await queryInterface.addIndex('chemo_chairs', ['occupiedByPatientId'], {
            name: 'chemo_chairs_occupied_by_patient_id_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('chemo_chairs');
    },
};
