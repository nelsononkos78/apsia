import { Router } from 'express';
import { getServiceTypes } from '../controllers/service-type.controller';

const router = Router();

router.get('/', getServiceTypes);

export default router;
