// Test WebSocket emissions
const io = require('socket.io-client');

const socket = io('http://localhost:4000', {
    transports: ['websocket', 'polling']
});

socket.on('connect', () => {
    console.log('✅ Connected to WebSocket');
    socket.emit('join:monitoring');
    console.log('📡 Joined monitoring room');
});

socket.on('resource:updated', (data) => {
    console.log('🔄 Resource updated:', data);
});

socket.on('resource:created', (data) => {
    console.log('➕ Resource created:', data);
});

socket.on('disconnect', () => {
    console.log('❌ Disconnected');
});

console.log('🔌 Connecting to WebSocket...');
