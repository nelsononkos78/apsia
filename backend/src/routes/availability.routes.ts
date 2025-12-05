import { Router } from 'express';
import { getAvailability } from '../controllers/availability.controller';

const router = Router();

// Public route - no auth required for checking availability
router.get('/', getAvailability);

export default router;
