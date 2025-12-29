import { Router } from 'express';
import { DoctorController } from '../controllers/doctor.controller';

const router = Router();
const doctorController = new DoctorController();

router.get('/dashboard', doctorController.getDashboardData);
router.post('/call', doctorController.callPatient);
router.post('/start', doctorController.startConsultation);
router.post('/finish', doctorController.finishConsultation);

export default router;
