import { Router } from 'express';
import { getTvState } from '../controllers/tv.controller';

const router = Router();

router.get('/state', getTvState);

export default router;
