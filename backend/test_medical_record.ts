import { sequelize } from './src/config/database';
import { Patient } from './src/models/patient.model';

async function testMedicalRecordNumber() {
    try {
        await sequelize.authenticate();
        console.log('Database connected.\n');

        // Test 1: Check existing patients with medical record numbers
        const patientsWithMR = await Patient.findAll({
            where: {
                medicalRecordNumber: {
                    [Op.ne]: null
                }
            },
            limit: 10
        });

        console.log('=== Patients with Medical Record Numbers ===');
        patientsWithMR.forEach(p => {
            console.log(`- ${p.name}: ${p.medicalRecordNumber} (DNI: ${p.documentNumber})`);
        });

        // Test 2: Test generation method
        console.log('\n=== Testing Generation Method ===');
        const testDNI = '12345678';
        const generatedNumber = Patient.generateMedicalRecordNumber(testDNI);
        console.log(`Generated number for DNI ${testDNI}: ${generatedNumber}`);
        console.log(`Expected format: ONC-12345678`);
        console.log(`Match: ${generatedNumber === 'ONC-12345678' ? '✅' : '❌'}`);

        // Test 3: Count patients without medical record number
        const patientsWithoutMR = await Patient.count({
            where: {
                medicalRecordNumber: null
            }
        });

        console.log(`\n=== Summary ===`);
        console.log(`Total patients with medical record number: ${patientsWithMR.length}`);
        console.log(`Total patients WITHOUT medical record number: ${patientsWithoutMR}`);

        if (patientsWithoutMR > 0) {
            console.log(`\n⚠️  Warning: ${patientsWithoutMR} patients still need medical record numbers.`);
            console.log('These will be generated automatically during their next check-in.');
        } else {
            console.log('\n✅ All patients have medical record numbers!');
        }

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await sequelize.close();
    }
}

// Import Op for where clause
import { Op } from 'sequelize';

testMedicalRecordNumber();
