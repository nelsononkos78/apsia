import { io, Socket } from 'socket.io-client';

class WebSocketService {
    private socket: Socket | null = null;
    private reconnectAttempts = 0;
    private maxReconnectAttempts = 5;
    private listeners: Map<string, Set<Function>> = new Map();

    constructor() {
        this.connect();
    }

    private connect() {
        // Usar la misma URL del frontend - Vite proxy manejará la conexión
        const SOCKET_URL = window.location.origin;

        this.socket = io(SOCKET_URL, {
            path: '/socket.io',
            transports: ['websocket', 'polling'],
            reconnection: true,
            reconnectionDelay: 1000,
            reconnectionDelayMax: 5000,
            reconnectionAttempts: this.maxReconnectAttempts
        });

        this.setupEventHandlers();
    }

    private setupEventHandlers() {
        if (!this.socket) return;

        this.socket.on('connect', () => {
            console.log('✅ WebSocket connected');
            this.reconnectAttempts = 0;
            this.joinMonitoring();
        });

        this.socket.on('disconnect', (reason) => {
            console.log('❌ WebSocket disconnected:', reason);
        });

        this.socket.on('connect_error', (error) => {
            console.error('WebSocket connection error:', error);
            this.reconnectAttempts++;

            if (this.reconnectAttempts >= this.maxReconnectAttempts) {
                console.error('Max reconnection attempts reached');
            }
        });

        // Resource events
        this.socket.on('resource:updated', (resource) => {
            console.log('📥 WebSocket received resource:updated', resource);
            this.emit('resource:updated', resource);
        });

        this.socket.on('resource:created', (resource) => {
            console.log('📥 WebSocket received resource:created', resource);
            this.emit('resource:created', resource);
        });

        // Waiting room events
        this.socket.on('waitingRoom:updated', (record) => {
            console.log('📥 WebSocket received waitingRoom:updated', record);
            this.emit('waitingRoom:updated', record);
        });

        this.socket.on('waitingRoom:added', (record) => {
            console.log('📥 WebSocket received waitingRoom:added', record);
            this.emit('waitingRoom:added', record);
        });

        this.socket.on('waitingRoom:removed', (recordId) => {
            console.log('📥 WebSocket received waitingRoom:removed', recordId);
            this.emit('waitingRoom:removed', recordId);
        });

        // Statistics events
        this.socket.on('statistics:updated', (statistics) => {
            console.log('📥 WebSocket received statistics:updated', statistics);
            this.emit('statistics:updated', statistics);
        });

        // TV events
        this.socket.on('tv:state-updated', (state) => {
            console.log('📥 WebSocket received tv:state-updated', state);
            this.emit('tv:state-updated', state);
        });

        this.socket.on('tv:call', (data) => {
            console.log('📥 WebSocket received tv:call', data);
            this.emit('tv:call', data);
        });

        // Appointment events
        this.socket.on('appointment:updated', (appointment) => {
            console.log('📥 WebSocket received appointment:updated', appointment);
            this.emit('appointment:updated', appointment);
        });

        this.socket.on('appointment:created', (appointment) => {
            console.log('📥 WebSocket received appointment:created', appointment);
            this.emit('appointment:created', appointment);
        });
    }

    public joinMonitoring() {
        if (this.socket?.connected) {
            this.socket.emit('join:monitoring');
        }
    }

    /**
     * Subscribe to an event
     */
    on(event: string, callback: Function) {
        if (!this.listeners.has(event)) {
            this.listeners.set(event, new Set());
        }
        this.listeners.get(event)!.add(callback);
    }

    /**
     * Unsubscribe from an event
     */
    off(event: string, callback: Function) {
        const eventListeners = this.listeners.get(event);
        if (eventListeners) {
            eventListeners.delete(callback);
        }
    }

    /**
     * Emit event to local listeners
     */
    private emit(event: string, data: any) {
        const eventListeners = this.listeners.get(event);
        if (eventListeners) {
            eventListeners.forEach(callback => callback(data));
        }
    }

    /**
     * Check if connected
     */
    isConnected(): boolean {
        return this.socket?.connected || false;
    }

    /**
     * Disconnect
     */
    disconnect() {
        if (this.socket) {
            this.socket.emit('leave:monitoring');
            this.socket.disconnect();
        }
    }

    /**
     * Reconnect
     */
    reconnect() {
        if (this.socket) {
            this.socket.connect();
        }
    }
}

// Singleton instance
export const websocketService = new WebSocketService();
