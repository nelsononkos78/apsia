import { Router } from 'express';
import { getSpecialties, getDoctors } from '../controllers/specialty.controller';

const router = Router();

// Public routes - no auth required for booking
router.get('/specialties', getSpecialties);
router.get('/doctors', getDoctors);

export default router;
