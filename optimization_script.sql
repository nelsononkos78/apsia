-- 1. Clean Orphaned Data (Set invalid FKs to NULL)
UPDATE appointments SET "doctorId" = NULL WHERE "doctorId" IS NOT NULL AND "doctorId" NOT IN (SELECT id FROM doctors);
UPDATE appointments SET "patientId" = NULL WHERE "patientId" IS NOT NULL AND "patientId" NOT IN (SELECT id FROM patients);
UPDATE chemo_chairs SET "occupiedByPatientId" = NULL WHERE "occupiedByPatientId" IS NOT NULL AND "occupiedByPatientId" NOT IN (SELECT id FROM patients);
UPDATE recovery_rooms SET "occupiedByPatientId" = NULL WHERE "occupiedByPatientId" IS NOT NULL AND "occupiedByPatientId" NOT IN (SELECT id FROM patients);
UPDATE resources SET "currentPatientId" = NULL WHERE "currentPatientId" IS NOT NULL AND "currentPatientId" NOT IN (SELECT id FROM patients);
UPDATE waiting_room SET "patientId" = NULL WHERE "patientId" IS NOT NULL AND "patientId" NOT IN (SELECT id FROM patients);

-- 2. Restore Foreign Keys
ALTER TABLE appointments 
    ADD CONSTRAINT "appointments_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES doctors(id) ON DELETE SET NULL,
    ADD CONSTRAINT "appointments_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES patients(id) ON DELETE CASCADE;

ALTER TABLE chemo_chairs 
    ADD CONSTRAINT "chemo_chairs_occupiedByPatientId_fkey" FOREIGN KEY ("occupiedByPatientId") REFERENCES patients(id) ON DELETE SET NULL;

ALTER TABLE recovery_rooms 
    ADD CONSTRAINT "recovery_rooms_occupiedByPatientId_fkey" FOREIGN KEY ("occupiedByPatientId") REFERENCES patients(id) ON DELETE SET NULL;

ALTER TABLE resources 
    ADD CONSTRAINT "resources_currentPatientId_fkey" FOREIGN KEY ("currentPatientId") REFERENCES patients(id) ON DELETE SET NULL;

ALTER TABLE waiting_room 
    ADD CONSTRAINT "waiting_room_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES patients(id) ON DELETE CASCADE;

-- 3. Add Performance Indexes
-- Appointments
CREATE INDEX IF NOT EXISTS "idx_appointments_doctorId" ON appointments("doctorId");
CREATE INDEX IF NOT EXISTS "idx_appointments_patientId" ON appointments("patientId");
CREATE INDEX IF NOT EXISTS "idx_appointments_date" ON appointments("date");
CREATE INDEX IF NOT EXISTS "idx_appointments_status" ON appointments("status");

-- Doctors
CREATE INDEX IF NOT EXISTS "idx_doctors_specialty_id" ON doctors(specialty_id);
CREATE INDEX IF NOT EXISTS "idx_doctors_medical_center_id" ON doctors(medical_center_id);

-- Patients
CREATE INDEX IF NOT EXISTS "idx_patients_dni" ON patients(dni);
CREATE INDEX IF NOT EXISTS "idx_patients_name" ON patients USING btree (name);
