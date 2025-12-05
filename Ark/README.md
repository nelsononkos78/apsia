# Appointment Central System

Sistema de Gestión de Citas, Check-in y Control de Cola para el Instituto Oncológico.

## Estructura del Proyecto

- **Backend**: Node.js, Express, TypeScript, Sequelize, SQLite.
- **Frontend**: Vue 3, TypeScript, Vite, Tailwind CSS, Pinia.

## Requisitos Previos

- Node.js (v18+)
- Docker & Docker Compose (Opcional)

## Instalación y Ejecución Local

### 1. Backend

```bash
cd backend
npm install
npm run migrate # Crear tablas
npm run seed    # Poblar datos de prueba
npm run dev     # Iniciar servidor en puerto 4000
```

### 2. Frontend

```bash
cd frontend
npm install
npm run dev     # Iniciar cliente en puerto 5173
```

## Ejecución con Docker

```bash
docker-compose up --build
```

## Accesos

- **Frontend**: [http://localhost:5173](http://localhost:5173)
- **Backend API**: [http://localhost:4000](http://localhost:4000)

## Credenciales de Prueba

- **Admin Login**:
  - Email: `admin@onkos.pe`
  - Password: `admin`

## Endpoints Principales

- `GET /api/patients`: Listar pacientes
- `GET /api/appointments`: Listar citas
- `GET /api/queue`: Ver cola de espera
- `GET /api/tv`: Datos para pantalla de TV

## Notas

- La base de datos es SQLite y se guarda en `backend/database.sqlite`.
- Para reiniciar la base de datos, ejecuta `npm run seed` nuevamente.
