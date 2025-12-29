import axios from 'axios';

async function testReleaseResource() {
    try {
        console.log('🧪 Testing release resource endpoint...\n');

        // Release resource 18 (Consultorio 1)
        const response = await axios.post('http://localhost:4000/api/resources/18/release');

        console.log('✅ Response received:');
        console.log(JSON.stringify(response.data, null, 2));

        console.log('\n📋 Checking doctor association:');
        console.log(`Doctor ID: ${response.data.doctorId}`);
        console.log(`Doctor Object: ${response.data.doctor ? 'Present' : 'Missing'}`);
        if (response.data.doctor) {
            console.log(`Doctor Name: ${response.data.doctor.name}`);
        }

    } catch (error: any) {
        console.error('❌ Error:', error.response?.data || error.message);
    }
}

testReleaseResource();
