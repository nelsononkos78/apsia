import { QueryInterface, DataTypes } from 'sequelize';

export default {
    up: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.createTable('appointments', {
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
            doctorId: {
                type: DataTypes.INTEGER,
                allowNull: true,
                references: {
                    model: 'doctors',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'SET NULL',
            },
            resourceId: {
                type: DataTypes.INTEGER,
                allowNull: true,
                references: {
                    model: 'resources',
                    key: 'id',
                },
                onUpdate: 'CASCADE',
                onDelete: 'SET NULL',
            },
            dateTime: {
                type: DataTypes.DATE,
                allowNull: false,
            },
            serviceType: {
                type: DataTypes.ENUM('CONSULTATION', 'LABORATORY', 'CHEMOTHERAPY', 'RECOVERY'),
                allowNull: false,
            },
            status: {
                type: DataTypes.ENUM('SCHEDULED', 'CHECKED_IN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW'),
                defaultValue: 'SCHEDULED',
            },
            specialty: {
                type: DataTypes.STRING,
                allowNull: true,
            },
            notes: {
                type: DataTypes.TEXT,
                allowNull: true,
            },
            phoneNumber: {
                type: DataTypes.STRING,
                allowNull: true,
            },
            emergencyContact: {
                type: DataTypes.STRING,
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
        await queryInterface.addIndex('appointments', ['patientId'], {
            name: 'appointments_patient_id_idx',
        });

        await queryInterface.addIndex('appointments', ['doctorId'], {
            name: 'appointments_doctor_id_idx',
        });

        await queryInterface.addIndex('appointments', ['resourceId'], {
            name: 'appointments_resource_id_idx',
        });

        await queryInterface.addIndex('appointments', ['dateTime'], {
            name: 'appointments_date_time_idx',
        });

        await queryInterface.addIndex('appointments', ['status'], {
            name: 'appointments_status_idx',
        });

        await queryInterface.addIndex('appointments', ['serviceType'], {
            name: 'appointments_service_type_idx',
        });
    },

    down: async (queryInterface: QueryInterface): Promise<void> => {
        await queryInterface.dropTable('appointments');
    },
};
