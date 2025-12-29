import { Router } from 'express';
import { WaitingRoomController } from '../controllers/waiting-room.controller';

const router = Router();
const waitingRoomController = new WaitingRoomController();

// Obtener lista actual de espera
router.get('/current', waitingRoomController.getCurrentList.bind(waitingRoomController));

// Obtener todos los registros
router.get('/', waitingRoomController.getAllRecords.bind(waitingRoomController));

// Obtener estadísticas
router.get('/statistics', waitingRoomController.getStatistics.bind(waitingRoomController));

// Agregar paciente a la sala de espera
router.post('/', waitingRoomController.addPatient.bind(waitingRoomController));

// Llamar a un paciente
router.post('/:id/call', waitingRoomController.callPatient.bind(waitingRoomController));

// Marcar como atendido
router.post('/:id/attend', waitingRoomController.markAsAttended.bind(waitingRoomController));

// Remover de la sala de espera
router.delete('/:id', waitingRoomController.removePatient.bind(waitingRoomController));

export default router;
