-- Drop Foreign Keys referencing doctors and patients
ALTER TABLE IF EXISTS appointments DROP CONSTRAINT IF EXISTS "appointments_doctorId_fkey";
ALTER TABLE IF EXISTS appointments DROP CONSTRAINT IF EXISTS "appointments_patientId_fkey";
ALTER TABLE IF EXISTS chemo_chairs DROP CONSTRAINT IF EXISTS "chemo_chairs_occupiedByPatientId_fkey";
ALTER TABLE IF EXISTS recovery_rooms DROP CONSTRAINT IF EXISTS "recovery_rooms_occupiedByPatientId_fkey";
ALTER TABLE IF EXISTS resources DROP CONSTRAINT IF EXISTS "resources_currentPatientId_fkey";
ALTER TABLE IF EXISTS waiting_room DROP CONSTRAINT IF EXISTS "waiting_room_patientId_fkey";

-- Drop existing tables
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS specialties CASCADE;
DROP TABLE IF EXISTS medical_centers CASCADE;
DROP TABLE IF EXISTS appointment_history CASCADE;

-- Create new tables
CREATE TABLE medical_centers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT,
    phone TEXT,
    email TEXT,
    tax_id TEXT
);

CREATE TABLE specialties (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description VARCHAR,
    icon VARCHAR
);

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    dni TEXT NOT NULL UNIQUE,
    email TEXT,
    phone TEXT,
    status TEXT DEFAULT 'active',
    specialty_id INTEGER REFERENCES specialties(id),
    medical_center_id INTEGER REFERENCES medical_centers(id)
);

CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    dni TEXT UNIQUE,
    phone TEXT,
    email TEXT,
    birth_date DATE,
    vital_status TEXT DEFAULT 'alive',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'active',
    document_type VARCHAR(20) DEFAULT 'DNI',
    document_number VARCHAR(20)
);

CREATE TABLE appointment_history (
    id SERIAL PRIMARY KEY,
    appointment_id INTEGER, -- No FK to appointments as requested
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    previous_status TEXT,
    new_status TEXT,
    comment TEXT
);
