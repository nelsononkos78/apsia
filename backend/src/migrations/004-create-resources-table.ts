import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('resources', {
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
            type: {
                type: DataTypes.ENUM('CONSULTORIO', 'TRATAMIENTO', 'ESTANCIA'),
                allowNull: false,
            },
            status: {
                type: DataTypes.ENUM('DISPONIBLE', 'OCUPADO', 'INHABILITADO'),
                defaultValue: 'DISPONIBLE',
            },
            statusReason: {
                type: DataTypes.ENUM('MANTENIMIENTO', 'LIMPIEZA', 'FALLA'),
                allowNull: true,
            },
            capacity: {
                type: DataTypes.INTEGER,
                defaultValue: 1,
            },
            currentOccupancy: {
                type: DataTypes.INTEGER,
                defaultValue: 0,
            },
            currentPatientId: {
                type: DataTypes.INTEGER,
                allowNull: true,
                references: {
                    model: 'patients',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'SET NULL',
            },
            notes: {
                type: DataTypes.TEXT,
                allowNull: true,
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
        await queryInterface.addIndex('resources', ['type'], {
            name: 'resources_type_idx',
        });

        await queryInterface.addIndex('resources', ['status'], {
            name: 'resources_status_idx',
        });

        await queryInterface.addIndex('resources', ['currentPatientId'], {
            name: 'resources_current_patient_id_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('resources');
    },
};
