import { Router } from 'express';
import { MonitoringController } from '../controllers/monitoring.controller';

const router = Router();
const monitoringController = new MonitoringController();

// Obtener snapshot completo del sistema
router.get('/snapshot', monitoringController.getSnapshot);

// Obtener estadísticas diarias
router.get('/statistics', monitoringController.getDailyStatistics);

// Verificar disponibilidad de recursos
router.get('/availability', monitoringController.checkAvailability);

// Obtener ocupación de un recurso específico
router.get('/resource/:id/occupancy', monitoringController.getResourceOccupancy);

export default router;
