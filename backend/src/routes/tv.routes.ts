import { Router } from 'express';
import { getTvState } from '../controllers/tv.controller';

const router = Router();

router.get('/', getTvState);

export default router;
