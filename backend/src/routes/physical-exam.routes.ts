import { Router } from 'express';
import { PhysicalExamController } from '../controllers/physical-exam.controller';

const router = Router();
const controller = new PhysicalExamController();

router.post('/', controller.savePhysicalExam);
router.get('/appointment/:appointmentId', controller.getPhysicalExam);
router.get('/patient/:patientId/allergies', controller.getPatientAllergies);
router.post('/allergies', controller.addAllergy);
router.delete('/allergies/:id', controller.removeAllergy);

export default router;
