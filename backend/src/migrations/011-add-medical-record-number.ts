import { QueryInterface, DataTypes } from 'sequelize';

export async function up(queryInterface: QueryInterface): Promise<void> {
    // Add medical_record_number column to patients table
    await queryInterface.addColumn('patients', 'medical_record_number', {
        type: DataTypes.STRING(20),
        allowNull: true, // Initially nullable to allow migration
        unique: true
    });

    // Create index for faster searches
    await queryInterface.addIndex('patients', ['medical_record_number'], {
        name: 'idx_patients_medical_record_number',
        unique: true
    });

    // Generate medical record numbers for existing patients
    // Format: ONC-{document_number}
    await queryInterface.sequelize.query(`
        UPDATE patients 
        SET medical_record_number = CONCAT('ONC-', document_number)
        WHERE medical_record_number IS NULL 
        AND document_number IS NOT NULL
        AND document_number != '';
    `);

    console.log('✅ Medical record numbers generated for existing patients');
}

export async function down(queryInterface: QueryInterface): Promise<void> {
    // Remove index
    await queryInterface.removeIndex('patients', 'idx_patients_medical_record_number');

    // Remove column
    await queryInterface.removeColumn('patients', 'medical_record_number');
}
