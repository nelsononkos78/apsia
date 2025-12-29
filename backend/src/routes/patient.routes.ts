import { Router } from 'express';
import { getPatients, createPatient } from '../controllers/patient.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.get('/', getPatients); // Public for check-in kiosks
router.post('/', createPatient);

export default router;
