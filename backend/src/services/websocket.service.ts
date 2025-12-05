import { Server as SocketIOServer } from 'socket.io';
import { Server as HTTPServer } from 'http';

export class WebSocketService {
    private io: SocketIOServer;

    constructor(httpServer: HTTPServer) {
        this.io = new SocketIOServer(httpServer, {
            cors: {
                origin: process.env.FRONTEND_URL || '*',
                methods: ['GET', 'POST']
            }
        });

        this.setupEventHandlers();
    }

    private setupEventHandlers() {
        this.io.on('connection', (socket) => {
            console.log(`Client connected: ${socket.id}`);

            // Join monitoring room
            socket.on('join:monitoring', () => {
                socket.join('monitoring');
                console.log(`Client ${socket.id} joined monitoring room`);
            });

            // Leave monitoring room
            socket.on('leave:monitoring', () => {
                socket.leave('monitoring');
                console.log(`Client ${socket.id} left monitoring room`);
            });

            socket.on('disconnect', () => {
                console.log(`Client disconnected: ${socket.id}`);
            });
        });
    }

    /**
     * Emitir actualización de recurso
     */
    emitResourceUpdate(resource: any) {
        this.io.to('monitoring').emit('resource:updated', resource);
    }

    /**
     * Emitir nuevo recurso creado
     */
    emitResourceCreated(resource: any) {
        this.io.to('monitoring').emit('resource:created', resource);
    }

    /**
     * Emitir actualización de sala de espera
     */
    emitWaitingRoomUpdate(record: any) {
        this.io.to('monitoring').emit('waitingRoom:updated', record);
    }

    /**
     * Emitir nuevo paciente en sala de espera
     */
    emitWaitingRoomAdded(record: any) {
        this.io.to('monitoring').emit('waitingRoom:added', record);
    }

    /**
     * Emitir paciente removido de sala de espera
     */
    emitWaitingRoomRemoved(recordId: number) {
        this.io.to('monitoring').emit('waitingRoom:removed', recordId);
    }

    /**
     * Emitir actualización de estadísticas
     */
    emitStatisticsUpdate(statistics: any) {
        this.io.to('monitoring').emit('statistics:updated', statistics);
    }

    /**
     * Obtener instancia de Socket.IO
     */
    getIO(): SocketIOServer {
        return this.io;
    }
}

// Singleton instance
let websocketService: WebSocketService | null = null;

export function initializeWebSocket(httpServer: HTTPServer): WebSocketService {
    if (!websocketService) {
        websocketService = new WebSocketService(httpServer);
    }
    return websocketService;
}

export function getWebSocketService(): WebSocketService {
    if (!websocketService) {
        throw new Error('WebSocket service not initialized');
    }
    return websocketService;
}
