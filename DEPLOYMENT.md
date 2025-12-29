# 🚀 APSIA - Deployment Summary

## ✅ Deployment Status: SUCCESSFUL

La aplicación **Appointment Central (APSIA)** ha sido desplegada exitosamente usando Docker Compose.

---

## 📊 Services Running

| Service | Container | Status | Port Mapping |
|---------|-----------|--------|--------------|
| **PostgreSQL** | `apsia_db` | ✅ Running | 5434:5432 |
| **Backend** | `apsia_backend` | ✅ Running | 4000:4000 |
| **Frontend** | `apsia_frontend` | ✅ Running | 5173:5173 |

---

## 🌐 Access URLs

- **Frontend Application**: https://localhost:5173
- **Backend API**: http://localhost:4000
- **PostgreSQL Database**: localhost:5434

---

## 📦 Populated Data

El sistema ha sido poblado con datos de prueba realistas:

### 🏥 Recursos Médicos
- **4 Consultorios**
  - 2 ocupados
  - 2 disponibles
  
- **9 Salas de Tratamiento** (Quimioterapia)
  - 5 ocupadas
  - 4 disponibles
  
- **4 Camas de Estancia** (Recuperación)
  - 2 ocupadas
  - 2 disponibles

### 👥 Datos de Pacientes y Citas
- **40 Pacientes** registrados con nombres realistas
- **30 Citas** programadas para hoy con diferentes estados:
  - 8 pacientes en check-in (esperando atención)
  - 7 pacientes en progreso (siendo atendidos)
  - 5 citas programadas
  - 10 citas completadas

### 👨‍⚕️ Personal Médico
- **5 Doctores** disponibles en diferentes especialidades:
  - Oncología Clínica (2)
  - Radioterapia (1)
  - Hematología (1)
  - Cirugía Oncológica (1)

### 📋 Cola de Espera
- **15 Pacientes** en cola con tickets numerados (T001-T015)
- Distribuidos en diferentes áreas de servicio:
  - Consulta General
  - Oncología
  - Quimioterapia
  - Radioterapia
  - Hematología

---

## 🔧 Technical Details

### Docker Configuration
- **Network**: `apsia-network` (bridge)
- **Volume**: `postgres_data` (persistent database storage)
- **Database**: PostgreSQL 15 Alpine

### Backend
- **Runtime**: Node.js 20 Alpine
- **Build**: TypeScript compiled to JavaScript
- **Dependencies**: Includes dev dependencies for migrations
- **Migrations**: ✅ All 9 migrations executed successfully

### Frontend
- **Framework**: Vue 3 + Vite
- **Proxy**: Configured to route `/api` and `/socket.io` to backend
- **SSL**: Self-signed certificate for HTTPS

---

## 🎯 Commands Reference

### Start all services
```bash
cd /home/devdisnovo/Documentos/PROYECTOS/testonkos/apsia/apsia
docker-compose up -d
```

### Stop all services
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Rebuild and restart
```bash
docker-compose down
docker-compose up -d --build
```

### Re-populate database
```bash
docker-compose exec backend npm run seed
```

### Access database directly
```bash
docker-compose exec db psql -U postgres -d appointment_central
```

---

## 📝 Notes

1. **Port 5434**: PostgreSQL usa el puerto 5434 externamente para evitar conflictos con otras instancias de PostgreSQL en el sistema.

2. **Self-signed Certificate**: El frontend usa un certificado autofirmado. Los navegadores mostrarán una advertencia de seguridad que debe aceptarse.

3. **Data Persistence**: Los datos de PostgreSQL se almacenan en un volumen Docker (`postgres_data`) y persisten entre reinicios.

4. **Hot Reload**: El frontend tiene hot-reload habilitado para desarrollo.

5. **Migrations**: Las migraciones se ejecutan automáticamente al iniciar el backend.

---

## 🐛 Troubleshooting

### Si el backend no inicia:
```bash
docker-compose logs backend
docker-compose restart backend
```

### Si la base de datos no conecta:
```bash
docker-compose restart db
# Esperar 5 segundos
docker-compose restart backend
```

### Limpiar y reiniciar desde cero:
```bash
docker-compose down -v  # ⚠️ Esto eliminará todos los datos
docker-compose up -d
docker-compose exec backend npm run seed
```

---

## ✨ Next Steps

1. Acceder a https://localhost:5173 para ver la aplicación
2. Navegar a la página de **Monitoring** para ver los recursos y la cola
3. Explorar las diferentes secciones de la aplicación
4. Revisar los datos de pacientes y citas

---

**Deployment Date**: 2025-12-11  
**Status**: ✅ Production Ready (Development Environment)
