import { Request, Response } from 'express';
import axios from 'axios';

/**
 * Process a document using OCR/LLM
 */
export const processDocument = async (req: Request, res: Response) => {
    try {
        const { imageBase64 } = req.body;

        if (!imageBase64) {
            return res.status(400).json({ error: 'No image provided' });
        }

        const llmProvider = process.env.LLM_PROVIDER || 'groq';
        const apiKey = process.env.GROQ_API_KEY;
        const apiUrl = process.env.GROQ_API_URL || 'https://api.groq.com/openai/v1/chat/completions';
        const model = process.env.GROQ_MODEL || 'meta-llama/llama-4-scout-17b-16e-instruct';

        if (!apiKey) {
            return res.status(500).json({ error: 'LLM API key not configured' });
        }

        // Call LLM API for OCR
        const response = await axios.post(
            apiUrl,
            {
                model,
                messages: [
                    {
                        role: 'user',
                        content: [
                            {
                                type: 'text',
                                text: 'Extract all text from this document image. Return only the extracted text.'
                            },
                            {
                                type: 'image_url',
                                image_url: {
                                    url: `data:image/jpeg;base64,${imageBase64}`
                                }
                            }
                        ]
                    }
                ],
                temperature: 0.1,
                max_tokens: 2000
            },
            {
                headers: {
                    'Authorization': `Bearer ${apiKey}`,
                    'Content-Type': 'application/json'
                }
            }
        );

        const extractedText = response.data.choices[0]?.message?.content || '';

        return res.json({
            success: true,
            text: extractedText
        });

    } catch (error: any) {
        console.error('OCR processing error:', error.response?.data || error.message);
        return res.status(500).json({
            error: 'Failed to process document',
            details: error.response?.data || error.message
        });
    }
};

/**
 * Extract document ID from an image
 */
export const extractDocumentId = async (req: Request, res: Response) => {
    try {
        const { imageBase64 } = req.body;

        if (!imageBase64) {
            return res.status(400).json({ error: 'No image provided' });
        }

        const llmProvider = process.env.LLM_PROVIDER || 'groq';
        const apiKey = process.env.GROQ_API_KEY;
        const apiUrl = process.env.GROQ_API_URL || 'https://api.groq.com/openai/v1/chat/completions';
        const model = process.env.GROQ_MODEL || 'meta-llama/llama-4-scout-17b-16e-instruct';

        if (!apiKey) {
            return res.status(500).json({ error: 'LLM API key not configured' });
        }

        // Call LLM API to extract ID
        const response = await axios.post(
            apiUrl,
            {
                model,
                messages: [
                    {
                        role: 'user',
                        content: [
                            {
                                type: 'text',
                                text: 'Extract the document ID number from this ID card or document. Return ONLY the ID number, nothing else.'
                            },
                            {
                                type: 'image_url',
                                image_url: {
                                    url: `data:image/jpeg;base64,${imageBase64}`
                                }
                            }
                        ]
                    }
                ],
                temperature: 0.1,
                max_tokens: 100
            },
            {
                headers: {
                    'Authorization': `Bearer ${apiKey}`,
                    'Content-Type': 'application/json'
                }
            }
        );

        const documentId = response.data.choices[0]?.message?.content?.trim() || '';

        return res.json({
            success: true,
            documentId
        });

    } catch (error: any) {
        console.error('Document ID extraction error:', error.response?.data || error.message);
        return res.status(500).json({
            error: 'Failed to extract document ID',
            details: error.response?.data || error.message
        });
    }
};
