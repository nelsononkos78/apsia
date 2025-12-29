import { Router } from 'express';
import { CheckinController } from '../controllers/checkin.controller';

const router = Router();

router.get('/search', CheckinController.searchPatient);
router.post('/register', CheckinController.registerPatient);
router.post('/create-ticket', CheckinController.createTicket);

export default router;
