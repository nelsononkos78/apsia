## INIT.MD

# Prompt maestro para Cursor — Sistema de Gestión de Citas, Check-in y Control de Cola (Instituto Oncológico)

> Este documento contiene un **prompt listo para pegar en Cursor** (modo generación de proyecto o como archivo `.prompt`) que le indica a Cursor cómo generar **todo** el prototipo funcional: backend + frontend + migraciones + seeds + docker-compose + instrucciones paso a paso.

---
---

# 🏥 **PROYECTO: Sistema de Gestión de Citas, Check-in y Control de Cola — Instituto Oncológico**

### Objetivo

Construir un **prototipo funcional completo** que incluya todas las pantallas, flujos, rutas, componentes, datos de prueba y lógica base del sistema.

Las pantallas y las funciones deben estar conectadas en un flujo real utilizando Vue Router, Pinia, APIs REST y SQLite mediante Sequelize.

## 1) Instrucción general (System / primer mensaje)

Eres un **arquitecto senior fullstack** experto en Node.js, TypeScript, Express, Vue 3, Tailwind y sistemas clínicos.  
Tu tarea es **generar automáticamente toda la estructura del proyecto**, incluyendo backend, frontend y un prototipo navegable completo, basado exactamente en las definiciones iniciales dadas.

Genera código real, limpio, ordenado, modular y funcional.

Eres un **arquitecto fullstack senior** y generador de proyectos listo para producir código de alta calidad. Genera **un proyecto completo** con backend y frontend, listo para ejecutar localmente y contener:

- Código fuente del backend (Express + TypeScript + Sequelize + SQLite).    
- Código fuente del frontend (Vue 3 + TypeScript + Vite + Tailwind + Pinia + Vue Router).    
- Migraciones y seeders para poblar datos de prueba.    
- Scripts `npm` para iniciar backend y frontend en modo desarrollo.    
- Dockerfile para backend y frontend y `docker-compose.yml` para levantar la app completa.    
- README con instrucciones claras de instalación y ejecución.    

Debes generar archivos completos, con contenido funcional, comentarios explicativos y estructura modular. El proyecto debe ser instalable con:

```
# backend
cd backend
npm install
npm run migrate
npm run seed
npm run dev

# frontend
cd frontend
npm install
npm run dev
```

Genera tests básicos (opcional) y asegúrate que las rutas y stores funcionen con datos simulados.

---

## 2) Estructura general a crear

```
/project-root
  /backend
  /frontend
  docker-compose.yml
  README.md
```

---

## 3) Backend — requisitos detallados

Genera un proyecto Node.js + TypeScript con la siguiente estructura mínima y archivos funcionales:

```
/backend
  package.json
  tsconfig.json
  .env.example
  Dockerfile
  /src
    server.ts
    /config
      database.ts
      jwt.ts
    /models
      index.ts
      patient.model.ts
      staff.model.ts
      appointment.model.ts
      queue.model.ts
      chemoChair.model.ts
      recoveryRoom.model.ts
    /migrations
      (migrations for tables)
    /seeders
      (seed data)
    /controllers
      auth.controller.ts
      patient.controller.ts
      appointment.controller.ts
      queue.controller.ts
      tv.controller.ts
      ocr.controller.ts  # mock
    /routes
      auth.routes.ts
      patient.routes.ts
      appointment.routes.ts
      queue.routes.ts
      tv.routes.ts
    /services
      queue.service.ts
      ocr.service.ts # simulated OCR
    /middleware
      auth.middleware.ts
      logger.middleware.ts
      error.handler.ts
    /utils
      qr.util.ts
      helpers.ts
```

### Dependencias (package.json)

- express    
- typescript    
- ts-node-dev (dev)    
- sequelize    
- sqlite3    
- sequelize-typescript or @types/sequelize (type bindings)    
- multer    
- jsonwebtoken    
- helmet    
- morgan    
- axios    
- cors    
- dotenv    

Incluye tipos `@types/` cuando corresponda.

### Funcionalidades clave a implementar

- CRUD básico para pacientes `/patients`.    
- CRUD y lógica de citas `/appointments` (crear, listar, disponibilidad).    
- Endpoints de check-in `/appointments/:id/checkin` y de cambio de estado `/appointments/:id/state`.    
- Endpoints de turnero `/queue` para obtener la cola actual y para avanzar al siguiente paciente `/queue/next?service=...`.    
- Endpoint `/ocr/id` que reciba una imagen (Multer) y devuelva datos extraídos simulados (mock) — suficiente para el prototipo.    
- Servicio de colas en memoria con persistencia básica en SQLite usando Sequelize.    
- Seeders que creen: 30 pacientes, 50 citas (varias en el día), 9 sillas de quimio (estado), 2 habitaciones de recuperación.    
- Logger con Morgan y seguridad con Helmet.    
- Middleware de manejo de errores y validaciones simples.    
- Lectura de imagen del documento de identidad con IA para extraer los datos del paciente.

Asegúrate que las rutas devuelvan JSON coherente con datos reales y simulados.

---

## 4) Frontend — requisitos detallados

Genera un proyecto Vite + Vue 3 + TypeScript con la siguiente estructura:

