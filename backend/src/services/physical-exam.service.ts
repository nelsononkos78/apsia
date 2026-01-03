import { PhysicalExam, Allergy, Appointment, Patient } from '../models';

export class PhysicalExamService {
    async createOrUpdatePhysicalExam(data: any) {
        const { appointmentId, patientId, staffId, ...examData } = data;

        let exam = await PhysicalExam.findOne({ where: { appointmentId } });

        if (exam) {
            await exam.update(examData);
        } else {
            exam = await PhysicalExam.create({
                appointmentId,
                patientId,
                staffId,
                ...examData
            });
        }

        // Mark triaje as completed in appointment
        await Appointment.update(
            { triajeCompleted: true },
            { where: { id: appointmentId } }
        );

        return exam;
    }

    async getPhysicalExamByAppointment(appointmentId: number) {
        return await PhysicalExam.findOne({
            where: { appointmentId },
            include: ['staff']
        });
    }

    async getPatientAllergies(patientId: number) {
        return await Allergy.findAll({
            where: { patientId, isActive: true }
        });
    }

    async addAllergy(data: any) {
        return await Allergy.create(data);
    }

    async removeAllergy(id: number) {
        const allergy = await Allergy.findByPk(id);
        if (allergy) {
            allergy.isActive = false;
            await allergy.save();
        }
        return allergy;
    }
}
