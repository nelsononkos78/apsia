import { Request, Response } from 'express';
import { visionService } from '../services/vision.service';

/**
 * Process document image and extract complete data
 */
export const processDocument = async (req: Request, res: Response) => {
    try {
        const { image } = req.body;

        if (!image) {
            return res.status(400).json({ error: 'Image is required' });
        }

        // Remove data URL prefix if present
        const base64Image = image.replace(/^data:image\/[a-z]+;base64,/, '');

        // Extract full document data using AI vision
        const data = await visionService.extractDocumentData(base64Image);

        res.json(data);
    } catch (error: any) {
        console.error('Vision processing error:', error);
        res.status(500).json({ error: error.message || 'Error processing document' });
    }
};

/**
 * Extract only document ID (faster)
 */
export const extractDocumentId = async (req: Request, res: Response) => {
    try {
        const { image } = req.body;

        if (!image) {
            return res.status(400).json({ error: 'Image is required' });
        }

        // Remove data URL prefix if present
        const base64Image = image.replace(/^data:image\/[a-z]+;base64,/, '');

        // Extract only document ID using AI vision
        const documentId = await visionService.extractDocumentId(base64Image);

        res.json({ documentId });
    } catch (error: any) {
        console.error('OCR processing error:', error);
        res.status(500).json({ error: error.message || 'Error extracting document ID' });
    }
};
