import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
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
// import ocrRoutes from './routes/ocr.routes';

dotenv.config();

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
        });
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
};

startServer();
