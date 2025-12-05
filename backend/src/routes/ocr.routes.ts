import { Router } from 'express';
import { processDocument, extractDocumentId } from '../controllers/ocr.controller';

const router = Router();

// Public routes for check-in kiosks
router.post('/process', processDocument);
router.post('/extract-id', extractDocumentId);

export default router;
