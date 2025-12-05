import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('queues', {
            id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                allowNull: false,
            },
            appointmentId: {
                type: DataTypes.INTEGER,
                allowNull: false,
                references: {
                    model: 'appointments',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'CASCADE',
            },
            ticketNumber: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            serviceArea: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            isCurrent: {
                type: DataTypes.BOOLEAN,
                defaultValue: false,
            },
            isCompleted: {
                type: DataTypes.BOOLEAN,
                defaultValue: false,
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
        await queryInterface.addIndex('queues', ['appointmentId'], {
            name: 'queues_appointment_id_idx',
        });

        await queryInterface.addIndex('queues', ['ticketNumber'], {
            name: 'queues_ticket_number_idx',
        });

        await queryInterface.addIndex('queues', ['serviceArea'], {
            name: 'queues_service_area_idx',
        });

        await queryInterface.addIndex('queues', ['isCurrent'], {
            name: 'queues_is_current_idx',
        });

        await queryInterface.addIndex('queues', ['isCompleted'], {
            name: 'queues_is_completed_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('queues');
    },
};
