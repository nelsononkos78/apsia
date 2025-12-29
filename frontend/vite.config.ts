import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import basicSsl from '@vitejs/plugin-basic-ssl'

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        vue(),
        basicSsl()
    ],
    server: {
        host: '0.0.0.0',
        port: 5173,
        proxy: {
            '/api': {
                target: process.env.VITE_API_TARGET || 'http://localhost:4000',
                changeOrigin: true,
            },
            '/socket.io': {
                target: process.env.VITE_API_TARGET || 'http://localhost:4000',
                changeOrigin: true,
                ws: true, // Habilitar proxy de WebSocket
            }
        }
    }
})
