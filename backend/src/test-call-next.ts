import axios from 'axios';

async function testCallNext() {
    try {
        const response = await axios.post('http://localhost:4000/api/resources/18/call-next');
        console.log('Success:', response.data);
    } catch (error: any) {
        console.error('Error:', error.response?.data || error.message);
        console.error('Status:', error.response?.status);
    }
}

testCallNext();
