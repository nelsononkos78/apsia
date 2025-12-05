import { Router } from 'express';
import { getQueue, nextPatient } from '../controllers/queue.controller';
import { authenticateToken } from '../middleware/auth.middleware';

const router = Router();

router.get('/', authenticateToken, getQueue);
router.post('/next', authenticateToken, nextPatient);

export default router;
