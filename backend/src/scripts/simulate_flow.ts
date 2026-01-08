
import axios from 'axios';
import { io } from 'socket.io-client';

const API_URL = 'http://localhost:4000/api';
const SOCKET_URL = 'http://localhost:4000';

// Helper to log with timestamp
const log = (msg: string) => console.log(`[${new Date().toISOString()}] ${msg}`);

// Helper to delay execution
const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

async function simulateFlow() {
    log('🚀 Starting Simulation Flow...');

    // Connect to WebSocket to listen for events
    const socket = io(SOCKET_URL);

    socket.on('connect', () => {
        log('✅ WebSocket Connected');
        socket.emit('join', 'monitoring'); // Join monitoring room
    });

    socket.on('tv:update', (data) => {
        log(`📺 TV Update Received: ${JSON.stringify(data)}`);
    });

    socket.on('waitingRoom:update', (data) => {
        log(`📋 Waiting Room Update: ${JSON.stringify(data)}`);
    });

    socket.on('resource:update', (data) => {
        log(`🏥 Resource Update: ${JSON.stringify(data)}`);
    });

    try {
        // 1. Create Patient
        log('1️⃣ Creating Patient...');
        const patientData = {
            name: 'Simulado FlowTest',
            dni: `SIM${Date.now()}`, // Unique DNI
            email: `simulado${Date.now()}@test.com`,
            phone: '555-0000',
            birthDate: '1990-01-01',
            documentType: 'DNI',
            documentNumber: `SIM${Date.now()}`,
            medicalRecordNumber: `ONC-SIM${Date.now()}`
        };
        const patientRes = await axios.post(`${API_URL}/patients`, patientData);
        const patient = patientRes.data;
        log(`✅ Patient Created: ${patient.name} (ID: ${patient.id})`);

        // 2. Create Appointment (Reservation)
        log('2️⃣ Creating Appointment...');
        const appointmentData = {
            patientId: patient.id,
            doctorId: 1, // Assuming Doctor ID 1 exists (Dr. Antonio Camargo)
            serviceTypeId: 1, // Assuming Service Type 1 exists (Consulta)
            dateTime: new Date().toISOString(),
            notes: 'Simulation Test Appointment',
            specialty: 'Oncología'
        };
        const appointmentRes = await axios.post(`${API_URL}/appointments`, appointmentData);
        const appointment = appointmentRes.data;
        log(`✅ Appointment Created: ID ${appointment.id}`);

        // 3. Check-in (Patient Arrives)
        log('3️⃣ Performing Check-in...');
        const checkinRes = await axios.post(`${API_URL}/appointments/${appointment.id}/checkin`, {
            patientId: patient.id
        });
        const ticket = checkinRes.data;
        log(`✅ Check-in Complete. Ticket: ${ticket.ticketNumber}`);

        await delay(2000); // Wait for socket events

        // 4. Call to Triage
        log('4️⃣ Calling to Triage...');
        // Find Triage Resource
        const resourcesRes = await axios.get(`${API_URL}/resources`);
        const triageResource = resourcesRes.data.find((r: any) => r.type === 'TRIAJE' && r.status === 'DISPONIBLE');

        if (!triageResource) {
            throw new Error('No available Triage resource found!');
        }
        log(`Found Triage Resource: ${triageResource.name} (ID: ${triageResource.id})`);

        // Call next patient to Triage (should be our patient if they are next)
        // Or specifically call this patient if we have the endpoint. 
        // The resource controller has `callNextPatient`.
        const callTriageRes = await axios.post(`${API_URL}/resources/${triageResource.id}/call-next`);
        log(`✅ Called to Triage: ${JSON.stringify(callTriageRes.data)}`);

        await delay(2000);

        // 5. Triage Process (Save Physical Exam)
        log('5️⃣ Performing Triage (Physical Exam)...');
        const physicalExamData = {
            patientId: patient.id,
            appointmentId: appointment.id,
            staffId: 1, // Assuming admin/nurse ID 1
            weight: 70,
            height: 175,
            temperature: 36.5,
            systolicPressure: 120,
            diastolicPressure: 80,
            heartRate: 75,
            respiratoryRate: 18,
            oxygenSaturation: 98,
            consciousnessLevel: 'Alert',
            painLevel: 0,
            notes: 'Patient in good condition.'
        };
        await axios.post(`${API_URL}/physical-exam`, physicalExamData);
        log('✅ Triage Data Saved.');

        // Release Triage Resource (Patient goes back to waiting room for Doctor)
        // The physical exam save might not automatically release the resource depending on logic.
        // Usually, there is a "Finish Triage" step. Let's check if we need to release the resource manually.
        // Based on `resource.controller.ts`, `releaseResource` exists.
        await axios.post(`${API_URL}/resources/${triageResource.id}/release`);
        log('✅ Triage Resource Released. Patient should be back in Waiting Room.');

        await delay(2000);

        // 6. Call by Doctor
        log('6️⃣ Calling by Doctor...');
        // Doctor ID 1 calling the patient. We need the waiting room ID.
        // Let's fetch the waiting room to find our patient's entry.
        // We can search for the patient in the waiting list.
        // But `callPatient` in `doctor.controller` needs `waitingRoomId`.
        // Let's assume the doctor dashboard fetches the list.
        // We can simulate fetching the dashboard data.
        const dashboardRes = await axios.get(`${API_URL}/doctors/dashboard?email=antonio.camargo@onkos.pe`);
        const waitingList = dashboardRes.data.waitingList;
        const waitingEntry = waitingList.find((w: any) => w.patientId === patient.id);

        if (!waitingEntry) {
            throw new Error('Patient not found in Doctor Waiting List!');
        }
        log(`Found Patient in Waiting List: Entry ID ${waitingEntry.id}`);

        const callDoctorRes = await axios.post(`${API_URL}/doctors/call`, {
            doctorId: 1,
            waitingRoomId: waitingEntry.id
        });
        log(`✅ Called by Doctor: ${JSON.stringify(callDoctorRes.data)}`);

        await delay(2000);

        // 7. Start Consultation
        log('7️⃣ Starting Consultation...');
        const startRes = await axios.post(`${API_URL}/doctors/start`, {
            doctorId: 1,
            appointmentId: appointment.id
        });
        log(`✅ Consultation Started: Status ${startRes.data.status}`);

        await delay(2000);

        // 8. Finish Consultation
        log('8️⃣ Finishing Consultation...');
        const medicalRecordData = {
            anamnesis: 'Patient reports feeling well.',
            physicalExam: 'Normal.',
            diagnosisCode: 'Z00.0',
            diagnosisDescription: 'General checkup.'
        };
        const finishRes = await axios.post(`${API_URL}/doctors/finish`, {
            doctorId: 1,
            appointmentId: appointment.id,
            medicalRecord: medicalRecordData
        });
        log(`✅ Consultation Finished: Status ${finishRes.data.status}`);

        log('🎉 Simulation Completed Successfully!');

    } catch (error: any) {
        log(`❌ Error: ${error.message}`);
        if (error.response) {
            log(`Response Data: ${JSON.stringify(error.response.data)}`);
        }
    } finally {
        socket.disconnect();
    }
}

simulateFlow();
