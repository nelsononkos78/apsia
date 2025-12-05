import { Router } from 'express';
import { getAppointments, createAppointment, checkInAppointment } from '../controllers/appointment.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.get('/', getAppointments); // Público para el panel de monitoreo
router.post('/', createAppointment); // Public for patient booking
router.post('/:id/checkin', checkInAppointment); // Public for check-in kiosks

export default router;
