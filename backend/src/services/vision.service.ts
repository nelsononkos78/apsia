import axios from 'axios';

interface DocumentData {
    documentId: string;
    fullName: string;
    birthDate: string;
    sex: string;
    address?: string;
}

export class VisionService {
    private apiKey: string;
    private apiUrl: string;
    private model: string;

    constructor() {
        this.apiKey = process.env.GROQ_API_KEY || '';
        this.apiUrl = process.env.GROQ_API_URL || 'https://api.groq.com/openai/v1/chat/completions';
        this.model = process.env.GROQ_MODEL || 'meta-llama/llama-4-scout-17b-16e-instruct';
    }

    /**
     * Extract complete document data from an image using Groq's AI vision model
     */
    async extractDocumentData(imageBase64: string): Promise<DocumentData> {
        try {
            const prompt = `Analiza esta imagen de un documento de identidad peruano (DNI o Carnet de Extranjería) y extrae la siguiente información en formato JSON:
{
  "documentId": "número de documento (solo números, 8 o 9 dígitos)",
  "fullName": "nombre completo (nombres y apellidos)",
  "birthDate": "fecha de nacimiento en formato DD/MM/YYYY",
  "sex": "Masculino o Femenino",
  "address": "dirección completa si está visible, sino cadena vacía"
}

IMPORTANTE:
- Si no puedes leer algún campo claramente, usa una cadena vacía ""
- El campo "address" puede estar en el reverso del documento, si no lo ves déjalo vacío
- Responde SOLO con el objeto JSON, sin texto adicional`;

            const response = await axios.post(
                this.apiUrl,
                {
                    model: this.model,
                    messages: [
                        {
                            role: 'user',
                            content: [
                                {
                                    type: 'text',
                                    text: prompt
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
                    max_tokens: 500
                },
                {
                    headers: {
                        'Authorization': `Bearer ${this.apiKey}`,
                        'Content-Type': 'application/json'
                    }
                }
            );

            const content = response.data.choices[0]?.message?.content || '{}';
            console.log('AI Vision Full Response:', content);

            // Remove markdown code blocks if present
            let cleanContent = content.replace(/```json\s*/g, '').replace(/```\s*/g, '');

            // Try to parse JSON from the response
            let jsonMatch = cleanContent.match(/\{[\s\S]*\}/);
            if (!jsonMatch) {
                throw new Error('No se pudo extraer datos del documento');
            }

            const data: DocumentData = JSON.parse(jsonMatch[0]);

            // Validate extracted data - Log warning but don't throw, let the caller decide
            if (!data.documentId || (data.documentId.length !== 8 && data.documentId.length !== 9)) {
                console.warn('Vision AI: Document ID not found or invalid');
            }

            return data;
        } catch (error: any) {
            console.error('Vision AI Error:', error.response?.data || error.message);
            // Return the actual error message to the frontend
            const errorMessage = error.response?.data?.error?.message || error.message || 'Error desconocido en Vision AI';
            throw new Error(`Error al procesar la imagen: ${errorMessage}`);
        }
    }

    /**
   * Extract document ID only (faster version)
   */
    async extractDocumentId(imageBase64: string): Promise<string> {
        try {
            const prompt = `Analiza esta imagen de un documento de identidad peruano y extrae SOLAMENTE el número de documento.
Puede ser:
- DNI: 8 dígitos
- Carnet de Extranjería: 9 dígitos

Responde únicamente con los dígitos del número de documento, sin espacios ni texto adicional.
Ejemplos de respuestas correctas:
12345678
123456789`;

            const response = await axios.post(
                this.apiUrl,
                {
                    model: this.model,
                    messages: [
                        {
                            role: 'user',
                            content: [
                                {
                                    type: 'text',
                                    text: prompt
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
                    temperature: 0,
                    max_tokens: 50
                },
                {
                    headers: {
                        'Authorization': `Bearer ${this.apiKey}`,
                        'Content-Type': 'application/json'
                    }
                }
            );

            const content = response.data.choices[0]?.message?.content || '';
            console.log('AI Vision Response:', content);

            // Extract all number sequences
            const numbers = content.match(/\d+/g);

            if (!numbers || numbers.length === 0) {
                throw new Error('No se detectó ningún número en el documento');
            }

            // Find DNI (8 digits) or Carnet de Extranjería (9 digits)
            const validDoc = numbers.find((n: string) => n.length === 8 || n.length === 9);

            if (validDoc) {
                console.log(`✓ Documento detectado: ${validDoc} (${validDoc.length} dígitos)`);
                return validDoc;
            }

            // If no exact match, look for longest number between 7-10 digits
            const candidates = numbers.filter((n: string) => n.length >= 7 && n.length <= 10);

            if (candidates.length > 0) {
                const longestNumber = candidates.reduce((a: string, b: string) =>
                    a.length > b.length ? a : b
                );

                // Adjust to closest valid length
                if (longestNumber.length === 7) {
                    const adjusted = longestNumber + '0'; // Pad to 8
                    console.log(`Ajustado de ${longestNumber} a ${adjusted} (DNI)`);
                    return adjusted;
                } else if (longestNumber.length === 10) {
                    const adjusted = longestNumber.slice(0, 9); // Trim to 9
                    console.log(`Ajustado de ${longestNumber} a ${adjusted} (Carnet)`);
                    return adjusted;
                }

                return longestNumber;
            }

            throw new Error('No se pudo detectar un número de documento válido (DNI o Carnet de Extranjería)');
        } catch (error: any) {
            console.error('Vision AI Error:', error.response?.data || error.message);
            throw new Error('Error al extraer número de documento');
        }
    }
}

export const visionService = new VisionService();
