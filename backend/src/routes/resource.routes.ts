import { Router } from 'express';
import { ResourceController } from '../controllers/resource.controller';

const router = Router();
const resourceController = new ResourceController();

// Obtener todos los recursos
router.get('/', resourceController.getAllResources.bind(resourceController));

// Obtener estadísticas de recursos
router.get('/statistics', resourceController.getStatistics.bind(resourceController));

// Obtener recursos por tipo
router.get('/type/:type', resourceController.getResourcesByType.bind(resourceController));

// Obtener recursos disponibles por tipo
router.get('/available/:type', resourceController.getAvailableResources.bind(resourceController));

// Obtener un recurso por ID
router.get('/:id', resourceController.getResourceById.bind(resourceController));

// Crear un nuevo recurso
router.post('/', resourceController.createResource.bind(resourceController));

// Actualizar estado de un recurso
router.put('/:id/status', resourceController.updateResourceStatus.bind(resourceController));
router.post('/:id/call-next', resourceController.callNextPatient.bind(resourceController));

// Asignar paciente a un recurso
router.post('/:id/assign', resourceController.assignPatient.bind(resourceController));

// Liberar un recurso
router.post('/:id/release', resourceController.releaseResource.bind(resourceController));

export default router;
