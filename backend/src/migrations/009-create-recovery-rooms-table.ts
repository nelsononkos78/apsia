import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('recovery_rooms', {
            id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                allowNull: false,
            },
            roomLabel: {
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
        await queryInterface.addIndex('recovery_rooms', ['roomLabel'], {
            name: 'recovery_rooms_room_label_idx',
            unique: true,
        });

        await queryInterface.addIndex('recovery_rooms', ['isOccupied'], {
            name: 'recovery_rooms_is_occupied_idx',
        });

        await queryInterface.addIndex('recovery_rooms', ['occupiedByPatientId'], {
            name: 'recovery_rooms_occupied_by_patient_id_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('recovery_rooms');
    },
};
