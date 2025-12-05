# Database Migrations

Este directorio contiene las migraciones de la base de datos PostgreSQL para el sistema Appointment Central.

## 📋 Estructura de Migraciones

Las migraciones están numeradas secuencialmente y deben ejecutarse en orden:

1. **001-create-patients-table.ts** - Tabla de pacientes
2. **002-create-doctors-table.ts** - Tabla de doctores
3. **003-create-staff-table.ts** - Tabla de personal
4. **004-create-resources-table.ts** - Tabla de recursos (consultorios, salas de tratamiento, camas)
5. **005-create-appointments-table.ts** - Tabla de citas
6. **006-create-waiting-room-table.ts** - Tabla de sala de espera
7. **007-create-queues-table.ts** - Tabla de colas/turnos
8. **008-create-chemo-chairs-table.ts** - Tabla de sillas de quimioterapia
9. **009-create-recovery-rooms-table.ts** - Tabla de habitaciones de recuperación

## 🚀 Cómo Ejecutar las Migraciones

### Prerequisitos

1. Tener PostgreSQL instalado y corriendo
2. Crear una base de datos:
   ```bash
   createdb appointment_central
   ```

3. Configurar las variables de entorno en `.env`:
   ```env
   DATABASE_URL=postgresql://username:password@localhost:5432/appointment_central
   ```

### Ejecutar Migraciones

```bash
npm run migrate:postgres
```

Este comando ejecutará todas las migraciones en orden y creará todas las tablas necesarias.

## 🔄 Cambiar entre SQLite y PostgreSQL

El sistema soporta tanto SQLite como PostgreSQL. Para cambiar entre ellos, simplemente modifica la variable `DATABASE_URL` en tu archivo `.env`:

**Para PostgreSQL:**
```env
DATABASE_URL=postgresql://username:password@localhost:5432/appointment_central
```

**Para SQLite:**
```env
DATABASE_URL=sqlite://./database.sqlite
```

## 📊 Esquema de Base de Datos

### Tablas Principales

- **patients**: Información de pacientes
- **doctors**: Información de doctores y especialidades
- **staff**: Personal del sistema (admin, enfermeras, recepcionistas)
- **appointments**: Citas médicas
- **resources**: Recursos físicos (consultorios, salas, camas)
- **waiting_room**: Gestión de sala de espera
- **queues**: Sistema de turnos
- **chemo_chairs**: Sillas de quimioterapia
- **recovery_rooms**: Habitaciones de recuperación

### Índices

Todas las tablas incluyen índices optimizados para:
- Búsquedas por foreign keys
- Filtros por estado/status
- Búsquedas por fecha
- Campos únicos (documentId, email, etc.)

## 🛠️ Crear una Nueva Migración

Para crear una nueva migración:

1. Crea un nuevo archivo en `src/migrations/` con el formato:
   ```
   XXX-descripcion-de-la-migracion.ts
   ```
   Donde XXX es el siguiente número secuencial.

2. Usa la siguiente plantilla:

```typescript
import { QueryInterface, DataTypes } from 'sequelize';

export default {
  up: async (queryInterface: QueryInterface): Promise<void> => {
    // Código para aplicar la migración
  },

  down: async (queryInterface: QueryInterface): Promise<void> => {
    // Código para revertir la migración
  },
};
```

## ⚠️ Notas Importantes

- Las migraciones se ejecutan en orden numérico
- Si una tabla ya existe, la migración se saltará automáticamente
- Siempre haz backup de tu base de datos antes de ejecutar migraciones en producción
- Las migraciones incluyen manejo de foreign keys con CASCADE y SET NULL apropiados

## 🔍 Verificar el Estado de la Base de Datos

Puedes conectarte a PostgreSQL para verificar las tablas creadas:

```bash
psql -d appointment_central -U username
```

Luego ejecuta:
```sql
\dt  -- Listar todas las tablas
\d table_name  -- Ver estructura de una tabla específica
```
