import dotenv from 'dotenv';
dotenv.config();

import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { sequelize } from './config/database';
import { errorHandler } from './middleware/error.handler';
import authRoutes from './routes/auth.routes';
import patientRoutes from './routes/patient.routes';
import appointmentRoutes from './routes/appointment.routes';
import queueRoutes from './routes/queue.routes';
import tvRoutes from './routes/tv.routes';
import specialtyRoutes from './routes/specialty.routes';
import availabilityRoutes from './routes/availability.routes';
import visionRoutes from './routes/vision.routes';
import resourceRoutes from './routes/resource.routes';
import waitingRoomRoutes from './routes/waiting-room.routes';
import monitoringRoutes from './routes/monitoring.routes';
import internalFlowRoutes from './routes/internal-flow.routes';
import checkinRoutes from './routes/checkin.routes';
import serviceTypeRoutes from './routes/service-type.routes';
import doctorRoutes from './routes/doctor.routes';
import dashboardRoutes from './routes/dashboard.routes';
import physicalExamRoutes from './routes/physical-exam.routes';
// import ocrRoutes from './routes/ocr.routes';



const app = express();
const PORT = parseInt(process.env.PORT || '4000', 10);

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json({ limit: '50mb' })); // Increased for image uploads
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/queue', queueRoutes);
app.use('/api/tv', tvRoutes);
app.use('/api', specialtyRoutes);
app.use('/api/availability', availabilityRoutes);
app.use('/api/vision', visionRoutes);
app.use('/api/resources', resourceRoutes);
app.use('/api/waiting-room', waitingRoomRoutes);
app.use('/api/monitoring', monitoringRoutes);
app.use('/api/internal', internalFlowRoutes);
app.use('/api/checkin', checkinRoutes);
app.use('/api/service-types', serviceTypeRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/physical-exam', physicalExamRoutes);
// app.use('/api/ocr', ocrRoutes);

app.get('/', (req: Request, res: Response) => {
    res.json({ message: 'Appointment Central API is running' });
});

// Error Handler
app.use(errorHandler);

// Start Server
const startServer = async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connected.');

        // Sync models (in development, alter: true is okay, but migrations are better)
        // Start server
        sequelize.sync().then(() => {
            console.log('Database synced.');

            const httpServer = app.listen(PORT, '0.0.0.0', () => {
                console.log(`Server running on port ${PORT}`);
                console.log(`Backend accessible at http://localhost:${PORT}`);
            });

            // Initialize WebSocket
            const { initializeWebSocket } = require('./services/websocket.service');
            initializeWebSocket(httpServer);
            console.log('WebSocket initialized.');

            // Cleanup old appointments on startup
            const { NoShowService } = require('./services/noshow.service');
            console.log('[Startup] Ejecutando limpieza de citas antiguas...');
            NoShowService.cleanupOldAppointments().then((count: number) => {
                console.log(`[Startup] Limpieza completada: ${count} citas marcadas como NO_SHOW.`);
            });

            // Tarea programada para las 11 PM (No Show)
            // Ejecuta el proceso diario para marcar citas pendientes del día como NO_SHOW
            setInterval(() => {
                const now = new Date();
                if (now.getHours() === 23 && now.getMinutes() === 0) {
                    console.log('[Cron] Iniciando proceso diario de No Show...');
                    NoShowService.processDailyNoShows();
                }
            }, 60000); // Revisar cada minuto

            // Ejecutar limpieza de citas antiguas cada hora
            setInterval(() => {
                console.log('[Cron] Ejecutando limpieza de citas antiguas...');
                NoShowService.cleanupOldAppointments();
            }, 3600000); // Cada hora (3600000 ms)
        });
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
};

startServer();