```
/frontend
  package.json
  tsconfig.json
  vite.config.ts
  tailwind.config.js
  postcss.config.js
  Dockerfile
  /src
    main.ts
    App.vue
    /assets
    /router
      index.ts
    /stores
      auth.ts
      appointments.ts
      queue.ts
      chemo.ts
    /views
      PatientPortal.vue
      BookAppointment.vue
      CalendarView.vue
      MyAppointments.vue
      CounterLogin.vue
      ReceptionSearch.vue
      Checkin.vue
      TVDisplay.vue
      Consultorio.vue
      Laboratorio.vue
      Quimioterapia.vue
      Recuperacion.vue
      AdminDashboard.vue
    /components
      Header.vue
      Footer.vue
      AppointmentForm.vue
      CalendarComponent.vue
      QRCard.vue
      QueueList.vue
      ChemoMap.vue
      PatientCard.vue
      LoginForm.vue
    /services
      api.ts  # axios instance
      auth.service.ts
      appointment.service.ts
      queue.service.ts
    /utils
      format.ts
      mocks.ts
    /styles
      globals.css (Tailwind)
```

### UI & UX

- Usa Tailwind para implementar la paleta: `#2BB88A`, `#F4F6F8`, blanco y naranja `#F5A623`/rojo suave.    
- Tipografía `font-sans` (Tailwind). Asegura accesibilidad: tamaños, contrastes y botones grandes.    
- Todas las vistas deben estar enlazadas con Vue Router y tener rutas protegidas para áreas de staff (Counter, Consultorios, Admin).    

### Funcionalidad mínima por vista

- **Book Appointment**: Formulario con selector de servicio + CalendarView para elegir fecha/hora; envía POST a `/appointments`.    
- **CalendarView**: muestra disponibilidad y slots (usando datos del endpoint de disponibilidad).    
- **MyAppointments**: lista de citas del paciente con estados y posibilidad de cancelar.    
- **CounterLogin / ReceptionSearch / Checkin**: buscar paciente, ver citas, realizar check-in y cambiar estado.    
- **TVDisplay**: pantalla pública que hace polling a `/queue` cada 5-10s y renderiza lista tipo turnero con animación simple cuando cambia el `current`.    
- **Consultorio / Laboratorio / Quimioterapia / Recuperacion**: vistas con acciones para llamar siguiente paciente, cambiar estados y ver mapa de sillas (drag & drop para Quimio; usar `vuedraggable` or simple drag-drop mock).    
- **AdminDashboard**: gráficos simples (usar Chart.js) que consumen endpoints de stats (ej: `/admin/stats`).   
Añade notificaciones con `Vue Toastification` y manejo de errores. Usa Pinia para stores y organiza la lógica (auth, appointments, queue, chemo).
Genera datos mock integrados y también instrucciones para conectar con el backend real si el usuario corre ambos servicios.

---

## 5) Migrations / Seeders

Genera scripts de migración usando Sequelize CLI (o script TypeScript equivalente) que creen tablas necesarias.
Seeders deben poblar la base con datos realistas: pacientes con nombres, edades, citas en distintos estados, ocupación de sillas de quimio y recuperación.
Incluye comando `npm run migrate` y `npm run seed` en package.json del backend.

---

## 6) Despliegue
- service: backend (puerto 4000)    
- service: frontend (puerto 5173)        

---

## 7) Scripts `package.json` importantes

**Backend**

- `dev`: `ts-node-dev src/server.ts`    
- `build`: `tsc`    
- `migrate`: script que corre migraciones    
- `seed`: script que corre seeders    
- `start`: `node dist/server.js`    

**Frontend**

- `dev`: `vite`    
- `build`: `vite build`    
- `preview`: `vite preview`    

---

Generate full project: backend + frontend + docker-compose + migrations + seeders + README"
   
**C) Generate with automatic migrations**

- Add `npm run migrate` script that uses Sequelize programmatic migrations.    

**D) Generate Docker-compose**

- As described in section 6. Include env examples and notes for production.    

---

## 9) README.md (contenido a generar)

README must include:

- Overview    
- Tech stack    
- Prerequisites    
- Environment variables list (.env.example)    
- How to run migrations and seeders    
- How to access frontend ([http://localhost:5173](http://localhost:5173/)) and backend ([http://localhost:4000](http://localhost:4000/))    
- Useful endpoints    

---

## 10) Entregables finales y verificación

Al terminar la generación, Cursor debe entregar:

1. Mensaje con checklist "Files created" con los paths y comandos para correr.        
2. `README.md` completo.    
3. Indicación clara para correr migraciones y seeds.    
4. Opcional: archivo `.cursor-commands.txt` con instrucciones de comandos para ejecutar en terminal.    

---

## 11) Solicitud final para Cursor (texto exacto de ejecución)

> "Genera el proyecto completo siguiendo las instrucciones de este documento.> 
> - Modo: **Full generate** (si puedes elegir: full).>     
> - Incluye: backend (Express + TS + Sequelize + SQLite + Multer + JWT + Helmet + Morgan), frontend (Vue3 + TS + Vite + Tailwind + Pinia + Vue Router + Toastification), migraciones, seeders, README, y scripts `npm run migrate` y `npm run seed`.>     
> - Genera también una variante step-by-step (dividida en 6 pasos) con checklist.>     
> - Asegúrate que `npm install` + `npm run dev` (backend y frontend) funcione.>     
> - Provee instrucciones exactas para ejecutar en local"
>     

---

## 12) Notas de seguridad y privacidad

- Por seguridad habilita Helmet y CORS correctamente.    
- Los JWT deben usar secret en `.env`.    

---

## 13) Ejemplo mínimo de `.env.example` (backend)

```
PORT=4000
DATABASE_URL=sqlite://./database.sqlite
JWT_SECRET=change_this_secret
NODE_ENV=development
```

## 14) Ejemplo mínimo de `.env.example` (frontend)

```
VITE_API_URL=http://localhost:4000/api
```

