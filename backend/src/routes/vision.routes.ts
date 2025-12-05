import { Router } from 'express';
import { processDocument, extractDocumentId } from '../controllers/vision.controller';

const router = Router();

// Public routes for check-in kiosks with AI vision
router.post('/analyze-document', processDocument);
router.post('/extract-id', extractDocumentId);

export default router;
