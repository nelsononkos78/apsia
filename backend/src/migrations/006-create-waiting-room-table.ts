import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('waiting_room', {
            id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                allowNull: false,
            },
            patientId: {
                type: DataTypes.INTEGER,
                allowNull: false,
                references: {
                    model: 'patients',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE',
            },
            appointmentId: {
                type: DataTypes.INTEGER,
                allowNull: true,
                references: {
                    model: 'appointments',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'SET NULL',
            },
            checkInTime: {
                type: DataTypes.DATE,
                allowNull: false,
                defaultValue: DataTypes.NOW,
            },
            estimatedWaitTime: {
                type: DataTypes.INTEGER,
                allowNull: true,
            },
            priority: {
                type: DataTypes.ENUM('NORMAL', 'URGENTE'),
                defaultValue: 'NORMAL',
            },
            status: {
                type: DataTypes.ENUM('ESPERANDO', 'LLAMADO', 'ATENDIDO'),
                defaultValue: 'ESPERANDO',
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
        await queryInterface.addIndex('waiting_room', ['patientId'], {
            name: 'waiting_room_patient_id_idx',
        });

        await queryInterface.addIndex('waiting_room', ['appointmentId'], {
            name: 'waiting_room_appointment_id_idx',
        });

        await queryInterface.addIndex('waiting_room', ['status'], {
            name: 'waiting_room_status_idx',
        });

        await queryInterface.addIndex('waiting_room', ['priority'], {
            name: 'waiting_room_priority_idx',
        });

        await queryInterface.addIndex('waiting_room', ['checkInTime'], {
            name: 'waiting_room_check_in_time_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('waiting_room');
    },
};
