import { Router } from 'express';
import { InternalFlowController } from '../controllers/internal-flow.controller';

const router = Router();

router.post('/recipe', InternalFlowController.createRecipe);
router.post('/quote', InternalFlowController.createQuote);
router.post('/approve-quote', InternalFlowController.approveQuote);
router.post('/program-session', InternalFlowController.programSession);

export default router;
