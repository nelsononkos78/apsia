--
-- PostgreSQL database dump
--

\restrict 7zFGx6hPtJ1MjPcfAjUzkOQBFxQxDDfBPi3Qeln9WLluPFcDMI9dfiWht6QOqfM

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enum_appointments_internalStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_appointments_internalStatus" AS ENUM (
    'NONE',
    'RECIPE_REGISTERED',
    'PENDING_QUOTE',
    'QUOTE_READY',
    'QUOTE_WITH_STOCK',
    'QUOTE_SENT',
    'QUOTE_APPROVED',
    'SESSION_PROGRAMMED'
);


ALTER TYPE public."enum_appointments_internalStatus" OWNER TO postgres;

--
-- Name: enum_appointments_serviceType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_appointments_serviceType" AS ENUM (
    'CONSULTATION',
    'LABORATORY',
    'CONSULTATION_NEW',
    'CONSULTATION_FOLLOWUP',
    'CHEMOTHERAPY',
    'PROCEDURE',
    'LABORATORY_ONCO',
    'ULTRASOUND_ONCO',
    'RECOVERY',
    'EMERGENCY_ONCO',
    'GENERAL_HEALTH'
);


ALTER TYPE public."enum_appointments_serviceType" OWNER TO postgres;

--
-- Name: enum_appointments_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_appointments_status AS ENUM (
    'SCHEDULED',
    'CHECKED_IN',
    'IN_PROGRESS',
    'COMPLETED',
    'CANCELLED',
    'NO_SHOW'
);


ALTER TYPE public.enum_appointments_status OWNER TO postgres;

--
-- Name: enum_doctors_specialty; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_doctors_specialty AS ENUM (
    'Oncología Clínica',
    'Oncología Quirúrgica',
    'Radioterapia',
    'Hematología',
    'Cirugía Oncológica'
);


ALTER TYPE public.enum_doctors_specialty OWNER TO postgres;

--
-- Name: enum_resources_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_resources_status AS ENUM (
    'DISPONIBLE',
    'OCUPADO',
    'INHABILITADO'
);


ALTER TYPE public.enum_resources_status OWNER TO postgres;

--
-- Name: enum_resources_statusReason; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_resources_statusReason" AS ENUM (
    'MANTENIMIENTO',
    'LIMPIEZA',
    'FALLA'
);


ALTER TYPE public."enum_resources_statusReason" OWNER TO postgres;

--
-- Name: enum_resources_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_resources_type AS ENUM (
    'CONSULTORIO',
    'TRATAMIENTO',
    'ESTANCIA'
);


ALTER TYPE public.enum_resources_type OWNER TO postgres;

--
-- Name: enum_staff_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_staff_role AS ENUM (
    'ADMIN',
    'DOCTOR',
    'NURSE_CHEMO',
    'NURSE_PROCEDURE',
    'NURSE_ULTRASOUND',
    'NURSE_GENERAL',
    'RECEPTIONIST',
    'LAB_ONCO',
    'LAB_GENERAL',
    'PHARMACY',
    'QUOTE_MANAGER',
    'COMMERCIAL'
);


ALTER TYPE public.enum_staff_role OWNER TO postgres;

--
-- Name: enum_waiting_room_priority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_waiting_room_priority AS ENUM (
    'NORMAL',
    'URGENTE'
);


ALTER TYPE public.enum_waiting_room_priority OWNER TO postgres;

--
-- Name: enum_waiting_room_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_waiting_room_status AS ENUM (
    'ESPERANDO',
    'LLAMADO',
    'ATENDIDO'
);


ALTER TYPE public.enum_waiting_room_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointment_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_history (
    id integer NOT NULL,
    appointment_id integer,
    change_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    previous_status text,
    new_status text,
    comment text
);


ALTER TABLE public.appointment_history OWNER TO postgres;

--
-- Name: appointment_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_history_id_seq OWNER TO postgres;

--
-- Name: appointment_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_history_id_seq OWNED BY public.appointment_history.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    "patientId" integer,
    "doctorId" integer,
    "resourceId" integer,
    "serviceTypeId" integer NOT NULL,
    "dateTime" timestamp with time zone NOT NULL,
    "internalStatus" public."enum_appointments_internalStatus" DEFAULT 'NONE'::public."enum_appointments_internalStatus",
    status public.enum_appointments_status DEFAULT 'SCHEDULED'::public.enum_appointments_status,
    specialty character varying(255),
    notes text,
    "phoneNumber" character varying(255),
    "emergencyContact" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "contactName" character varying(255),
    "checkinTime" timestamp with time zone,
    "startTime" timestamp with time zone
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointments_id_seq OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: chemo_chairs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chemo_chairs (
    id integer NOT NULL,
    "chairLabel" character varying(255) NOT NULL,
    "isOccupied" boolean DEFAULT false,
    "occupiedByPatientId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.chemo_chairs OWNER TO postgres;

--
-- Name: chemo_chairs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chemo_chairs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chemo_chairs_id_seq OWNER TO postgres;

--
-- Name: chemo_chairs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chemo_chairs_id_seq OWNED BY public.chemo_chairs.id;


--
-- Name: doctor_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_schedules (
    id integer NOT NULL,
    doctor_id integer NOT NULL,
    day_of_week integer NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.doctor_schedules OWNER TO postgres;

--
-- Name: doctor_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_schedules_id_seq OWNER TO postgres;

--
-- Name: doctor_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_schedules_id_seq OWNED BY public.doctor_schedules.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    dni character varying(255) NOT NULL,
    email character varying(255),
    phone character varying(255),
    status character varying(255) DEFAULT 'activo'::character varying,
    daily_quota integer DEFAULT 10,
    specialty_id integer,
    medical_center_id integer
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctors_id_seq OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: medical_centers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_centers (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    phone character varying(255),
    email character varying(255),
    tax_id character varying(255)
);


ALTER TABLE public.medical_centers OWNER TO postgres;

--
-- Name: medical_centers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medical_centers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medical_centers_id_seq OWNER TO postgres;

--
-- Name: medical_centers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medical_centers_id_seq OWNED BY public.medical_centers.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    dni character varying(255),
    phone character varying(255),
    email character varying(255),
    birth_date date,
    vital_status character varying(255) DEFAULT 'alive'::character varying,
    registration_date timestamp with time zone,
    status character varying(255) DEFAULT 'activo'::character varying,
    document_type character varying(255) DEFAULT 'DNI'::character varying,
    document_number character varying(255),
    onc_dni character varying(255),
    ssg_dni character varying(255),
    medical_record_number character varying(30)
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patients_id_seq OWNER TO postgres;

--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: queues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.queues (
    id integer NOT NULL,
    "appointmentId" integer NOT NULL,
    "ticketNumber" character varying(255) NOT NULL,
    "serviceArea" character varying(255) NOT NULL,
    "isCurrent" boolean DEFAULT false,
    "isCompleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.queues OWNER TO postgres;

--
-- Name: queues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.queues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queues_id_seq OWNER TO postgres;

--
-- Name: queues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.queues_id_seq OWNED BY public.queues.id;


--
-- Name: recovery_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recovery_rooms (
    id integer NOT NULL,
    "roomLabel" character varying(255) NOT NULL,
    "isOccupied" boolean DEFAULT false,
    "occupiedByPatientId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.recovery_rooms OWNER TO postgres;

--
-- Name: recovery_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recovery_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recovery_rooms_id_seq OWNER TO postgres;

--
-- Name: recovery_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recovery_rooms_id_seq OWNED BY public.recovery_rooms.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resources (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type public.enum_resources_type NOT NULL,
    status public.enum_resources_status DEFAULT 'DISPONIBLE'::public.enum_resources_status,
    "statusReason" public."enum_resources_statusReason",
    capacity integer DEFAULT 1,
    "currentOccupancy" integer DEFAULT 0,
    "currentPatientId" integer,
    notes text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "doctorId" integer,
    timing numeric
);


ALTER TABLE public.resources OWNER TO postgres;

--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resources_id_seq OWNER TO postgres;

--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resources_id_seq OWNED BY public.resources.id;


--
-- Name: service_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    code character varying(255),
    icon character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    show_patient boolean DEFAULT true
);


ALTER TABLE public.service_types OWNER TO postgres;

--
-- Name: service_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_types_id_seq OWNER TO postgres;

--
-- Name: service_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_types_id_seq OWNED BY public.service_types.id;


--
-- Name: specialties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialties (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    icon character varying(255)
);


ALTER TABLE public.specialties OWNER TO postgres;

--
-- Name: specialties_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specialties_id_seq OWNER TO postgres;

--
-- Name: specialties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialties_id_seq OWNED BY public.specialties.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role public.enum_staff_role NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_id_seq OWNER TO postgres;

--
-- Name: staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_id_seq OWNED BY public.staff.id;


--
-- Name: waiting_room; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waiting_room (
    id integer NOT NULL,
    "patientId" integer NOT NULL,
    "appointmentId" integer,
    "checkInTime" timestamp with time zone NOT NULL,
    "estimatedWaitTime" integer,
    priority public.enum_waiting_room_priority DEFAULT 'NORMAL'::public.enum_waiting_room_priority,
    status public.enum_waiting_room_status DEFAULT 'ESPERANDO'::public.enum_waiting_room_status,
    notes text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.waiting_room OWNER TO postgres;

--
-- Name: waiting_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.waiting_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.waiting_room_id_seq OWNER TO postgres;

--
-- Name: waiting_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.waiting_room_id_seq OWNED BY public.waiting_room.id;


--
-- Name: appointment_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_history ALTER COLUMN id SET DEFAULT nextval('public.appointment_history_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: chemo_chairs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs ALTER COLUMN id SET DEFAULT nextval('public.chemo_chairs_id_seq'::regclass);


--
-- Name: doctor_schedules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_schedules ALTER COLUMN id SET DEFAULT nextval('public.doctor_schedules_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: medical_centers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_centers ALTER COLUMN id SET DEFAULT nextval('public.medical_centers_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: queues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queues ALTER COLUMN id SET DEFAULT nextval('public.queues_id_seq'::regclass);


--
-- Name: recovery_rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms ALTER COLUMN id SET DEFAULT nextval('public.recovery_rooms_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources ALTER COLUMN id SET DEFAULT nextval('public.resources_id_seq'::regclass);


--
-- Name: service_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types ALTER COLUMN id SET DEFAULT nextval('public.service_types_id_seq'::regclass);


--
-- Name: specialties id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialties ALTER COLUMN id SET DEFAULT nextval('public.specialties_id_seq'::regclass);


--
-- Name: staff id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN id SET DEFAULT nextval('public.staff_id_seq'::regclass);


--
-- Name: waiting_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_room ALTER COLUMN id SET DEFAULT nextval('public.waiting_room_id_seq'::regclass);


--
-- Data for Name: appointment_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment_history (id, appointment_id, change_date, previous_status, new_status, comment) FROM stdin;
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, "patientId", "doctorId", "resourceId", "serviceTypeId", "dateTime", "internalStatus", status, specialty, notes, "phoneNumber", "emergencyContact", "createdAt", "updatedAt", "contactName", "checkinTime", "startTime") FROM stdin;
40	43	4	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica	xxx	54654	\N	2025-12-19 19:42:20.982+00	2025-12-19 19:43:27.469+00	Nelson	2025-12-19 19:43:27.469+00	\N
42	46	3	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		234567	\N	2025-12-19 19:51:16.499+00	2025-12-19 19:52:29.362+00	rosa	2025-12-19 19:52:29.362+00	\N
44	46	4	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica	weqweqw	35345	\N	2025-12-19 21:51:09.532+00	2025-12-19 22:02:33.046+00	543453	2025-12-19 22:02:33.045+00	\N
46	47	1	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		8798798	\N	2025-12-19 23:09:37.78+00	2025-12-19 23:10:28.603+00	Rosa	2025-12-19 23:10:28.603+00	\N
48	45	1	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		67876876	\N	2025-12-19 23:25:50.772+00	2025-12-19 23:27:26.423+00	jhon	2025-12-19 23:27:26.423+00	\N
50	47	1	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		6787689	\N	2025-12-19 23:26:34.337+00	2025-12-19 23:28:17.453+00	6986698	2025-12-19 23:28:17.453+00	\N
52	47	3	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		iuoioi	\N	2025-12-19 23:43:19.436+00	2025-12-19 23:43:35.949+00	pio	2025-12-19 23:43:35.949+00	\N
54	\N	3	\N	1	2025-12-19 13:00:00+00	NONE	SCHEDULED	Oncología Médica		klkjklkl	\N	2025-12-19 23:47:22.781+00	2025-12-19 23:47:22.781+00	liyholi	\N	\N
55	43	1	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		32423423	\N	2025-12-22 18:31:08.014+00	2025-12-22 18:31:46.089+00	Andres	2025-12-22 18:31:46.089+00	\N
57	48	4	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica		3243	\N	2025-12-22 18:33:12.741+00	2025-12-22 18:46:29.944+00	3423	2025-12-22 18:46:29.944+00	\N
59	43	1	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		796989	\N	2025-12-22 18:59:06.77+00	2025-12-22 18:59:34.767+00	Juan	2025-12-22 18:59:34.767+00	\N
61	48	3	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		33424	\N	2025-12-22 21:07:28.135+00	2025-12-22 21:08:08.33+00	Luis	2025-12-22 21:08:08.329+00	\N
63	43	1	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		23423423	\N	2025-12-22 21:43:39.935+00	2025-12-22 21:43:56.671+00	Joe	2025-12-22 21:43:56.67+00	\N
65	43	1	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		werrwe	\N	2025-12-22 22:00:05.332+00	2025-12-22 22:00:21.886+00	rerqew	2025-12-22 22:00:21.886+00	\N
67	50	1	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		234234	\N	2025-12-22 22:04:32.228+00	2025-12-22 22:05:08.161+00	32423	2025-12-22 22:05:08.161+00	\N
71	45	4	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica		2324	\N	2025-12-22 22:13:37.617+00	2025-12-22 22:14:16.004+00	2312	2025-12-22 22:14:16.004+00	\N
69	43	1	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		wqeqw	\N	2025-12-22 22:13:08.919+00	2025-12-22 22:14:33.923+00	ewe	2025-12-22 22:14:33.923+00	\N
73	45	1	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		65465	\N	2025-12-23 11:42:03.06+00	2025-12-23 11:42:29.893+00	Joe	2025-12-23 11:42:29.893+00	\N
77	45	4	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica		2423sdfs	\N	2025-12-23 11:53:47.314+00	2025-12-23 11:54:23.582+00	2412	2025-12-23 11:54:23.582+00	\N
75	43	1	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		2321	\N	2025-12-23 11:53:16.448+00	2025-12-23 11:55:26.286+00	23213	2025-12-23 11:55:26.286+00	\N
79	51	1	\N	1	2025-12-23 12:03:19.975+00	NONE	CHECKED_IN	\N	\N	555-555-555	\N	2025-12-23 12:03:19.976+00	2025-12-23 12:03:19.976+00	Test Patient Doorbell	2025-12-23 12:03:19.975+00	\N
81	48	4	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica		213212	\N	2025-12-23 12:13:01.671+00	2025-12-23 12:14:00.289+00	2312	2025-12-23 12:14:00.289+00	\N
83	45	3	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		32423	\N	2025-12-23 12:13:26.799+00	2025-12-23 12:14:13.164+00	3423	2025-12-23 12:14:13.164+00	\N
85	54	4	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	997656731	\N	2025-12-23 12:30:16.576+00	2025-12-23 12:30:16.576+00	Miguel Sanchez	2025-12-23 12:30:16.576+00	\N
86	55	3	\N	2	2025-12-23 13:30:00+00	NONE	CHECKED_IN	\N	\N	916671333	\N	2025-12-23 12:30:16.616+00	2025-12-23 12:30:16.616+00	Ricardo Gomez	2025-12-23 12:30:16.616+00	\N
87	56	4	\N	1	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	959770211	\N	2025-12-23 12:30:16.629+00	2025-12-23 12:30:16.629+00	Luis Sanchez	2025-12-23 12:30:16.629+00	\N
88	57	4	\N	1	2025-12-23 14:30:00+00	NONE	CHECKED_IN	\N	\N	982346514	\N	2025-12-23 12:30:16.64+00	2025-12-23 12:30:16.64+00	David Hernandez	2025-12-23 12:30:16.64+00	\N
89	58	1	\N	2	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	922477299	\N	2025-12-23 12:30:16.65+00	2025-12-23 12:30:16.65+00	Maria Martinez	2025-12-23 12:30:16.65+00	\N
90	59	3	\N	1	2025-12-23 15:30:00+00	NONE	CHECKED_IN	\N	\N	987812612	\N	2025-12-23 12:30:16.659+00	2025-12-23 12:30:16.659+00	Elena Gomez	2025-12-23 12:30:16.659+00	\N
91	60	1	\N	2	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	970582488	\N	2025-12-23 12:30:16.666+00	2025-12-23 12:30:16.666+00	David Diaz	2025-12-23 12:30:16.666+00	\N
92	61	4	\N	2	2025-12-23 16:30:00+00	NONE	CHECKED_IN	\N	\N	988396386	\N	2025-12-23 12:30:16.676+00	2025-12-23 12:30:16.676+00	Jorge Castillo	2025-12-23 12:30:16.675+00	\N
93	62	4	\N	2	2025-12-23 17:00:00+00	NONE	CHECKED_IN	\N	\N	972271878	\N	2025-12-23 12:30:16.684+00	2025-12-23 12:30:16.684+00	Teresa Diaz	2025-12-23 12:30:16.684+00	\N
94	63	3	\N	2	2025-12-23 17:30:00+00	NONE	CHECKED_IN	\N	\N	931678317	\N	2025-12-23 12:30:16.693+00	2025-12-23 12:30:16.693+00	Patricia Vasquez	2025-12-23 12:30:16.693+00	\N
125	94	1	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	961693864	\N	2025-12-23 14:23:33.718+00	2025-12-23 14:23:33.718+00	Elena Ortiz	2025-12-23 14:23:33.717+00	\N
126	95	1	\N	1	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	980291257	\N	2025-12-23 14:23:33.779+00	2025-12-23 14:23:33.779+00	David Rodriguez	2025-12-23 14:23:33.779+00	\N
127	96	1	\N	1	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	990785847	\N	2025-12-23 14:23:33.803+00	2025-12-23 14:23:33.803+00	Luis Diaz	2025-12-23 14:23:33.803+00	\N
128	97	1	\N	2	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	957766598	\N	2025-12-23 14:23:33.821+00	2025-12-23 14:23:33.821+00	Miguel Chavez	2025-12-23 14:23:33.821+00	\N
129	98	1	\N	1	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	928487656	\N	2025-12-23 14:23:33.84+00	2025-12-23 14:23:33.84+00	Ricardo Hernandez	2025-12-23 14:23:33.84+00	\N
130	99	1	\N	1	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	980860655	\N	2025-12-23 14:23:33.853+00	2025-12-23 14:23:33.853+00	Sofia Flores	2025-12-23 14:23:33.853+00	\N
131	100	1	\N	1	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	921137717	\N	2025-12-23 14:23:33.869+00	2025-12-23 14:23:33.869+00	Fernando Gomez	2025-12-23 14:23:33.869+00	\N
132	101	1	\N	1	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	988268698	\N	2025-12-23 14:23:33.883+00	2025-12-23 14:23:33.883+00	David Lopez	2025-12-23 14:23:33.882+00	\N
133	102	1	\N	1	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	972674431	\N	2025-12-23 14:23:33.899+00	2025-12-23 14:23:33.899+00	Laura Diaz	2025-12-23 14:23:33.899+00	\N
134	103	1	\N	2	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	919248494	\N	2025-12-23 14:23:33.934+00	2025-12-23 14:23:33.934+00	Maria Flores	2025-12-23 14:23:33.934+00	\N
135	104	3	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	945823007	\N	2025-12-23 14:23:33.947+00	2025-12-23 14:23:33.947+00	Lucia Perez	2025-12-23 14:23:33.947+00	\N
136	105	3	\N	1	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	932707535	\N	2025-12-23 14:23:33.961+00	2025-12-23 14:23:33.961+00	Teresa Chavez	2025-12-23 14:23:33.961+00	\N
137	106	3	\N	1	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	964044940	\N	2025-12-23 14:23:33.974+00	2025-12-23 14:23:33.974+00	Isabel Sanchez	2025-12-23 14:23:33.974+00	\N
138	107	3	\N	2	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	956516691	\N	2025-12-23 14:23:33.99+00	2025-12-23 14:23:33.99+00	Lucia Reyes	2025-12-23 14:23:33.99+00	\N
139	108	3	\N	2	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	912115613	\N	2025-12-23 14:23:34.004+00	2025-12-23 14:23:34.004+00	Carlos Chavez	2025-12-23 14:23:34.004+00	\N
140	109	3	\N	2	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	930734797	\N	2025-12-23 14:23:34.017+00	2025-12-23 14:23:34.017+00	Pedro Ramirez	2025-12-23 14:23:34.017+00	\N
141	110	3	\N	2	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	952221342	\N	2025-12-23 14:23:34.032+00	2025-12-23 14:23:34.032+00	Sofia Gomez	2025-12-23 14:23:34.032+00	\N
142	111	3	\N	2	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	998420496	\N	2025-12-23 14:23:34.044+00	2025-12-23 14:23:34.044+00	Patricia Hernandez	2025-12-23 14:23:34.044+00	\N
143	112	3	\N	2	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	998054215	\N	2025-12-23 14:23:34.06+00	2025-12-23 14:23:34.06+00	Laura Gonzalez	2025-12-23 14:23:34.06+00	\N
144	113	3	\N	1	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	935843850	\N	2025-12-23 14:23:34.074+00	2025-12-23 14:23:34.074+00	Lucia Lopez	2025-12-23 14:23:34.074+00	\N
145	114	4	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	916266670	\N	2025-12-23 14:23:34.091+00	2025-12-23 14:23:34.091+00	Ana Hernandez	2025-12-23 14:23:34.091+00	\N
146	115	4	\N	1	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	938755857	\N	2025-12-23 14:23:34.107+00	2025-12-23 14:23:34.107+00	Juan Flores	2025-12-23 14:23:34.107+00	\N
147	116	4	\N	1	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	959885041	\N	2025-12-23 14:23:34.124+00	2025-12-23 14:23:34.124+00	Isabel Diaz	2025-12-23 14:23:34.124+00	\N
148	117	4	\N	1	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	951843278	\N	2025-12-23 14:23:34.139+00	2025-12-23 14:23:34.139+00	Ricardo Garcia	2025-12-23 14:23:34.139+00	\N
149	118	4	\N	2	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	931627155	\N	2025-12-23 14:23:34.153+00	2025-12-23 14:23:34.153+00	Pedro Diaz	2025-12-23 14:23:34.153+00	\N
150	119	4	\N	2	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	979492634	\N	2025-12-23 14:23:34.169+00	2025-12-23 14:23:34.169+00	Lucia Torres	2025-12-23 14:23:34.169+00	\N
151	120	4	\N	1	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	964537474	\N	2025-12-23 14:23:34.182+00	2025-12-23 14:23:34.182+00	Miguel Gonzalez	2025-12-23 14:23:34.182+00	\N
152	121	4	\N	2	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	972784726	\N	2025-12-23 14:23:34.197+00	2025-12-23 14:23:34.197+00	Maria Chavez	2025-12-23 14:23:34.197+00	\N
153	122	4	\N	1	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	944637121	\N	2025-12-23 14:23:34.21+00	2025-12-23 14:23:34.21+00	Carlos Ortiz	2025-12-23 14:23:34.21+00	\N
154	123	4	\N	2	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	913496074	\N	2025-12-23 14:23:34.225+00	2025-12-23 14:23:34.225+00	David Flores	2025-12-23 14:23:34.225+00	\N
31	43	1	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		12345678	Test Contact	2025-12-18 20:22:12.526+00	2025-12-19 19:10:15.335+00	Juan Pérez	2025-12-19 19:10:15.335+00	\N
39	44	1	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica	Chequeo 	45564654	\N	2025-12-19 18:06:27.738+00	2025-12-19 19:12:55.618+00	Nelson	2025-12-19 19:12:55.618+00	\N
32	45	1	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		34223	423423	2025-12-18 20:24:08.947+00	2025-12-19 19:15:27.478+00	Juan Pérez	2025-12-19 19:15:27.478+00	\N
41	44	4	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica		76897687	\N	2025-12-19 19:46:14.918+00	2025-12-19 19:47:20.875+00	gladys	2025-12-19 19:47:20.875+00	\N
43	47	1	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		879879	\N	2025-12-19 21:50:41.461+00	2025-12-19 21:58:37.598+00	Sol	2025-12-19 21:58:37.598+00	\N
45	46	3	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		979879	\N	2025-12-19 22:56:35.373+00	2025-12-19 22:57:10.939+00	Felix	2025-12-19 22:57:10.939+00	\N
47	46	1	\N	2	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		79697	\N	2025-12-19 23:13:44.682+00	2025-12-19 23:14:11.078+00	Luis	2025-12-19 23:14:11.078+00	\N
49	44	1	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		580080	\N	2025-12-19 23:26:15.463+00	2025-12-19 23:27:52.45+00	Ñoi	2025-12-19 23:27:52.45+00	\N
51	46	3	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		879870	\N	2025-12-19 23:41:55.86+00	2025-12-19 23:42:20.806+00	luis	2025-12-19 23:42:20.805+00	\N
53	46	3	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		kk	\N	2025-12-19 23:46:26.417+00	2025-12-19 23:46:40.985+00	lkhlkh	2025-12-19 23:46:40.985+00	\N
38	1	3	\N	1	2025-12-18 13:00:00+00	NONE	SCHEDULED	Oncología Médica		534	2352345	2025-12-18 22:33:17.273+00	2025-12-18 22:33:17.273+00	Juan Pérez	\N	\N
37	1	1	\N	1	2025-12-18 13:00:00+00	NONE	SCHEDULED	Oncología Médica		56747	65745	2025-12-18 22:31:40.468+00	2025-12-18 22:31:40.468+00	Juan Pérez	\N	\N
36	1	1	\N	1	2025-12-17 13:00:00+00	NONE	SCHEDULED	Oncología Médica		rwr	werew	2025-12-18 21:02:16.697+00	2025-12-18 21:02:16.697+00	Juan Pérez	\N	\N
35	1	4	\N	2	2025-12-12 13:00:00+00	NONE	SCHEDULED	Radiología Oncológica	xxxxx	434432	Nrlon	2025-12-18 21:00:54.733+00	2025-12-18 21:00:54.733+00	Juan Pérez	\N	\N
34	1	1	\N	1	2025-12-18 16:00:00+00	NONE	CHECKED_IN	\N	\N	999888777	Familiar	2025-12-18 20:53:39.594+00	2025-12-18 21:00:27.171+00	Juan Pérez	\N	\N
56	45	1	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		21321	\N	2025-12-22 18:32:56.388+00	2025-12-22 18:35:42.429+00	Jose	2025-12-22 18:35:42.429+00	\N
97	66	1	\N	2	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	995881815	\N	2025-12-23 12:37:59.316+00	2025-12-23 12:37:59.316+00	Ana Morales	2025-12-23 12:37:59.316+00	\N
98	67	1	\N	2	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	927109603	\N	2025-12-23 12:37:59.331+00	2025-12-23 12:37:59.331+00	Teresa Ortiz	2025-12-23 12:37:59.331+00	\N
33	43	1	\N	1	2025-12-19 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		4234	234234	2025-12-18 20:25:08.696+00	2025-12-19 19:05:31.67+00	Juan Pérez	2025-12-19 19:05:31.669+00	\N
58	48	3	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		2312312	\N	2025-12-22 18:45:07.119+00	2025-12-22 18:46:09.922+00	Jose	2025-12-22 18:46:09.922+00	\N
60	49	1	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		6546546	\N	2025-12-22 21:07:08.032+00	2025-12-22 21:08:40.65+00	Jesus	2025-12-22 21:08:40.65+00	\N
62	43	1	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		3423423	\N	2025-12-22 21:22:53.13+00	2025-12-22 21:23:21.448+00	Louis	2025-12-22 21:23:21.448+00	\N
64	43	1	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		weeq	\N	2025-12-22 21:58:19.922+00	2025-12-22 21:58:38.266+00	Luiso	2025-12-22 21:58:38.266+00	\N
66	48	1	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		3343242	\N	2025-12-22 22:04:15.838+00	2025-12-22 22:04:51.925+00	julio	2025-12-22 22:04:51.925+00	\N
68	43	3	\N	1	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		3rweewr	\N	2025-12-22 22:09:10.466+00	2025-12-22 22:10:28.978+00	juo	2025-12-22 22:10:28.977+00	\N
70	48	3	\N	2	2025-12-22 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		213123	\N	2025-12-22 22:13:22.525+00	2025-12-22 22:13:59.948+00	2312	2025-12-22 22:13:59.948+00	\N
72	43	1	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		3235	\N	2025-12-23 11:29:06.039+00	2025-12-23 11:29:23.876+00	Luus	2025-12-23 11:29:23.876+00	\N
74	48	3	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		3234	\N	2025-12-23 11:43:31.53+00	2025-12-23 11:43:52.061+00	Joe	2025-12-23 11:43:52.06+00	\N
76	48	3	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		32132	\N	2025-12-23 11:53:33.834+00	2025-12-23 11:55:06.748+00	212	2025-12-23 11:55:06.747+00	\N
99	68	1	\N	2	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	967713446	\N	2025-12-23 12:37:59.343+00	2025-12-23 12:37:59.343+00	Pedro Vasquez	2025-12-23 12:37:59.343+00	\N
80	52	1	\N	1	2025-12-23 12:06:21.546+00	NONE	CHECKED_IN	\N	\N	555-555-555	\N	2025-12-23 12:06:21.546+00	2025-12-23 12:06:21.546+00	Test Patient Doorbell	2025-12-23 12:06:21.546+00	\N
78	48	1	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		3242342	\N	2025-12-23 12:02:28.77+00	2025-12-23 12:11:40.576+00	Jose	2025-12-23 12:11:40.576+00	\N
82	43	1	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	Oncología Médica		324234	\N	2025-12-23 12:13:14.191+00	2025-12-23 12:14:30.321+00	24332	2025-12-23 12:14:30.321+00	\N
84	53	1	\N	1	2025-12-23 12:17:32.61+00	NONE	CHECKED_IN	\N	\N	555-555-555	\N	2025-12-23 12:17:32.611+00	2025-12-23 12:17:32.611+00	Test Patient Doorbell	2025-12-23 12:17:32.61+00	\N
95	64	1	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	936501344	\N	2025-12-23 12:37:59.239+00	2025-12-23 12:37:59.239+00	Luis Castillo	2025-12-23 12:37:59.238+00	\N
96	65	1	\N	1	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	972848883	\N	2025-12-23 12:37:59.297+00	2025-12-23 12:37:59.297+00	Maria Perez	2025-12-23 12:37:59.297+00	\N
100	69	1	\N	2	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	947180795	\N	2025-12-23 12:37:59.354+00	2025-12-23 12:37:59.354+00	Sofia Rodriguez	2025-12-23 12:37:59.354+00	\N
101	70	1	\N	2	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	925411387	\N	2025-12-23 12:37:59.367+00	2025-12-23 12:37:59.367+00	Carmen Martinez	2025-12-23 12:37:59.366+00	\N
102	71	1	\N	1	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	995540637	\N	2025-12-23 12:37:59.387+00	2025-12-23 12:37:59.387+00	Juan Rivera	2025-12-23 12:37:59.386+00	\N
103	72	1	\N	2	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	986487130	\N	2025-12-23 12:37:59.398+00	2025-12-23 12:37:59.398+00	Lucia Ortiz	2025-12-23 12:37:59.398+00	\N
104	73	1	\N	1	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	931104836	\N	2025-12-23 12:37:59.409+00	2025-12-23 12:37:59.409+00	Lucia Sanchez	2025-12-23 12:37:59.409+00	\N
105	74	3	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	934379316	\N	2025-12-23 12:37:59.419+00	2025-12-23 12:37:59.419+00	Carmen Chavez	2025-12-23 12:37:59.419+00	\N
106	75	3	\N	2	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	997439221	\N	2025-12-23 12:37:59.432+00	2025-12-23 12:37:59.432+00	Laura Morales	2025-12-23 12:37:59.432+00	\N
107	76	3	\N	1	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	915665557	\N	2025-12-23 12:37:59.443+00	2025-12-23 12:37:59.443+00	Elena Perez	2025-12-23 12:37:59.443+00	\N
108	77	3	\N	2	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	929410560	\N	2025-12-23 12:37:59.452+00	2025-12-23 12:37:59.452+00	Miguel Morales	2025-12-23 12:37:59.452+00	\N
109	78	3	\N	1	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	995761088	\N	2025-12-23 12:37:59.462+00	2025-12-23 12:37:59.462+00	Lucia Castillo	2025-12-23 12:37:59.462+00	\N
110	79	3	\N	1	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	989108662	\N	2025-12-23 12:37:59.473+00	2025-12-23 12:37:59.473+00	Teresa Martinez	2025-12-23 12:37:59.473+00	\N
111	80	3	\N	1	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	920392384	\N	2025-12-23 12:37:59.483+00	2025-12-23 12:37:59.483+00	Luis Chavez	2025-12-23 12:37:59.483+00	\N
112	81	3	\N	1	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	967981218	\N	2025-12-23 12:37:59.493+00	2025-12-23 12:37:59.493+00	Lucia Perez	2025-12-23 12:37:59.493+00	\N
113	82	3	\N	2	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	977194726	\N	2025-12-23 12:37:59.504+00	2025-12-23 12:37:59.504+00	Teresa Garcia	2025-12-23 12:37:59.504+00	\N
114	83	3	\N	1	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	939436338	\N	2025-12-23 12:37:59.516+00	2025-12-23 12:37:59.516+00	Lucia Vasquez	2025-12-23 12:37:59.516+00	\N
115	84	4	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	932960217	\N	2025-12-23 12:37:59.527+00	2025-12-23 12:37:59.527+00	David Garcia	2025-12-23 12:37:59.527+00	\N
116	85	4	\N	2	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	923430666	\N	2025-12-23 12:37:59.539+00	2025-12-23 12:37:59.539+00	Teresa Lopez	2025-12-23 12:37:59.538+00	\N
117	86	4	\N	2	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	932859144	\N	2025-12-23 12:37:59.552+00	2025-12-23 12:37:59.552+00	Laura Martinez	2025-12-23 12:37:59.551+00	\N
118	87	4	\N	2	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	980532699	\N	2025-12-23 12:37:59.564+00	2025-12-23 12:37:59.564+00	Jorge Garcia	2025-12-23 12:37:59.563+00	\N
119	88	4	\N	2	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	949442030	\N	2025-12-23 12:37:59.577+00	2025-12-23 12:37:59.577+00	Miguel Ramirez	2025-12-23 12:37:59.577+00	\N
120	89	4	\N	2	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	948555586	\N	2025-12-23 12:37:59.587+00	2025-12-23 12:37:59.587+00	Jorge Vasquez	2025-12-23 12:37:59.587+00	\N
121	90	4	\N	2	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	989075030	\N	2025-12-23 12:37:59.598+00	2025-12-23 12:37:59.598+00	Luis Vasquez	2025-12-23 12:37:59.598+00	\N
122	91	4	\N	1	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	920970782	\N	2025-12-23 12:37:59.609+00	2025-12-23 12:37:59.609+00	Elena Castillo	2025-12-23 12:37:59.608+00	\N
123	92	4	\N	2	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	960079661	\N	2025-12-23 12:37:59.619+00	2025-12-23 12:37:59.619+00	Ricardo Martinez	2025-12-23 12:37:59.619+00	\N
124	93	4	\N	1	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	997705457	\N	2025-12-23 12:37:59.63+00	2025-12-23 12:37:59.63+00	Patricia Rodriguez	2025-12-23 12:37:59.63+00	\N
158	127	1	\N	1	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	957398944	\N	2025-12-23 15:06:39.585+00	2025-12-23 15:06:39.585+00	Maria Sanchez	2025-12-23 15:06:39.584+00	\N
159	128	1	\N	1	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	940297062	\N	2025-12-23 15:06:39.599+00	2025-12-23 15:06:39.599+00	Juan Vasquez	2025-12-23 15:06:39.599+00	\N
160	129	1	\N	2	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	941985908	\N	2025-12-23 15:06:39.61+00	2025-12-23 15:06:39.61+00	Juan Castillo	2025-12-23 15:06:39.61+00	\N
161	130	1	\N	2	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	965912822	\N	2025-12-23 15:06:39.624+00	2025-12-23 15:06:39.624+00	Luis Rodriguez	2025-12-23 15:06:39.624+00	\N
162	131	1	\N	2	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	916871803	\N	2025-12-23 15:06:39.635+00	2025-12-23 15:06:39.635+00	Jorge Rivera	2025-12-23 15:06:39.635+00	\N
163	132	1	\N	2	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	986946113	\N	2025-12-23 15:06:39.646+00	2025-12-23 15:06:39.646+00	Isabel Ramirez	2025-12-23 15:06:39.646+00	\N
165	134	3	\N	1	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	948999083	\N	2025-12-23 15:06:39.668+00	2025-12-23 15:06:39.668+00	Miguel Flores	2025-12-23 15:06:39.668+00	\N
166	135	3	\N	2	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	956417145	\N	2025-12-23 15:06:39.679+00	2025-12-23 15:06:39.679+00	Sofia Reyes	2025-12-23 15:06:39.679+00	\N
167	136	3	\N	1	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	928717982	\N	2025-12-23 15:06:39.691+00	2025-12-23 15:06:39.691+00	Teresa Ramirez	2025-12-23 15:06:39.691+00	\N
168	137	3	\N	1	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	929656242	\N	2025-12-23 15:06:39.702+00	2025-12-23 15:06:39.702+00	Teresa Diaz	2025-12-23 15:06:39.702+00	\N
170	139	3	\N	1	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	996229752	\N	2025-12-23 15:06:39.723+00	2025-12-23 15:06:39.723+00	Ana Rivera	2025-12-23 15:06:39.723+00	\N
171	140	3	\N	2	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	986779084	\N	2025-12-23 15:06:39.736+00	2025-12-23 15:06:39.736+00	Sofia Perez	2025-12-23 15:06:39.736+00	\N
172	141	3	\N	2	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	930271126	\N	2025-12-23 15:06:39.749+00	2025-12-23 15:06:39.749+00	Carlos Ortiz	2025-12-23 15:06:39.749+00	\N
173	142	3	\N	2	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	944262458	\N	2025-12-23 15:06:39.761+00	2025-12-23 15:06:39.761+00	Jose Lopez	2025-12-23 15:06:39.761+00	\N
174	143	3	\N	1	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	979177393	\N	2025-12-23 15:06:39.775+00	2025-12-23 15:06:39.775+00	Teresa Flores	2025-12-23 15:06:39.775+00	\N
175	144	4	\N	2	2025-12-23 13:00:00+00	NONE	CHECKED_IN	\N	\N	971278483	\N	2025-12-23 15:06:39.788+00	2025-12-23 15:06:39.788+00	Jorge Gomez	2025-12-23 15:06:39.788+00	\N
176	145	4	\N	1	2025-12-23 13:20:00+00	NONE	CHECKED_IN	\N	\N	938441607	\N	2025-12-23 15:06:39.799+00	2025-12-23 15:06:39.799+00	Maria Gonzalez	2025-12-23 15:06:39.799+00	\N
177	146	4	\N	1	2025-12-23 13:40:00+00	NONE	CHECKED_IN	\N	\N	953836536	\N	2025-12-23 15:06:39.812+00	2025-12-23 15:06:39.812+00	Carmen Reyes	2025-12-23 15:06:39.811+00	\N
178	147	4	\N	2	2025-12-23 14:00:00+00	NONE	CHECKED_IN	\N	\N	955236395	\N	2025-12-23 15:06:39.824+00	2025-12-23 15:06:39.824+00	Miguel Vasquez	2025-12-23 15:06:39.824+00	\N
179	148	4	\N	1	2025-12-23 14:20:00+00	NONE	CHECKED_IN	\N	\N	919883586	\N	2025-12-23 15:06:39.837+00	2025-12-23 15:06:39.837+00	Ana Chavez	2025-12-23 15:06:39.837+00	\N
180	149	4	\N	1	2025-12-23 14:40:00+00	NONE	CHECKED_IN	\N	\N	986242421	\N	2025-12-23 15:06:39.854+00	2025-12-23 15:06:39.854+00	David Ortiz	2025-12-23 15:06:39.854+00	\N
181	150	4	\N	1	2025-12-23 15:00:00+00	NONE	CHECKED_IN	\N	\N	996142475	\N	2025-12-23 15:06:39.867+00	2025-12-23 15:06:39.867+00	Miguel Ramirez	2025-12-23 15:06:39.867+00	\N
182	151	4	\N	1	2025-12-23 15:20:00+00	NONE	CHECKED_IN	\N	\N	960523440	\N	2025-12-23 15:06:39.878+00	2025-12-23 15:06:39.878+00	Lucia Chavez	2025-12-23 15:06:39.878+00	\N
183	152	4	\N	1	2025-12-23 15:40:00+00	NONE	CHECKED_IN	\N	\N	970277731	\N	2025-12-23 15:06:39.891+00	2025-12-23 15:06:39.891+00	Fernando Ramirez	2025-12-23 15:06:39.891+00	\N
184	153	4	\N	1	2025-12-23 16:00:00+00	NONE	CHECKED_IN	\N	\N	945228039	\N	2025-12-23 15:06:39.904+00	2025-12-23 15:06:39.904+00	Miguel Hernandez	2025-12-23 15:06:39.903+00	\N
155	124	1	\N	1	2025-12-23 13:00:00+00	NONE	COMPLETED	\N	\N	946233853	\N	2025-12-23 15:06:39.486+00	2025-12-23 15:07:32.425+00	Carlos Sanchez	2025-12-23 15:06:39.485+00	\N
156	125	1	\N	2	2025-12-23 13:20:00+00	NONE	COMPLETED	\N	\N	967687585	\N	2025-12-23 15:06:39.548+00	2025-12-23 15:07:57.152+00	Juan Rivera	2025-12-23 15:06:39.548+00	\N
157	126	1	\N	1	2025-12-23 13:40:00+00	NONE	COMPLETED	\N	\N	934118355	\N	2025-12-23 15:06:39.567+00	2025-12-23 15:13:32.775+00	Carlos Flores	2025-12-23 15:06:39.567+00	\N
164	133	1	\N	1	2025-12-23 16:00:00+00	NONE	COMPLETED	\N	\N	959351157	\N	2025-12-23 15:06:39.656+00	2025-12-23 15:13:42.699+00	Patricia Ortiz	2025-12-23 15:06:39.656+00	\N
169	138	3	\N	1	2025-12-23 14:20:00+00	NONE	COMPLETED	\N	\N	977561515	\N	2025-12-23 15:06:39.712+00	2025-12-23 20:58:21.282+00	Juan Castillo	2025-12-23 15:06:39.712+00	\N
185	43	4	\N	2	2025-12-29 13:00:00+00	NONE	COMPLETED	Radiología Oncológica	Revision de Examenes	23423423	\N	2025-12-29 16:39:52.632+00	2025-12-29 16:46:20.141+00	Andres	2025-12-29 16:40:23.357+00	\N
186	43	4	\N	2	2025-12-29 13:00:00+00	NONE	COMPLETED	Radiología Oncológica	Imagen de Torax	23423	\N	2025-12-29 16:48:33.629+00	2025-12-29 16:53:27.094+00	3242	2025-12-29 16:48:52.048+00	\N
188	43	4	\N	2	2025-12-29 13:00:00+00	NONE	COMPLETED	Radiología Oncológica		234234	\N	2025-12-29 16:54:35.03+00	2025-12-29 22:33:09.636+00	424	2025-12-29 16:54:52.508+00	2025-12-29 22:32:59.931+00
187	43	4	\N	1	2025-12-29 13:00:00+00	NONE	COMPLETED	Radiología Oncológica	23123312	1231231	\N	2025-12-29 16:51:55.845+00	2025-12-29 22:31:44.258+00	312312	2025-12-29 16:52:14.806+00	\N
194	159	4	\N	1	2025-12-29 14:15:00+00	NONE	COMPLETED	\N	Cita de prueba 2 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.589+00	2025-12-29 17:08:43.621+00	Paciente Test 2 - Dr. Roberto Cavero Cueva	2025-12-29 14:05:00+00	\N
197	162	4	\N	1	2025-12-29 15:00:00+00	NONE	COMPLETED	\N	Cita de prueba 3 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.637+00	2025-12-29 17:10:41.266+00	Paciente Test 3 - Dr. Roberto Cavero Cueva	2025-12-29 14:50:00+00	\N
200	165	4	\N	1	2025-12-29 15:45:00+00	NONE	COMPLETED	\N	Cita de prueba 4 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.683+00	2025-12-29 17:27:16.636+00	Paciente Test 4 - Dr. Roberto Cavero Cueva	2025-12-29 15:35:00+00	\N
203	168	4	\N	1	2025-12-29 16:30:00+00	NONE	COMPLETED	\N	Cita de prueba 5 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.727+00	2025-12-29 17:27:39.792+00	Paciente Test 5 - Dr. Roberto Cavero Cueva	2025-12-29 16:20:00+00	\N
206	171	4	\N	1	2025-12-29 17:15:00+00	NONE	COMPLETED	\N	Cita de prueba 6 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.776+00	2025-12-29 17:31:54.73+00	Paciente Test 6 - Dr. Roberto Cavero Cueva	2025-12-29 17:05:00+00	\N
190	155	3	\N	1	2025-12-29 13:15:00+00	NONE	COMPLETED	\N	Cita de prueba 1 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.506+00	2025-12-29 17:56:29.098+00	Paciente Test 1 - Dr. Yinno Custodio Hernández	2025-12-29 13:05:00+00	2025-12-29 17:56:18.233+00
193	158	3	\N	1	2025-12-29 14:00:00+00	NONE	COMPLETED	\N	Cita de prueba 2 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.572+00	2025-12-29 18:00:34.526+00	Paciente Test 2 - Dr. Yinno Custodio Hernández	2025-12-29 13:50:00+00	2025-12-29 18:00:22.957+00
196	161	3	\N	1	2025-12-29 14:45:00+00	NONE	COMPLETED	\N	Cita de prueba 3 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.62+00	2025-12-29 18:09:04.614+00	Paciente Test 3 - Dr. Yinno Custodio Hernández	2025-12-29 14:35:00+00	2025-12-29 18:00:39.025+00
199	164	3	\N	1	2025-12-29 15:30:00+00	NONE	COMPLETED	\N	Cita de prueba 4 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.667+00	2025-12-29 20:59:06.529+00	Paciente Test 4 - Dr. Yinno Custodio Hernández	2025-12-29 15:20:00+00	2025-12-29 20:54:02.245+00
202	167	3	\N	1	2025-12-29 16:15:00+00	NONE	COMPLETED	\N	Cita de prueba 5 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.714+00	2025-12-29 20:59:53.424+00	Paciente Test 5 - Dr. Yinno Custodio Hernández	2025-12-29 16:05:00+00	2025-12-29 20:59:50.482+00
205	170	3	\N	1	2025-12-29 17:00:00+00	NONE	COMPLETED	\N	Cita de prueba 6 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.76+00	2025-12-29 21:03:39.763+00	Paciente Test 6 - Dr. Yinno Custodio Hernández	2025-12-29 16:50:00+00	2025-12-29 21:03:39.205+00
189	154	1	\N	1	2025-12-29 13:00:00+00	NONE	COMPLETED	\N	Cita de prueba 1 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.422+00	2025-12-29 21:23:53.124+00	Paciente Test 1 - Dr. Antonio Camargo Acosta	2025-12-29 12:50:00+00	2025-12-29 21:22:26.442+00
192	157	1	\N	1	2025-12-29 13:45:00+00	NONE	COMPLETED	\N	Cita de prueba 2 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.554+00	2025-12-29 21:24:04.571+00	Paciente Test 2 - Dr. Antonio Camargo Acosta	2025-12-29 13:35:00+00	2025-12-29 21:24:03.89+00
195	160	1	\N	1	2025-12-29 14:30:00+00	NONE	COMPLETED	\N	Cita de prueba 3 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.607+00	2025-12-29 21:24:12.057+00	Paciente Test 3 - Dr. Antonio Camargo Acosta	2025-12-29 14:20:00+00	2025-12-29 21:24:11.498+00
201	166	1	\N	1	2025-12-29 16:00:00+00	NONE	COMPLETED	\N	Cita de prueba 5 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.698+00	2025-12-29 21:24:27.297+00	Paciente Test 5 - Dr. Antonio Camargo Acosta	2025-12-29 15:50:00+00	2025-12-29 21:24:25.94+00
204	169	1	\N	1	2025-12-29 16:45:00+00	NONE	COMPLETED	\N	Cita de prueba 6 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.745+00	2025-12-29 22:04:29.061+00	Paciente Test 6 - Dr. Antonio Camargo Acosta	2025-12-29 16:35:00+00	2025-12-29 22:04:28.607+00
191	156	4	\N	1	2025-12-29 13:30:00+00	NONE	COMPLETED	\N	Cita de prueba 1 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.533+00	2025-12-29 17:08:16.19+00	Paciente Test 1 - Dr. Roberto Cavero Cueva	2025-12-29 13:20:00+00	\N
207	172	1	\N	1	2025-12-29 17:30:00+00	NONE	COMPLETED	\N	Cita de prueba 7 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.79+00	2025-12-29 22:04:38.616+00	Paciente Test 7 - Dr. Antonio Camargo Acosta	2025-12-29 17:20:00+00	2025-12-29 22:04:38.121+00
209	174	4	\N	1	2025-12-29 18:00:00+00	NONE	COMPLETED	\N	Cita de prueba 7 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.846+00	2025-12-29 17:42:09.341+00	Paciente Test 7 - Dr. Roberto Cavero Cueva	2025-12-29 17:50:00+00	\N
212	177	4	\N	1	2025-12-29 18:45:00+00	NONE	COMPLETED	\N	Cita de prueba 8 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.892+00	2025-12-29 17:45:37.063+00	Paciente Test 8 - Dr. Roberto Cavero Cueva	2025-12-29 18:35:00+00	2025-12-29 17:42:13.37+00
210	175	1	\N	1	2025-12-29 18:15:00+00	NONE	COMPLETED	\N	Cita de prueba 8 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.861+00	2025-12-29 22:04:44.139+00	Paciente Test 8 - Dr. Antonio Camargo Acosta	2025-12-29 18:05:00+00	2025-12-29 22:04:43.391+00
215	180	4	\N	1	2025-12-29 19:30:00+00	NONE	COMPLETED	\N	Cita de prueba 9 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:51.938+00	2025-12-29 17:46:58.368+00	Paciente Test 9 - Dr. Roberto Cavero Cueva	2025-12-29 19:20:00+00	2025-12-29 17:46:02.594+00
218	183	4	\N	1	2025-12-29 20:15:00+00	NONE	COMPLETED	\N	Cita de prueba 10 para Dr. Roberto Cavero Cueva	999888777	\N	2025-12-29 17:02:52.084+00	2025-12-29 17:55:01.387+00	Paciente Test 10 - Dr. Roberto Cavero Cueva	2025-12-29 20:05:00+00	2025-12-29 17:47:32.602+00
213	178	1	\N	1	2025-12-29 19:00:00+00	NONE	COMPLETED	\N	Cita de prueba 9 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.909+00	2025-12-29 22:04:46.774+00	Paciente Test 9 - Dr. Antonio Camargo Acosta	2025-12-29 18:50:00+00	2025-12-29 22:04:46.297+00
208	173	3	\N	1	2025-12-29 17:45:00+00	NONE	COMPLETED	\N	Cita de prueba 7 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.806+00	2025-12-29 19:24:14.47+00	Paciente Test 7 - Dr. Yinno Custodio Hernández	2025-12-29 17:35:00+00	2025-12-29 19:24:13.92+00
216	181	1	\N	1	2025-12-29 19:45:00+00	NONE	COMPLETED	\N	Cita de prueba 10 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.951+00	2025-12-29 22:04:49.451+00	Paciente Test 10 - Dr. Antonio Camargo Acosta	2025-12-29 19:35:00+00	2025-12-29 22:04:48.875+00
219	45	4	\N	1	2025-12-29 13:00:00+00	NONE	COMPLETED	Radiología Oncológica	Revision de examenes	54645645	\N	2025-12-29 20:45:35.601+00	2025-12-29 20:52:32.227+00	Pedro	2025-12-29 20:48:21.08+00	2025-12-29 20:49:33.791+00
211	176	3	\N	1	2025-12-29 18:30:00+00	NONE	COMPLETED	\N	Cita de prueba 8 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.877+00	2025-12-29 21:04:58.404+00	Paciente Test 8 - Dr. Yinno Custodio Hernández	2025-12-29 18:20:00+00	2025-12-29 21:03:49.964+00
220	43	4	\N	2	2025-12-29 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica		123456	\N	2025-12-29 22:29:57.068+00	2025-12-29 22:30:27.855+00	José	2025-12-29 22:30:27.855+00	\N
214	179	3	\N	1	2025-12-29 19:15:00+00	NONE	COMPLETED	\N	Cita de prueba 9 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:51.922+00	2025-12-29 21:09:12.825+00	Paciente Test 9 - Dr. Yinno Custodio Hernández	2025-12-29 19:05:00+00	2025-12-29 21:05:55.909+00
217	182	3	\N	1	2025-12-29 20:00:00+00	NONE	COMPLETED	\N	Cita de prueba 10 para Dr. Yinno Custodio Hernández	999888777	\N	2025-12-29 17:02:52.071+00	2025-12-29 21:14:38.741+00	Paciente Test 10 - Dr. Yinno Custodio Hernández	2025-12-29 19:50:00+00	2025-12-29 21:14:38.005+00
198	163	1	\N	1	2025-12-29 15:15:00+00	NONE	COMPLETED	\N	Cita de prueba 4 para Dr. Antonio Camargo Acosta	999888777	\N	2025-12-29 17:02:51.652+00	2025-12-29 21:24:21.386+00	Paciente Test 4 - Dr. Antonio Camargo Acosta	2025-12-29 15:05:00+00	2025-12-29 21:24:19.553+00
221	43	4	\N	2	2025-12-29 13:00:00+00	NONE	CHECKED_IN	Radiología Oncológica	3423	342423	\N	2025-12-29 22:32:11.583+00	2025-12-29 22:32:33.241+00	423	2025-12-29 22:32:33.241+00	\N
\.


--
-- Data for Name: chemo_chairs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chemo_chairs (id, "chairLabel", "isOccupied", "occupiedByPatientId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: doctor_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_schedules (id, doctor_id, day_of_week, is_active) FROM stdin;
1	5	1	t
2	5	2	t
3	5	3	t
4	5	4	t
5	5	5	t
6	6	1	t
7	6	2	t
8	6	3	t
9	6	4	t
10	6	5	t
11	7	1	t
12	7	2	t
13	7	3	t
14	7	4	t
15	7	5	t
16	8	1	t
17	8	2	t
18	8	3	t
19	8	4	t
20	8	5	t
21	9	1	t
22	9	2	t
23	9	3	t
24	9	4	t
25	9	5	t
26	10	1	t
27	10	2	t
28	10	3	t
29	10	4	t
30	10	5	t
31	11	1	t
32	11	2	t
33	11	3	t
34	11	4	t
35	11	5	t
36	1	1	t
37	1	2	t
38	1	3	t
39	1	4	t
40	1	5	t
41	2	1	t
42	2	2	t
43	2	3	t
44	2	4	t
45	2	5	t
46	3	1	t
47	3	2	t
48	3	3	t
49	3	4	t
50	3	5	t
51	4	1	t
53	4	3	t
55	4	5	t
56	1	0	t
57	1	6	t
58	3	0	t
59	3	6	t
60	4	0	t
52	4	2	t
54	4	4	t
61	4	6	t
62	5	0	t
63	5	6	t
64	6	0	t
65	6	6	t
66	7	0	t
67	7	6	t
68	8	0	t
69	8	6	t
70	9	0	t
71	9	6	t
72	10	0	t
73	10	6	t
74	11	0	t
75	11	6	t
76	2	0	t
77	2	6	t
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, name, dni, email, phone, status, daily_quota, specialty_id, medical_center_id) FROM stdin;
1	Dr. Antonio Camargo Acosta	032867	antonio.camargo@onkos.pe	\N	activo	20	1	\N
3	Dr. Yinno Custodio Hernández	064281	yinno.custodio@onkos.pe	\N	activo	20	1	\N
4	Dr. Roberto Cavero Cueva	032826	cavero@onkos.pe	\N	activo	20	2	\N
5	Dr. Daniel Solari Che	069546	\N	\N	inactivo	10	3	\N
6	Dr. Oscar Ibarra Lavado	026560	\N	\N	inactivo	10	3	\N
7	Dr. Gustavo Cueva Aguirre	029120	\N	\N	inactivo	10	4	\N
8	Dra. Guiselle Gutierrez Guerra	028927	\N	\N	inactivo	10	5	\N
9	Dr. German Villegas Vásquez	021126	\N	\N	inactivo	10	6	\N
10	Dra. Marylin Toledo Cárdenas	6629	\N	\N	inactivo	10	7	\N
11	Dra. Melina Ames Manrique	9557	\N	\N	inactivo	10	8	\N
2	Dr. Rómulo Cárdenas Agramonte	011650	\N	\N	inactivo	10	1	\N
\.


--
-- Data for Name: medical_centers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_centers (id, name, address, phone, email, tax_id) FROM stdin;
1	Instituto Oncológico	Av. Principal 123	123456789	\N	\N
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (id, name, dni, phone, email, birth_date, vital_status, registration_date, status, document_type, document_number, onc_dni, ssg_dni, medical_record_number) FROM stdin;
36	Gabi Perexz	\N	+51981255674	njgimenez@gmail.com	2012-08-19	vivo	2025-09-12 02:56:22.633+00	activo	DNI	\N	\N	\N	\N
10	Ramon Peres	\N	+51981288354	njgimenez@proton.com	1978-06-19	vivo	2025-08-12 23:53:24.491+00	activo	DNI	\N	\N	\N	\N
11	Raul perex	\N	+51988873733	njgimenez@gmail.com	1978-06-19	vivo	2025-08-14 20:17:40.079+00	activo	DNI	\N	\N	\N	\N
12	María García	\N	+51987654322	maria.garcia@email.com	1990-05-14	vivo	2025-09-10 03:20:33.82+00	activo	DNI	\N	\N	\N	\N
37	Nelson Giménez	DNI 987987987	+51987987987	njgimenez@gmail.com	\N	vivo	2025-09-20 00:02:58.567+00	activo	DNI	\N	\N	\N	\N
38	Carmen gil	DNI 987456321	+51987456321	nsnsn@haha.com	\N	vivo	2025-09-20 00:05:17.724+00	activo	DNI	\N	\N	\N	\N
39	Jorge Chavez	DNI 456789123	+51984525871	nshsh@gsgsgh.com	\N	vivo	2025-09-20 02:43:29.255+00	activo	DNI	\N	\N	\N	\N
40	Nelson J	DNI 12345678	+51984561237	njfimen@hdhd.com	\N	vivo	2025-09-26 01:42:07.35+00	activo	DNI	\N	\N	\N	\N
13	Carlos López	\N	+51987654323	carlos.lopez@email.com	1985-08-19	vivo	2025-09-10 03:20:34.158+00	activo	DNI	\N	\N	\N	\N
14	Ana Martínez	\N	+51987654324	ana.martinez@email.com	1992-03-09	vivo	2025-09-10 03:20:37.824+00	activo	DNI	\N	\N	\N	\N
15	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez@email.com	1988-12-04	vivo	2025-09-10 03:20:39.443+00	activo	DNI	\N	\N	\N	\N
41	Carmen Yanina Ceccarelli Leon de Gutierrez	cc 10004162	964642934	financialconsultingm@gmail.com	\N	vivo	2025-12-07 01:23:22.779+00	activo	DNI	\N	\N	\N	\N
42	claudia Bustios Alva	cc 09935765	+51993044108	mbustiosalva@gmail.com	\N	vivo	2025-12-10 05:13:08.532+00	activo	DNI	\N	\N	\N	\N
51	Test Patient Doorbell	\N	555-555-555	\N	\N	alive	2025-12-23 12:03:19.925+00	active	DNI	\N	\N	\N	\N
52	Test Patient Doorbell	\N	555-555-555	\N	\N	alive	2025-12-23 12:06:21.521+00	active	DNI	\N	\N	\N	\N
53	Test Patient Doorbell	\N	555-555-555	\N	\N	alive	2025-12-23 12:17:32.576+00	active	DNI	\N	\N	\N	\N
54	Miguel Sanchez	\N	997656731	miguel.sanchez@example.com	\N	alive	2025-12-23 12:30:16.557+00	active	DNI	\N	\N	\N	\N
55	Ricardo Gomez	\N	916671333	ricardo.gomez@example.com	\N	alive	2025-12-23 12:30:16.613+00	active	DNI	\N	\N	\N	\N
56	Luis Sanchez	\N	959770211	luis.sanchez@example.com	\N	alive	2025-12-23 12:30:16.626+00	active	DNI	\N	\N	\N	\N
34	Ana Martínez Actualizada	\N	+51987654325	ana.martinez.nuevo@email.com	1992-03-09	vivo	2025-09-10 03:25:19.924+00	activo	DNI	9988776679	\N	\N	ONC-9988776679
57	David Hernandez	\N	982346514	david.hernandez@example.com	\N	alive	2025-12-23 12:30:16.637+00	active	DNI	\N	\N	\N	\N
58	Maria Martinez	\N	922477299	maria.martinez@example.com	\N	alive	2025-12-23 12:30:16.648+00	active	DNI	\N	\N	\N	\N
59	Elena Gomez	\N	987812612	elena.gomez@example.com	\N	alive	2025-12-23 12:30:16.657+00	active	DNI	\N	\N	\N	\N
60	David Diaz	\N	970582488	david.diaz@example.com	\N	alive	2025-12-23 12:30:16.664+00	active	DNI	\N	\N	\N	\N
61	Jorge Castillo	\N	988396386	jorge.castillo@example.com	\N	alive	2025-12-23 12:30:16.673+00	active	DNI	\N	\N	\N	\N
62	Teresa Diaz	\N	972271878	teresa.diaz@example.com	\N	alive	2025-12-23 12:30:16.681+00	active	DNI	\N	\N	\N	\N
63	Patricia Vasquez	\N	931678317	patricia.vasquez@example.com	\N	alive	2025-12-23 12:30:16.69+00	active	DNI	\N	\N	\N	\N
64	Luis Castillo	\N	936501344	luis.castillo@example.com	\N	alive	2025-12-23 12:37:59.219+00	active	DNI	\N	\N	\N	\N
65	Maria Perez	\N	972848883	maria.perez@example.com	\N	alive	2025-12-23 12:37:59.293+00	active	DNI	\N	\N	\N	\N
66	Ana Morales	\N	995881815	ana.morales@example.com	\N	alive	2025-12-23 12:37:59.311+00	active	DNI	\N	\N	\N	\N
67	Teresa Ortiz	\N	927109603	teresa.ortiz@example.com	\N	alive	2025-12-23 12:37:59.327+00	active	DNI	\N	\N	\N	\N
68	Pedro Vasquez	\N	967713446	pedro.vasquez@example.com	\N	alive	2025-12-23 12:37:59.34+00	active	DNI	\N	\N	\N	\N
69	Sofia Rodriguez	\N	947180795	sofia.rodriguez@example.com	\N	alive	2025-12-23 12:37:59.352+00	active	DNI	\N	\N	\N	\N
70	Carmen Martinez	\N	925411387	carmen.martinez@example.com	\N	alive	2025-12-23 12:37:59.363+00	active	DNI	\N	\N	\N	\N
71	Juan Rivera	\N	995540637	juan.rivera@example.com	\N	alive	2025-12-23 12:37:59.375+00	active	DNI	\N	\N	\N	\N
72	Lucia Ortiz	\N	986487130	lucia.ortiz@example.com	\N	alive	2025-12-23 12:37:59.395+00	active	DNI	\N	\N	\N	\N
73	Lucia Sanchez	\N	931104836	lucia.sanchez@example.com	\N	alive	2025-12-23 12:37:59.406+00	active	DNI	\N	\N	\N	\N
74	Carmen Chavez	\N	934379316	carmen.chavez@example.com	\N	alive	2025-12-23 12:37:59.417+00	active	DNI	\N	\N	\N	\N
75	Laura Morales	\N	997439221	laura.morales@example.com	\N	alive	2025-12-23 12:37:59.429+00	active	DNI	\N	\N	\N	\N
76	Elena Perez	\N	915665557	elena.perez@example.com	\N	alive	2025-12-23 12:37:59.44+00	active	DNI	\N	\N	\N	\N
77	Miguel Morales	\N	929410560	miguel.morales@example.com	\N	alive	2025-12-23 12:37:59.451+00	active	DNI	\N	\N	\N	\N
78	Lucia Castillo	\N	995761088	lucia.castillo@example.com	\N	alive	2025-12-23 12:37:59.46+00	active	DNI	\N	\N	\N	\N
79	Teresa Martinez	\N	989108662	teresa.martinez@example.com	\N	alive	2025-12-23 12:37:59.47+00	active	DNI	\N	\N	\N	\N
80	Luis Chavez	\N	920392384	luis.chavez@example.com	\N	alive	2025-12-23 12:37:59.48+00	active	DNI	\N	\N	\N	\N
81	Lucia Perez	\N	967981218	lucia.perez@example.com	\N	alive	2025-12-23 12:37:59.49+00	active	DNI	\N	\N	\N	\N
82	Teresa Garcia	\N	977194726	teresa.garcia@example.com	\N	alive	2025-12-23 12:37:59.501+00	active	DNI	\N	\N	\N	\N
83	Lucia Vasquez	\N	939436338	lucia.vasquez@example.com	\N	alive	2025-12-23 12:37:59.513+00	active	DNI	\N	\N	\N	\N
84	David Garcia	\N	932960217	david.garcia@example.com	\N	alive	2025-12-23 12:37:59.524+00	active	DNI	\N	\N	\N	\N
85	Teresa Lopez	\N	923430666	teresa.lopez@example.com	\N	alive	2025-12-23 12:37:59.535+00	active	DNI	\N	\N	\N	\N
86	Laura Martinez	\N	932859144	laura.martinez@example.com	\N	alive	2025-12-23 12:37:59.548+00	active	DNI	\N	\N	\N	\N
87	Jorge Garcia	\N	980532699	jorge.garcia@example.com	\N	alive	2025-12-23 12:37:59.561+00	active	DNI	\N	\N	\N	\N
88	Miguel Ramirez	\N	949442030	miguel.ramirez@example.com	\N	alive	2025-12-23 12:37:59.574+00	active	DNI	\N	\N	\N	\N
89	Jorge Vasquez	\N	948555586	jorge.vasquez@example.com	\N	alive	2025-12-23 12:37:59.585+00	active	DNI	\N	\N	\N	\N
90	Luis Vasquez	\N	989075030	luis.vasquez@example.com	\N	alive	2025-12-23 12:37:59.595+00	active	DNI	\N	\N	\N	\N
91	Elena Castillo	\N	920970782	elena.castillo@example.com	\N	alive	2025-12-23 12:37:59.606+00	active	DNI	\N	\N	\N	\N
92	Ricardo Martinez	\N	960079661	ricardo.martinez@example.com	\N	alive	2025-12-23 12:37:59.617+00	active	DNI	\N	\N	\N	\N
93	Patricia Rodriguez	\N	997705457	patricia.rodriguez@example.com	\N	alive	2025-12-23 12:37:59.628+00	active	DNI	\N	\N	\N	\N
94	Elena Ortiz	\N	961693864	elena.ortiz@example.com	\N	alive	2025-12-23 14:23:33.686+00	active	DNI	\N	\N	\N	\N
95	David Rodriguez	\N	980291257	david.rodriguez@example.com	\N	alive	2025-12-23 14:23:33.775+00	active	DNI	\N	\N	\N	\N
96	Luis Diaz	\N	990785847	luis.diaz@example.com	\N	alive	2025-12-23 14:23:33.798+00	active	DNI	\N	\N	\N	\N
97	Miguel Chavez	\N	957766598	miguel.chavez@example.com	\N	alive	2025-12-23 14:23:33.817+00	active	DNI	\N	\N	\N	\N
98	Ricardo Hernandez	\N	928487656	ricardo.hernandez@example.com	\N	alive	2025-12-23 14:23:33.837+00	active	DNI	\N	\N	\N	\N
99	Sofia Flores	\N	980860655	sofia.flores@example.com	\N	alive	2025-12-23 14:23:33.85+00	active	DNI	\N	\N	\N	\N
100	Fernando Gomez	\N	921137717	fernando.gomez@example.com	\N	alive	2025-12-23 14:23:33.866+00	active	DNI	\N	\N	\N	\N
101	David Lopez	\N	988268698	david.lopez@example.com	\N	alive	2025-12-23 14:23:33.879+00	active	DNI	\N	\N	\N	\N
102	Laura Diaz	\N	972674431	laura.diaz@example.com	\N	alive	2025-12-23 14:23:33.894+00	active	DNI	\N	\N	\N	\N
103	Maria Flores	\N	919248494	maria.flores@example.com	\N	alive	2025-12-23 14:23:33.931+00	active	DNI	\N	\N	\N	\N
104	Lucia Perez	\N	945823007	lucia.perez@example.com	\N	alive	2025-12-23 14:23:33.944+00	active	DNI	\N	\N	\N	\N
105	Teresa Chavez	\N	932707535	teresa.chavez@example.com	\N	alive	2025-12-23 14:23:33.958+00	active	DNI	\N	\N	\N	\N
106	Isabel Sanchez	\N	964044940	isabel.sanchez@example.com	\N	alive	2025-12-23 14:23:33.971+00	active	DNI	\N	\N	\N	\N
107	Lucia Reyes	\N	956516691	lucia.reyes@example.com	\N	alive	2025-12-23 14:23:33.984+00	active	DNI	\N	\N	\N	\N
108	Carlos Chavez	\N	912115613	carlos.chavez@example.com	\N	alive	2025-12-23 14:23:34+00	active	DNI	\N	\N	\N	\N
109	Pedro Ramirez	\N	930734797	pedro.ramirez@example.com	\N	alive	2025-12-23 14:23:34.014+00	active	DNI	\N	\N	\N	\N
110	Sofia Gomez	\N	952221342	sofia.gomez@example.com	\N	alive	2025-12-23 14:23:34.028+00	active	DNI	\N	\N	\N	\N
111	Patricia Hernandez	\N	998420496	patricia.hernandez@example.com	\N	alive	2025-12-23 14:23:34.041+00	active	DNI	\N	\N	\N	\N
112	Laura Gonzalez	\N	998054215	laura.gonzalez@example.com	\N	alive	2025-12-23 14:23:34.057+00	active	DNI	\N	\N	\N	\N
113	Lucia Lopez	\N	935843850	lucia.lopez@example.com	\N	alive	2025-12-23 14:23:34.071+00	active	DNI	\N	\N	\N	\N
114	Ana Hernandez	\N	916266670	ana.hernandez@example.com	\N	alive	2025-12-23 14:23:34.087+00	active	DNI	\N	\N	\N	\N
115	Juan Flores	\N	938755857	juan.flores@example.com	\N	alive	2025-12-23 14:23:34.103+00	active	DNI	\N	\N	\N	\N
116	Isabel Diaz	\N	959885041	isabel.diaz@example.com	\N	alive	2025-12-23 14:23:34.118+00	active	DNI	\N	\N	\N	\N
117	Ricardo Garcia	\N	951843278	ricardo.garcia@example.com	\N	alive	2025-12-23 14:23:34.135+00	active	DNI	\N	\N	\N	\N
118	Pedro Diaz	\N	931627155	pedro.diaz@example.com	\N	alive	2025-12-23 14:23:34.15+00	active	DNI	\N	\N	\N	\N
119	Lucia Torres	\N	979492634	lucia.torres@example.com	\N	alive	2025-12-23 14:23:34.166+00	active	DNI	\N	\N	\N	\N
120	Miguel Gonzalez	\N	964537474	miguel.gonzalez@example.com	\N	alive	2025-12-23 14:23:34.178+00	active	DNI	\N	\N	\N	\N
121	Maria Chavez	\N	972784726	maria.chavez@example.com	\N	alive	2025-12-23 14:23:34.194+00	active	DNI	\N	\N	\N	\N
122	Carlos Ortiz	\N	944637121	carlos.ortiz@example.com	\N	alive	2025-12-23 14:23:34.207+00	active	DNI	\N	\N	\N	\N
123	David Flores	\N	913496074	david.flores@example.com	\N	alive	2025-12-23 14:23:34.222+00	active	DNI	\N	\N	\N	\N
124	Carlos Sanchez	\N	946233853	carlos.sanchez@example.com	\N	alive	2025-12-23 15:06:39.461+00	active	DNI	\N	\N	\N	\N
125	Juan Rivera	\N	967687585	juan.rivera@example.com	\N	alive	2025-12-23 15:06:39.543+00	active	DNI	\N	\N	\N	\N
126	Carlos Flores	\N	934118355	carlos.flores@example.com	\N	alive	2025-12-23 15:06:39.561+00	active	DNI	\N	\N	\N	\N
127	Maria Sanchez	\N	957398944	maria.sanchez@example.com	\N	alive	2025-12-23 15:06:39.581+00	active	DNI	\N	\N	\N	\N
128	Juan Vasquez	\N	940297062	juan.vasquez@example.com	\N	alive	2025-12-23 15:06:39.596+00	active	DNI	\N	\N	\N	\N
129	Juan Castillo	\N	941985908	juan.castillo@example.com	\N	alive	2025-12-23 15:06:39.608+00	active	DNI	\N	\N	\N	\N
130	Luis Rodriguez	\N	965912822	luis.rodriguez@example.com	\N	alive	2025-12-23 15:06:39.621+00	active	DNI	\N	\N	\N	\N
131	Jorge Rivera	\N	916871803	jorge.rivera@example.com	\N	alive	2025-12-23 15:06:39.633+00	active	DNI	\N	\N	\N	\N
132	Isabel Ramirez	\N	986946113	isabel.ramirez@example.com	\N	alive	2025-12-23 15:06:39.643+00	active	DNI	\N	\N	\N	\N
133	Patricia Ortiz	\N	959351157	patricia.ortiz@example.com	\N	alive	2025-12-23 15:06:39.654+00	active	DNI	\N	\N	\N	\N
134	Miguel Flores	\N	948999083	miguel.flores@example.com	\N	alive	2025-12-23 15:06:39.665+00	active	DNI	\N	\N	\N	\N
135	Sofia Reyes	\N	956417145	sofia.reyes@example.com	\N	alive	2025-12-23 15:06:39.676+00	active	DNI	\N	\N	\N	\N
136	Teresa Ramirez	\N	928717982	teresa.ramirez@example.com	\N	alive	2025-12-23 15:06:39.688+00	active	DNI	\N	\N	\N	\N
137	Teresa Diaz	\N	929656242	teresa.diaz@example.com	\N	alive	2025-12-23 15:06:39.699+00	active	DNI	\N	\N	\N	\N
138	Juan Castillo	\N	977561515	juan.castillo@example.com	\N	alive	2025-12-23 15:06:39.709+00	active	DNI	\N	\N	\N	\N
139	Ana Rivera	\N	996229752	ana.rivera@example.com	\N	alive	2025-12-23 15:06:39.721+00	active	DNI	\N	\N	\N	\N
140	Sofia Perez	\N	986779084	sofia.perez@example.com	\N	alive	2025-12-23 15:06:39.733+00	active	DNI	\N	\N	\N	\N
141	Carlos Ortiz	\N	930271126	carlos.ortiz@example.com	\N	alive	2025-12-23 15:06:39.745+00	active	DNI	\N	\N	\N	\N
142	Jose Lopez	\N	944262458	jose.lopez@example.com	\N	alive	2025-12-23 15:06:39.758+00	active	DNI	\N	\N	\N	\N
143	Teresa Flores	\N	979177393	teresa.flores@example.com	\N	alive	2025-12-23 15:06:39.772+00	active	DNI	\N	\N	\N	\N
144	Jorge Gomez	\N	971278483	jorge.gomez@example.com	\N	alive	2025-12-23 15:06:39.785+00	active	DNI	\N	\N	\N	\N
145	Maria Gonzalez	\N	938441607	maria.gonzalez@example.com	\N	alive	2025-12-23 15:06:39.796+00	active	DNI	\N	\N	\N	\N
146	Carmen Reyes	\N	953836536	carmen.reyes@example.com	\N	alive	2025-12-23 15:06:39.809+00	active	DNI	\N	\N	\N	\N
147	Miguel Vasquez	\N	955236395	miguel.vasquez@example.com	\N	alive	2025-12-23 15:06:39.821+00	active	DNI	\N	\N	\N	\N
148	Ana Chavez	\N	919883586	ana.chavez@example.com	\N	alive	2025-12-23 15:06:39.834+00	active	DNI	\N	\N	\N	\N
149	David Ortiz	\N	986242421	david.ortiz@example.com	\N	alive	2025-12-23 15:06:39.851+00	active	DNI	\N	\N	\N	\N
150	Miguel Ramirez	\N	996142475	miguel.ramirez@example.com	\N	alive	2025-12-23 15:06:39.862+00	active	DNI	\N	\N	\N	\N
151	Lucia Chavez	\N	960523440	lucia.chavez@example.com	\N	alive	2025-12-23 15:06:39.875+00	active	DNI	\N	\N	\N	\N
152	Fernando Ramirez	\N	970277731	fernando.ramirez@example.com	\N	alive	2025-12-23 15:06:39.888+00	active	DNI	\N	\N	\N	\N
153	Miguel Hernandez	\N	945228039	miguel.hernandez@example.com	\N	alive	2025-12-23 15:06:39.9+00	active	DNI	\N	\N	\N	\N
35	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438720179@email.com	1988-12-04	vivo	2025-09-10 03:25:20.588+00	activo	DNI	5544332179	\N	\N	ONC-5544332179
4	Nelson Aguilar	23232323	981288370	ngimenezia@gmail.com	1978-06-19	vivo	2025-08-08 22:10:05.804+00	activo	DNI	23232323	\N	\N	ONC-23232323
5	Carlos Groom	59595959	569856985	carlos@groom.com	1978-09-14	vivo	2025-08-08 22:24:17.14+00	activo	DNI	59595959	\N	\N	ONC-59595959
6	Luis Perez	12541254	4526357	luis@gmail.com	1978-06-19	vivo	2025-08-09 00:55:35.453+00	activo	DNI	12541254	\N	\N	ONC-12541254
7	Nelson Carmona	45612389	981258645	nkjgfii@jdjo.com	1978-08-19	vivo	2025-08-09 02:30:32.963+00	activo	DNI	45612389	\N	\N	ONC-45612389
8	Carmen Linarez	12365478	987654321	carmen@gmail.com	1979-12-12	vivo	2025-08-09 03:24:15.495+00	activo	DNI	12365478	\N	\N	ONC-12365478
9	Nelson Gimenez	25872589	78542584	njgimenea@mai.com	1990-06-19	vivo	2025-08-12 22:58:51.687+00	activo	DNI	25872589	\N	\N	ONC-25872589
20	Carlos López	\N	+51987654323	carlos.lopez.1757438616212@email.com	1985-08-19	vivo	2025-09-10 03:23:36.457+00	activo	DNI	1122334212	\N	\N	ONC-1122334212
21	Ana Martínez	\N	+51987654324	ana.martinez.1757438617136@email.com	1992-03-09	vivo	2025-09-10 03:23:37.402+00	activo	DNI	9988776136	\N	\N	ONC-9988776136
22	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438617680@email.com	1988-12-04	vivo	2025-09-10 03:23:39.018+00	activo	DNI	5544332680	\N	\N	ONC-5544332680
23	María García	\N	+51987654322	maria.garcia.1757438648394@email.com	1990-05-14	vivo	2025-09-10 03:24:08.634+00	activo	DNI	8765432394	\N	\N	ONC-8765432394
24	Carlos López	\N	+51987654323	carlos.lopez.1757438648718@email.com	1985-08-19	vivo	2025-09-10 03:24:08.966+00	activo	DNI	1122334718	\N	\N	ONC-1122334718
25	Ana Martínez Actualizada	\N	+51987654325	ana.martinez.nuevo@email.com	1992-03-09	vivo	2025-09-10 03:24:10.048+00	activo	DNI	9988776805	\N	\N	ONC-9988776805
26	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438650306@email.com	1988-12-04	vivo	2025-09-10 03:24:10.712+00	activo	DNI	5544332306	\N	\N	ONC-5544332306
27	María García	\N	+51987654322	maria.garcia.1757438664112@email.com	1990-05-14	vivo	2025-09-10 03:24:24.371+00	activo	DNI	8765432112	\N	\N	ONC-8765432112
28	Carlos López	\N	+51987654323	carlos.lopez.1757438664458@email.com	1985-08-19	vivo	2025-09-10 03:24:24.7+00	activo	DNI	1122334458	\N	\N	ONC-1122334458
29	Ana Martínez Actualizada	\N	+51987654325	ana.martinez.nuevo@email.com	1992-03-09	vivo	2025-09-10 03:24:25.616+00	activo	DNI	9988776372	\N	\N	ONC-9988776372
30	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438665872@email.com	1988-12-04	vivo	2025-09-10 03:24:26.283+00	activo	DNI	5544332872	\N	\N	ONC-5544332872
31	Test Patient	\N	+51987654322	test.1757438685178@email.com	1990-05-14	vivo	2025-09-10 03:24:46.399+00	activo	DNI	test1757438685178	\N	\N	ONC-test1757438685178
32	María García	\N	+51987654322	maria.garcia.1757438718249@email.com	1990-05-14	vivo	2025-09-10 03:25:18.506+00	activo	DNI	8765432249	\N	\N	ONC-8765432249
33	Carlos López	\N	+51987654323	carlos.lopez.1757438718599@email.com	1985-08-19	vivo	2025-09-10 03:25:18.844+00	activo	DNI	1122334599	\N	\N	ONC-1122334599
1	Juan Pérez	11223344	999888777	jperez@mail.com	\N	vivo	2025-08-08 21:19:23.857+00	activo	DNI	11223344	\N	\N	ONC-11223344
2	María López	44332211	777888999	mlopez@mail.com	\N	vivo	2025-08-08 21:19:23.857+00	activo	DNI	44332211	\N	\N	ONC-44332211
3	Roberto Silva	55667788	666777888	rsilva@mail.com	\N	vivo	2025-08-08 21:19:23.857+00	activo	DNI	55667788	\N	\N	ONC-55667788
16	María García	\N	+51987654322	maria.garcia@email.com	1990-05-14	vivo	2025-09-10 03:22:24.27+00	activo	DNI	87654321	\N	\N	ONC-87654321
17	Ana Martínez	\N	+51987654324	ana.martinez@email.com	1992-03-09	vivo	2025-09-10 03:22:25.028+00	activo	DNI	99887766	\N	\N	ONC-99887766
18	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez@email.com	1988-12-04	vivo	2025-09-10 03:22:26.902+00	activo	DNI	55443322	\N	\N	ONC-55443322
19	María García	\N	+51987654322	maria.garcia.1757438615877@email.com	1990-05-14	vivo	2025-09-10 03:23:36.123+00	activo	DNI	8765432877	\N	\N	ONC-8765432877
43	TERRONES ARTEAGA JOSE TOMAS	17859853	\N	\N	1952-12-22	alive	2025-12-19 19:05:31.066+00	activo	DNI	17859853	\N	\N	ONC-17859853
44	ANA PATRICIA CONTRERAS VILLAVICENCIO	70025425	\N	\N	1982-08-02	alive	2025-12-19 19:12:55.156+00	activo	DNI	70025425	\N	\N	ONC-70025425
45	NELSON JOSE GIMENEZ AGUILAR	004300122	\N	\N	1978-06-20	alive	2025-12-19 19:15:27.224+00	activo	DNI	004300122	\N	\N	ONC-004300122
46	CASTILLO GOMES VANESSA SILVIA	43451826	\N	\N	1986-02-18	alive	2025-12-19 19:52:29.28+00	activo	DNI	43451826	\N	\N	ONC-43451826
47	JORGE LUIS SANTOS VALENCIA	41379060	\N	\N	1982-04-21	alive	2025-12-19 21:58:37.499+00	activo	DNI	41379060	\N	\N	ONC-41379060
48	Gomez Milagros	000910918	\N	\N	\N	alive	2025-12-22 18:46:09.893+00	activo	DNI	000910918	\N	\N	ONC-000910918
49	NELSON JOSE GOMEZ AGUILAR	094308122	\N	\N	1978-01-28	alive	2025-12-22 21:08:40.602+00	activo	DNI	094308122	\N	\N	ONC-094308122
50	NELSON JORGE GIMENEZ AGUILAR	004380122	\N	\N	1976-06-30	alive	2025-12-22 22:05:08.132+00	activo	DNI	004380122	\N	\N	ONC-004380122
154	Paciente Test 1 - Dr. Antonio Camargo Acosta	20292376	999888777	test01@example.com	\N	alive	2025-12-29 17:02:51.38+00	activo	DNI	20292376	\N	\N	ONC-20292376
155	Paciente Test 1 - Dr. Yinno Custodio Hernández	55883402	999888777	test03@example.com	\N	alive	2025-12-29 17:02:51.498+00	activo	DNI	55883402	\N	\N	ONC-55883402
156	Paciente Test 1 - Dr. Roberto Cavero Cueva	90820863	999888777	test04@example.com	\N	alive	2025-12-29 17:02:51.526+00	activo	DNI	90820863	\N	\N	ONC-90820863
157	Paciente Test 2 - Dr. Antonio Camargo Acosta	68025190	999888777	test11@example.com	\N	alive	2025-12-29 17:02:51.549+00	activo	DNI	68025190	\N	\N	ONC-68025190
158	Paciente Test 2 - Dr. Yinno Custodio Hernández	60145172	999888777	test13@example.com	\N	alive	2025-12-29 17:02:51.568+00	activo	DNI	60145172	\N	\N	ONC-60145172
159	Paciente Test 2 - Dr. Roberto Cavero Cueva	95327461	999888777	test14@example.com	\N	alive	2025-12-29 17:02:51.585+00	activo	DNI	95327461	\N	\N	ONC-95327461
160	Paciente Test 3 - Dr. Antonio Camargo Acosta	82903650	999888777	test21@example.com	\N	alive	2025-12-29 17:02:51.602+00	activo	DNI	82903650	\N	\N	ONC-82903650
161	Paciente Test 3 - Dr. Yinno Custodio Hernández	91711865	999888777	test23@example.com	\N	alive	2025-12-29 17:02:51.617+00	activo	DNI	91711865	\N	\N	ONC-91711865
162	Paciente Test 3 - Dr. Roberto Cavero Cueva	18880002	999888777	test24@example.com	\N	alive	2025-12-29 17:02:51.631+00	activo	DNI	18880002	\N	\N	ONC-18880002
163	Paciente Test 4 - Dr. Antonio Camargo Acosta	43586832	999888777	test31@example.com	\N	alive	2025-12-29 17:02:51.649+00	activo	DNI	43586832	\N	\N	ONC-43586832
164	Paciente Test 4 - Dr. Yinno Custodio Hernández	45494510	999888777	test33@example.com	\N	alive	2025-12-29 17:02:51.663+00	activo	DNI	45494510	\N	\N	ONC-45494510
165	Paciente Test 4 - Dr. Roberto Cavero Cueva	61242033	999888777	test34@example.com	\N	alive	2025-12-29 17:02:51.68+00	activo	DNI	61242033	\N	\N	ONC-61242033
166	Paciente Test 5 - Dr. Antonio Camargo Acosta	94798220	999888777	test41@example.com	\N	alive	2025-12-29 17:02:51.694+00	activo	DNI	94798220	\N	\N	ONC-94798220
167	Paciente Test 5 - Dr. Yinno Custodio Hernández	41047644	999888777	test43@example.com	\N	alive	2025-12-29 17:02:51.71+00	activo	DNI	41047644	\N	\N	ONC-41047644
168	Paciente Test 5 - Dr. Roberto Cavero Cueva	35712222	999888777	test44@example.com	\N	alive	2025-12-29 17:02:51.724+00	activo	DNI	35712222	\N	\N	ONC-35712222
169	Paciente Test 6 - Dr. Antonio Camargo Acosta	97411967	999888777	test51@example.com	\N	alive	2025-12-29 17:02:51.741+00	activo	DNI	97411967	\N	\N	ONC-97411967
170	Paciente Test 6 - Dr. Yinno Custodio Hernández	73071726	999888777	test53@example.com	\N	alive	2025-12-29 17:02:51.756+00	activo	DNI	73071726	\N	\N	ONC-73071726
171	Paciente Test 6 - Dr. Roberto Cavero Cueva	66956696	999888777	test54@example.com	\N	alive	2025-12-29 17:02:51.771+00	activo	DNI	66956696	\N	\N	ONC-66956696
172	Paciente Test 7 - Dr. Antonio Camargo Acosta	31148393	999888777	test61@example.com	\N	alive	2025-12-29 17:02:51.787+00	activo	DNI	31148393	\N	\N	ONC-31148393
173	Paciente Test 7 - Dr. Yinno Custodio Hernández	60217240	999888777	test63@example.com	\N	alive	2025-12-29 17:02:51.802+00	activo	DNI	60217240	\N	\N	ONC-60217240
174	Paciente Test 7 - Dr. Roberto Cavero Cueva	67492914	999888777	test64@example.com	\N	alive	2025-12-29 17:02:51.839+00	activo	DNI	67492914	\N	\N	ONC-67492914
175	Paciente Test 8 - Dr. Antonio Camargo Acosta	24435767	999888777	test71@example.com	\N	alive	2025-12-29 17:02:51.857+00	activo	DNI	24435767	\N	\N	ONC-24435767
176	Paciente Test 8 - Dr. Yinno Custodio Hernández	51973534	999888777	test73@example.com	\N	alive	2025-12-29 17:02:51.873+00	activo	DNI	51973534	\N	\N	ONC-51973534
177	Paciente Test 8 - Dr. Roberto Cavero Cueva	37048115	999888777	test74@example.com	\N	alive	2025-12-29 17:02:51.888+00	activo	DNI	37048115	\N	\N	ONC-37048115
178	Paciente Test 9 - Dr. Antonio Camargo Acosta	49300405	999888777	test81@example.com	\N	alive	2025-12-29 17:02:51.906+00	activo	DNI	49300405	\N	\N	ONC-49300405
179	Paciente Test 9 - Dr. Yinno Custodio Hernández	82129105	999888777	test83@example.com	\N	alive	2025-12-29 17:02:51.918+00	activo	DNI	82129105	\N	\N	ONC-82129105
180	Paciente Test 9 - Dr. Roberto Cavero Cueva	72230114	999888777	test84@example.com	\N	alive	2025-12-29 17:02:51.931+00	activo	DNI	72230114	\N	\N	ONC-72230114
181	Paciente Test 10 - Dr. Antonio Camargo Acosta	93946217	999888777	test91@example.com	\N	alive	2025-12-29 17:02:51.948+00	activo	DNI	93946217	\N	\N	ONC-93946217
182	Paciente Test 10 - Dr. Yinno Custodio Hernández	52757363	999888777	test93@example.com	\N	alive	2025-12-29 17:02:52.068+00	activo	DNI	52757363	\N	\N	ONC-52757363
183	Paciente Test 10 - Dr. Roberto Cavero Cueva	83414381	999888777	test94@example.com	\N	alive	2025-12-29 17:02:52.081+00	activo	DNI	83414381	\N	\N	ONC-83414381
\.


--
-- Data for Name: queues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.queues (id, "appointmentId", "ticketNumber", "serviceArea", "isCurrent", "isCompleted", "createdAt", "updatedAt") FROM stdin;
168	185	C-671	Consultorio 2	f	f	2025-12-29 16:40:23.366+00	2025-12-29 22:32:47.33+00
143	160	S-970	Consultorio	f	f	2025-12-23 15:06:39.615+00	2025-12-29 22:32:47.33+00
149	166	S-623	Consultorio	f	f	2025-12-23 15:06:39.683+00	2025-12-29 22:32:47.33+00
142	159	C-084	Consultorio	f	f	2025-12-23 15:06:39.602+00	2025-12-29 22:32:47.33+00
117	134	S-969	Consultorio	f	f	2025-12-23 14:23:33.937+00	2025-12-29 22:32:47.33+00
127	144	C-726	Consultorio	f	f	2025-12-23 14:23:34.078+00	2025-12-29 22:32:47.33+00
116	133	C-162	Consultorio	f	f	2025-12-23 14:23:33.905+00	2025-12-29 22:32:47.33+00
126	143	S-639	Consultorio	f	f	2025-12-23 14:23:34.064+00	2025-12-29 22:32:47.33+00
115	132	C-260	Consultorio	f	f	2025-12-23 14:23:33.887+00	2025-12-29 22:32:47.33+00
125	142	S-265	Consultorio	f	f	2025-12-23 14:23:34.048+00	2025-12-29 22:32:47.33+00
137	154	S-458	Consultorio	f	f	2025-12-23 14:23:34.229+00	2025-12-29 22:32:47.33+00
136	153	C-384	Consultorio	f	f	2025-12-23 14:23:34.214+00	2025-12-29 22:32:47.33+00
124	141	S-035	Consultorio	f	f	2025-12-23 14:23:34.035+00	2025-12-29 22:32:47.33+00
114	131	C-857	Consultorio	f	f	2025-12-23 14:23:33.873+00	2025-12-29 22:32:47.33+00
202	219	C-946	Consultorio 1	f	t	2025-12-29 20:48:21.09+00	2025-12-29 20:52:32.233+00
113	130	C-254	Consultorio	f	f	2025-12-23 14:23:33.857+00	2025-12-29 22:32:47.33+00
123	140	S-933	Consultorio	f	f	2025-12-23 14:23:34.022+00	2025-12-29 22:32:47.33+00
80	97	S-155	Consultorio	f	f	2025-12-23 12:37:59.32+00	2025-12-29 22:32:47.33+00
78	95	S-548	Consultorio	f	f	2025-12-23 12:37:59.283+00	2025-12-29 22:32:47.33+00
55	73	C-256	Consultorio 1	f	f	2025-12-23 11:42:29.901+00	2025-12-29 22:32:47.33+00
204	221	C-942	Consultorio 2	t	f	2025-12-29 22:32:33.247+00	2025-12-29 22:32:47.336+00
21	39	C-730	Consultorio 1	f	t	2025-12-19 19:12:55.623+00	2025-12-19 21:49:41.612+00
84	101	S-245	Consultorio	f	f	2025-12-23 12:37:59.37+00	2025-12-29 22:32:47.33+00
85	102	C-932	Consultorio	f	f	2025-12-23 12:37:59.391+00	2025-12-29 22:32:47.33+00
199	216	CO-028	Consulta Nueva	f	t	2025-12-29 17:02:51.965+00	2025-12-29 22:29:15.317+00
86	103	S-256	Consultorio	f	f	2025-12-23 12:37:59.401+00	2025-12-29 22:32:47.33+00
87	104	C-053	Consultorio	f	f	2025-12-23 12:37:59.412+00	2025-12-29 22:32:47.33+00
108	125	C-511	Consultorio	f	f	2025-12-23 14:23:33.763+00	2025-12-29 22:32:47.33+00
201	218	CO-030	Consulta Nueva	f	t	2025-12-29 17:02:52.088+00	2025-12-29 17:55:01.393+00
16	34	C-111	Consultorio 1	f	f	2025-12-18 20:57:07.113+00	2025-12-29 22:32:47.33+00
17	34	C-796	Consultorio 1	f	f	2025-12-18 20:58:51.351+00	2025-12-29 22:32:47.33+00
18	34	C-253	Consultorio 1	f	f	2025-12-18 21:00:27.185+00	2025-12-29 22:32:47.33+00
82	99	S-333	Consultorio	f	f	2025-12-23 12:37:59.345+00	2025-12-29 22:32:47.33+00
19	33	C-297	Consultorio 1	f	f	2025-12-19 19:05:31.692+00	2025-12-29 22:32:47.33+00
26	43	C-144	Consultorio 2	f	f	2025-12-19 21:58:37.605+00	2025-12-29 22:32:47.33+00
79	96	C-641	Consultorio	f	f	2025-12-23 12:37:59.303+00	2025-12-29 22:32:47.33+00
41	59	C-113	Consultorio 1	f	f	2025-12-22 18:59:34.785+00	2025-12-29 22:32:47.33+00
100	117	S-417	Consultorio	f	f	2025-12-23 12:37:59.555+00	2025-12-29 22:32:47.33+00
33	50	C-462	Consultorio 1	f	f	2025-12-19 23:28:17.458+00	2025-12-29 22:32:47.33+00
32	49	C-825	Consultorio 1	f	f	2025-12-19 23:27:52.455+00	2025-12-29 22:32:47.33+00
34	51	C-694	Consultorio 1	f	f	2025-12-19 23:42:20.814+00	2025-12-29 22:32:47.33+00
35	52	C-640	Consultorio 2	f	f	2025-12-19 23:43:35.955+00	2025-12-29 22:32:47.33+00
36	53	C-777	Consultorio 1	f	f	2025-12-19 23:46:40.991+00	2025-12-29 22:32:47.33+00
23	40	C-354	Consultorio 1	f	f	2025-12-19 19:43:27.484+00	2025-12-29 22:32:47.33+00
37	55	C-841	Consultorio 1	f	f	2025-12-22 18:31:46.098+00	2025-12-29 22:32:47.33+00
38	56	C-003	Consultorio 2	f	f	2025-12-22 18:35:42.435+00	2025-12-29 22:32:47.33+00
76	93	S-679	Consultorio	f	f	2025-12-23 12:30:16.686+00	2025-12-29 22:32:47.33+00
42	61	C-888	Consultorio 2	f	f	2025-12-22 21:08:08.341+00	2025-12-29 22:32:47.33+00
57	77	C-609	Consultorio 2	f	f	2025-12-23 11:54:23.589+00	2025-12-29 22:32:47.33+00
45	63	C-300	Consultorio 1	f	f	2025-12-22 21:43:56.679+00	2025-12-29 22:32:47.33+00
47	65	C-234	Consultorio 2	f	f	2025-12-22 22:00:21.892+00	2025-12-29 22:32:47.33+00
145	162	S-510	Consultorio	f	f	2025-12-23 15:06:39.638+00	2025-12-29 22:32:47.33+00
94	111	C-305	Consultorio	f	f	2025-12-23 12:37:59.485+00	2025-12-29 22:32:47.33+00
95	112	C-176	Consultorio	f	f	2025-12-23 12:37:59.496+00	2025-12-29 22:32:47.33+00
43	60	C-017	Consultorio 2	f	f	2025-12-22 21:08:40.655+00	2025-12-29 22:32:47.33+00
77	94	S-904	Consultorio	f	f	2025-12-23 12:30:16.695+00	2025-12-29 22:32:47.33+00
169	186	C-214	Consultorio 2	f	f	2025-12-29 16:48:52.057+00	2025-12-29 22:32:47.33+00
156	173	S-104	Consultorio	f	f	2025-12-23 15:06:39.766+00	2025-12-29 22:32:47.33+00
65	83	C-845	Consultorio 1	f	f	2025-12-23 12:14:13.169+00	2025-12-29 22:32:47.33+00
59	75	C-147	Consultorio 2	f	f	2025-12-23 11:55:26.292+00	2025-12-29 22:32:47.33+00
107	124	C-520	Consultorio	f	f	2025-12-23 12:37:59.633+00	2025-12-29 22:32:47.33+00
71	88	C-367	Consultorio	f	f	2025-12-23 12:30:16.643+00	2025-12-29 22:32:47.33+00
66	82	C-852	Consultorio 1	f	f	2025-12-23 12:14:30.327+00	2025-12-29 22:32:47.33+00
99	116	S-482	Consultorio	f	f	2025-12-23 12:37:59.542+00	2025-12-29 22:32:47.33+00
103	120	S-066	Consultorio	f	f	2025-12-23 12:37:59.59+00	2025-12-29 22:32:47.33+00
146	163	S-153	Consultorio	f	f	2025-12-23 15:06:39.649+00	2025-12-29 22:32:47.33+00
151	168	C-972	Consultorio	f	f	2025-12-23 15:06:39.705+00	2025-12-29 22:32:47.33+00
61	78	C-077	Consultorio 1	f	f	2025-12-23 12:06:00.929+00	2025-12-29 22:32:47.33+00
63	78	C-830	Consultorio 1	f	f	2025-12-23 12:11:40.591+00	2025-12-29 22:32:47.33+00
67	84	T-737	Consultorio 1	f	f	2025-12-23 12:17:32.621+00	2025-12-29 22:32:47.33+00
148	165	C-148	Consultorio	f	f	2025-12-23 15:06:39.671+00	2025-12-29 22:32:47.33+00
158	175	S-247	Consultorio	f	f	2025-12-23 15:06:39.791+00	2025-12-29 22:32:47.33+00
119	136	C-644	Consultorio	f	f	2025-12-23 14:23:33.964+00	2025-12-29 22:32:47.33+00
129	146	C-774	Consultorio	f	f	2025-12-23 14:23:34.111+00	2025-12-29 22:32:47.33+00
200	217	CO-029	Consulta Nueva	f	t	2025-12-29 17:02:52.075+00	2025-12-29 21:14:38.744+00
60	79	T-426	Consultorio 1	f	f	2025-12-23 12:03:19.987+00	2025-12-29 22:32:47.33+00
138	155	C-155	Consultorio	f	f	2025-12-23 15:06:39.532+00	2025-12-29 22:32:47.33+00
62	80	T-338	Consultorio 1	f	f	2025-12-23 12:06:21.555+00	2025-12-29 22:32:47.33+00
135	152	S-357	Consultorio	f	f	2025-12-23 14:23:34.201+00	2025-12-29 22:32:47.33+00
160	177	C-124	Consultorio	f	f	2025-12-23 15:06:39.815+00	2025-12-29 22:32:47.33+00
141	158	C-218	Consultorio	f	f	2025-12-23 15:06:39.589+00	2025-12-29 22:32:47.33+00
74	91	S-327	Consultorio	f	f	2025-12-23 12:30:16.668+00	2025-12-29 22:32:47.33+00
83	100	S-395	Consultorio	f	f	2025-12-23 12:37:59.358+00	2025-12-29 22:32:47.33+00
150	167	C-749	Consultorio	f	f	2025-12-23 15:06:39.693+00	2025-12-29 22:32:47.33+00
109	126	C-466	Consultorio	f	f	2025-12-23 14:23:33.788+00	2025-12-29 22:32:47.33+00
128	145	S-205	Consultorio	f	f	2025-12-23 14:23:34.096+00	2025-12-29 22:32:47.33+00
102	119	S-554	Consultorio	f	f	2025-12-23 12:37:59.58+00	2025-12-29 22:32:47.33+00
88	105	S-624	Consultorio	f	f	2025-12-23 12:37:59.423+00	2025-12-29 22:32:47.33+00
118	135	C-499	Consultorio	f	f	2025-12-23 14:23:33.95+00	2025-12-29 22:32:47.33+00
98	115	S-401	Consultorio	f	f	2025-12-23 12:37:59.529+00	2025-12-29 22:32:47.33+00
203	220	C-540	Consultorio 2	f	f	2025-12-29 22:30:27.861+00	2025-12-29 22:32:47.33+00
170	187	C-645	Consultorio 1	f	t	2025-12-29 16:52:14.812+00	2025-12-29 22:31:44.266+00
81	98	S-279	Consultorio	f	f	2025-12-23 12:37:59.335+00	2025-12-29 22:32:47.33+00
159	176	C-110	Consultorio	f	f	2025-12-23 15:06:39.802+00	2025-12-29 22:32:47.33+00
56	74	C-439	Consultorio 2	f	f	2025-12-23 11:43:52.068+00	2025-12-29 22:32:47.33+00
72	89	S-722	Consultorio	f	f	2025-12-23 12:30:16.653+00	2025-12-29 22:32:47.33+00
147	164	C-377	Consultorio	f	f	2025-12-23 15:06:39.659+00	2025-12-29 22:32:47.33+00
152	169	C-912	Consultorio	f	f	2025-12-23 15:06:39.716+00	2025-12-29 22:32:47.33+00
153	170	C-462	Consultorio	f	f	2025-12-23 15:06:39.726+00	2025-12-29 22:32:47.33+00
133	150	S-612	Consultorio	f	f	2025-12-23 14:23:34.172+00	2025-12-29 22:32:47.33+00
144	161	S-601	Consultorio	f	f	2025-12-23 15:06:39.627+00	2025-12-29 22:32:47.33+00
157	174	C-824	Consultorio	f	f	2025-12-23 15:06:39.778+00	2025-12-29 22:32:47.33+00
161	178	S-803	Consultorio	f	f	2025-12-23 15:06:39.828+00	2025-12-29 22:32:47.33+00
167	184	C-316	Consultorio	f	f	2025-12-23 15:06:39.907+00	2025-12-29 22:32:47.33+00
120	137	C-098	Consultorio	f	f	2025-12-23 14:23:33.978+00	2025-12-29 22:32:47.33+00
132	149	S-877	Consultorio	f	f	2025-12-23 14:23:34.159+00	2025-12-29 22:32:47.33+00
110	127	C-843	Consultorio	f	f	2025-12-23 14:23:33.809+00	2025-12-29 22:32:47.33+00
131	148	C-711	Consultorio	f	f	2025-12-23 14:23:34.143+00	2025-12-29 22:32:47.33+00
154	171	S-630	Consultorio	f	f	2025-12-23 15:06:39.739+00	2025-12-29 22:32:47.33+00
155	172	S-866	Consultorio	f	f	2025-12-23 15:06:39.753+00	2025-12-29 22:32:47.33+00
97	114	C-225	Consultorio	f	f	2025-12-23 12:37:59.518+00	2025-12-29 22:32:47.33+00
96	113	S-872	Consultorio	f	f	2025-12-23 12:37:59.507+00	2025-12-29 22:32:47.33+00
93	110	C-176	Consultorio	f	f	2025-12-23 12:37:59.476+00	2025-12-29 22:32:47.33+00
64	81	C-068	Consultorio 2	f	f	2025-12-23 12:14:00.294+00	2025-12-29 22:32:47.33+00
75	92	S-511	Consultorio	f	f	2025-12-23 12:30:16.678+00	2025-12-29 22:32:47.33+00
70	87	C-826	Consultorio	f	f	2025-12-23 12:30:16.632+00	2025-12-29 22:32:47.33+00
50	68	C-540	Consultorio 1	f	f	2025-12-22 22:10:29.003+00	2025-12-29 22:32:47.33+00
162	179	C-276	Consultorio	f	f	2025-12-23 15:06:39.84+00	2025-12-29 22:32:47.33+00
163	180	C-623	Consultorio	f	f	2025-12-23 15:06:39.857+00	2025-12-29 22:32:47.33+00
164	181	C-046	Consultorio	f	f	2025-12-23 15:06:39.87+00	2025-12-29 22:32:47.33+00
165	182	C-856	Consultorio	f	f	2025-12-23 15:06:39.883+00	2025-12-29 22:32:47.33+00
166	183	C-449	Consultorio	f	f	2025-12-23 15:06:39.894+00	2025-12-29 22:32:47.33+00
52	71	C-888	Consultorio 2	f	f	2025-12-22 22:14:16.01+00	2025-12-29 22:32:47.33+00
54	72	C-799	Consultorio 1	f	f	2025-12-23 11:29:23.882+00	2025-12-29 22:32:47.33+00
101	118	S-879	Consultorio	f	f	2025-12-23 12:37:59.568+00	2025-12-29 22:32:47.33+00
90	107	C-971	Consultorio	f	f	2025-12-23 12:37:59.445+00	2025-12-29 22:32:47.33+00
106	123	S-699	Consultorio	f	f	2025-12-23 12:37:59.623+00	2025-12-29 22:32:47.33+00
197	214	CO-026	Consulta Nueva	f	t	2025-12-29 17:02:51.925+00	2025-12-29 21:09:12.831+00
171	188	C-338	Consultorio 2	f	t	2025-12-29 16:54:52.515+00	2025-12-29 22:33:09.641+00
40	57	C-664	Consultorio 1	f	f	2025-12-22 18:46:29.951+00	2025-12-29 22:32:47.33+00
39	58	C-208	Consultorio 1	f	f	2025-12-22 18:46:09.926+00	2025-12-29 22:32:47.33+00
92	109	C-395	Consultorio	f	f	2025-12-23 12:37:59.465+00	2025-12-29 22:32:47.33+00
68	85	C-764	Consultorio	f	f	2025-12-23 12:30:16.605+00	2025-12-29 22:32:47.33+00
31	48	C-199	Consultorio 2	f	f	2025-12-19 23:27:26.428+00	2025-12-29 22:32:47.33+00
73	90	C-670	Consultorio	f	f	2025-12-23 12:30:16.661+00	2025-12-29 22:32:47.33+00
53	69	C-687	Consultorio 1	f	f	2025-12-22 22:14:33.929+00	2025-12-29 22:32:47.33+00
69	86	S-760	Consultorio	f	f	2025-12-23 12:30:16.62+00	2025-12-29 22:32:47.33+00
58	76	C-952	Consultorio 2	f	f	2025-12-23 11:55:06.753+00	2025-12-29 22:32:47.33+00
46	64	C-542	Consultorio 1	f	f	2025-12-22 21:58:38.272+00	2025-12-29 22:32:47.33+00
48	66	C-118	Consultorio 2	f	f	2025-12-22 22:04:51.942+00	2025-12-29 22:32:47.33+00
29	46	C-615	Consultorio 2	f	f	2025-12-19 23:10:28.611+00	2025-12-29 22:32:47.33+00
30	47	C-635	Consultorio 2	f	f	2025-12-19 23:14:11.084+00	2025-12-29 22:32:47.33+00
130	147	C-313	Consultorio	f	f	2025-12-23 14:23:34.128+00	2025-12-29 22:32:47.33+00
173	190	CO-002	Consulta Nueva	f	t	2025-12-29 17:02:51.514+00	2025-12-29 17:56:29.102+00
174	191	CO-003	Consulta Nueva	f	t	2025-12-29 17:02:51.539+00	2025-12-29 17:08:16.195+00
172	189	CO-001	Consulta Nueva	f	t	2025-12-29 17:02:51.438+00	2025-12-29 21:23:53.128+00
104	121	S-740	Consultorio	f	f	2025-12-23 12:37:59.601+00	2025-12-29 22:32:47.33+00
105	122	C-950	Consultorio	f	f	2025-12-23 12:37:59.612+00	2025-12-29 22:32:47.33+00
134	151	C-282	Consultorio	f	f	2025-12-23 14:23:34.185+00	2025-12-29 22:32:47.33+00
122	139	S-122	Consultorio	f	f	2025-12-23 14:23:34.008+00	2025-12-29 22:32:47.33+00
112	129	C-797	Consultorio	f	f	2025-12-23 14:23:33.844+00	2025-12-29 22:32:47.33+00
111	128	S-123	Consultorio	f	f	2025-12-23 14:23:33.827+00	2025-12-29 22:32:47.33+00
121	138	S-097	Consultorio	f	f	2025-12-23 14:23:33.994+00	2025-12-29 22:32:47.33+00
139	156	S-927	Consultorio	f	f	2025-12-23 15:06:39.554+00	2025-12-29 22:32:47.33+00
140	157	C-543	Consultorio	f	f	2025-12-23 15:06:39.573+00	2025-12-29 22:32:47.33+00
25	42	C-489	Consultorio 2	f	f	2025-12-19 19:52:29.367+00	2025-12-29 22:32:47.33+00
24	41	C-121	Consultorio 1	f	f	2025-12-19 19:47:20.881+00	2025-12-29 22:32:47.33+00
22	32	C-784	Consultorio 1	f	f	2025-12-19 19:15:27.481+00	2025-12-29 22:32:47.33+00
20	31	C-658	Consultorio 1	f	f	2025-12-19 19:10:15.338+00	2025-12-29 22:32:47.33+00
91	108	S-193	Consultorio	f	f	2025-12-23 12:37:59.455+00	2025-12-29 22:32:47.33+00
89	106	S-482	Consultorio	f	f	2025-12-23 12:37:59.434+00	2025-12-29 22:32:47.33+00
27	44	C-122	Consultorio 2	f	f	2025-12-19 22:02:33.056+00	2025-12-29 22:32:47.33+00
28	45	C-765	Consultorio 2	f	f	2025-12-19 22:57:10.945+00	2025-12-29 22:32:47.33+00
44	62	C-852	Consultorio 2	f	f	2025-12-22 21:23:21.456+00	2025-12-29 22:32:47.33+00
49	67	C-747	Consultorio 1	f	f	2025-12-22 22:05:08.166+00	2025-12-29 22:32:47.33+00
51	70	C-600	Consultorio 2	f	f	2025-12-22 22:13:59.954+00	2025-12-29 22:32:47.33+00
183	200	CO-012	Consulta Nueva	f	t	2025-12-29 17:02:51.687+00	2025-12-29 17:27:16.641+00
189	206	CO-018	Consulta Nueva	f	t	2025-12-29 17:02:51.78+00	2025-12-29 17:31:54.739+00
195	212	CO-024	Consulta Nueva	f	t	2025-12-29 17:02:51.896+00	2025-12-29 17:45:37.068+00
179	196	CO-008	Consulta Nueva	f	t	2025-12-29 17:02:51.624+00	2025-12-29 18:09:04.619+00
192	209	CO-021	Consulta Nueva	f	t	2025-12-29 17:02:51.85+00	2025-12-29 17:42:09.35+00
185	202	CO-014	Consulta Nueva	f	t	2025-12-29 17:02:51.718+00	2025-12-29 20:59:53.428+00
194	211	CO-023	Consulta Nueva	f	t	2025-12-29 17:02:51.881+00	2025-12-29 21:04:58.411+00
198	215	CO-027	Consulta Nueva	f	t	2025-12-29 17:02:51.941+00	2025-12-29 17:46:58.373+00
187	204	CO-016	Consulta Nueva	f	t	2025-12-29 17:02:51.749+00	2025-12-29 22:04:29.065+00
182	199	CO-011	Consulta Nueva	f	t	2025-12-29 17:02:51.673+00	2025-12-29 20:59:06.534+00
190	207	CO-019	Consulta Nueva	f	t	2025-12-29 17:02:51.795+00	2025-12-29 22:04:38.621+00
191	208	CO-020	Consulta Nueva	f	t	2025-12-29 17:02:51.817+00	2025-12-29 19:24:14.477+00
176	193	CO-005	Consulta Nueva	f	t	2025-12-29 17:02:51.577+00	2025-12-29 18:00:34.529+00
188	205	CO-017	Consulta Nueva	f	t	2025-12-29 17:02:51.764+00	2025-12-29 21:03:39.768+00
193	210	CO-022	Consulta Nueva	f	t	2025-12-29 17:02:51.864+00	2025-12-29 22:04:44.141+00
175	192	CO-004	Consulta Nueva	f	t	2025-12-29 17:02:51.558+00	2025-12-29 21:24:04.574+00
196	213	CO-025	Consulta Nueva	f	t	2025-12-29 17:02:51.912+00	2025-12-29 22:04:46.778+00
178	195	CO-007	Consulta Nueva	f	t	2025-12-29 17:02:51.611+00	2025-12-29 21:24:12.061+00
181	198	CO-010	Consulta Nueva	f	t	2025-12-29 17:02:51.656+00	2025-12-29 21:24:21.39+00
180	197	CO-009	Consulta Nueva	f	t	2025-12-29 17:02:51.641+00	2025-12-29 17:10:41.28+00
184	201	CO-013	Consulta Nueva	f	t	2025-12-29 17:02:51.701+00	2025-12-29 21:24:27.302+00
186	203	CO-015	Consulta Nueva	f	t	2025-12-29 17:02:51.732+00	2025-12-29 17:27:39.797+00
177	194	CO-006	Consulta Nueva	f	t	2025-12-29 17:02:51.594+00	2025-12-29 17:08:43.627+00
\.


--
-- Data for Name: recovery_rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recovery_rooms (id, "roomLabel", "isOccupied", "occupiedByPatientId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resources (id, name, type, status, "statusReason", capacity, "currentOccupancy", "currentPatientId", notes, "createdAt", "updatedAt", "doctorId", timing) FROM stdin;
19	Consultorio 2	CONSULTORIO	DISPONIBLE	\N	1	0	\N	\N	2025-12-22 18:56:59.018+00	2025-12-29 21:14:38.749+00	3	2
18	Consultorio 1	CONSULTORIO	DISPONIBLE	\N	1	0	\N	\N	2025-12-22 18:56:58.997+00	2025-12-29 22:04:49.455+00	1	2
20	Consultorio 4	CONSULTORIO	DISPONIBLE	\N	1	0	\N	\N	2025-12-22 18:56:59.032+00	2025-12-29 22:33:09.645+00	4	2
\.


--
-- Data for Name: service_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_types (id, name, description, code, icon, "createdAt", "updatedAt", show_patient) FROM stdin;
1	Consulta Nueva	Primera visita con un especialista.	CONSULTATION_NEW	🏥	2025-12-18 15:44:08.207+00	2025-12-18 18:34:37.727+00	t
2	Consulta de Seguimiento	Revisión de progreso y resultados.	CONSULTATION_FOLLOWUP	🔄	2025-12-18 15:44:08.238+00	2025-12-18 18:34:37.749+00	t
3	Sesión de Quimioterapia	Administración de esquemas quimioterapéuticos	CHEMOTHERAPY	💉	2025-12-18 15:44:08.248+00	2025-12-18 18:34:37.753+00	t
4	Procedimiento Oncológico	Biopsias, paracentesis, etc. (Requiere Orden)	PROCEDURE	💉	2025-12-18 15:44:08.259+00	2025-12-18 18:34:37.757+00	t
5	Examen de Laboratorio Oncológico	Análisis clínicos especializados.	LABORATORY_ONCO	🧪	2025-12-18 15:44:08.269+00	2025-12-18 18:34:37.764+00	t
6	Ecografía Oncológica	Estudios de imagen.	ULTRASOUND_ONCO	🔍	2025-12-18 15:44:08.279+00	2025-12-18 18:34:37.767+00	t
7	Recuperación Ambulatoria	Reposo corto, monitoreo, hidratación, analgesia post procedimiento	RECOVERY	🛌	2025-12-18 15:44:08.291+00	2025-12-18 18:34:37.771+00	t
9	Servicios de Salud General (SSG)	Vitaminas, inyecciones, hidrataciones, ecografías y laboratorio general	GENERAL_HEALTH	🩺	2025-12-18 15:44:08.318+00	2025-12-18 18:34:37.783+00	t
8	Emergencia Oncológica	Emergencia ante urgencias oncológicas	EMERGENCY_ONCO	🚨	2025-12-18 15:44:08.301+00	2025-12-18 18:34:37.777+00	t
\.


--
-- Data for Name: specialties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specialties (id, name, description, icon) FROM stdin;
1	Oncología Médica	\N	\N
8	Farmacia Oncológica	\N	\N
6	Cirugía Oncológica	\N	\N
7	Psico-oncología	\N	\N
5	Patología Oncológica	\N	\N
2	Radiología Oncológica	\N	\N
3	Ginecología Oncológica	\N	\N
4	Medicina Intensiva Oncológica	\N	\N
11	Oncología General	General Oncology	\N
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (id, name, email, password, role, "createdAt", "updatedAt") FROM stdin;
1	Admin User	admin@onkos.pe	password123	ADMIN	2025-12-18 15:44:08.332+00	2025-12-18 15:44:08.332+00
2	Reception User	recepcion@onkos.pe	password123	RECEPTIONIST	2025-12-18 15:44:08.346+00	2025-12-18 15:44:08.346+00
3	Quote Manager	cotizaciones@onkos.pe	password123	QUOTE_MANAGER	2025-12-18 15:44:08.351+00	2025-12-18 15:44:08.351+00
4	Pharmacy User	farmacia@onkos.pe	password123	PHARMACY	2025-12-18 15:44:08.358+00	2025-12-18 15:44:08.358+00
5	Nurse Chemo	enfermeria.quimio@onkos.pe	password123	NURSE_CHEMO	2025-12-18 15:44:08.365+00	2025-12-18 15:44:08.365+00
6	Nurse Procedure	enfermeria.proc@onkos.pe	password123	NURSE_PROCEDURE	2025-12-18 15:44:08.369+00	2025-12-18 15:44:08.369+00
7	Nurse Ultrasound	enfermeria.eco@onkos.pe	password123	NURSE_ULTRASOUND	2025-12-18 15:44:08.375+00	2025-12-18 15:44:08.375+00
8	Nurse General	enfermeria.general@onkos.pe	password123	NURSE_GENERAL	2025-12-18 15:44:08.38+00	2025-12-18 15:44:08.38+00
9	Lab Onco	lab.onco@onkos.pe	password123	LAB_ONCO	2025-12-18 15:44:08.384+00	2025-12-18 15:44:08.384+00
10	Lab General	lab.general@onkos.pe	password123	LAB_GENERAL	2025-12-18 15:44:08.388+00	2025-12-18 15:44:08.388+00
11	Commercial User	comercial@onkos.pe	password123	COMMERCIAL	2025-12-18 15:44:08.392+00	2025-12-18 15:44:08.392+00
12	Doctor User	doctor@onkos.pe	password123	DOCTOR	2025-12-18 15:44:08.396+00	2025-12-18 15:44:08.396+00
\.


--
-- Data for Name: waiting_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waiting_room (id, "patientId", "appointmentId", "checkInTime", "estimatedWaitTime", priority, status, notes, "createdAt", "updatedAt") FROM stdin;
10	46	42	2025-12-19 19:52:29.369+00	\N	NORMAL	LLAMADO	\N	2025-12-19 19:52:29.369+00	2025-12-19 21:49:10.484+00
9	44	41	2025-12-19 19:47:20.885+00	\N	NORMAL	LLAMADO	\N	2025-12-19 19:47:20.885+00	2025-12-19 21:49:23.694+00
8	43	40	2025-12-19 19:43:27.5+00	\N	NORMAL	LLAMADO	xxx	2025-12-19 19:43:27.501+00	2025-12-19 21:49:29.363+00
7	45	32	2025-12-19 19:15:27.484+00	\N	NORMAL	LLAMADO	\N	2025-12-19 19:15:27.484+00	2025-12-19 21:49:32.471+00
6	44	39	2025-12-19 19:12:55.627+00	\N	NORMAL	ATENDIDO	Chequeo 	2025-12-19 19:12:55.627+00	2025-12-19 21:49:41.608+00
5	43	31	2025-12-19 19:10:15.342+00	\N	NORMAL	LLAMADO	\N	2025-12-19 19:10:15.342+00	2025-12-19 21:49:44.994+00
4	43	33	2025-12-19 19:05:31.754+00	\N	NORMAL	LLAMADO	\N	2025-12-19 19:05:31.754+00	2025-12-19 21:49:47.38+00
3	1	34	2025-12-18 21:00:27.194+00	\N	NORMAL	LLAMADO	\N	2025-12-18 21:00:27.196+00	2025-12-19 21:49:49.15+00
11	47	43	2025-12-19 21:58:37.609+00	\N	NORMAL	LLAMADO	\N	2025-12-19 21:58:37.609+00	2025-12-19 22:00:28.708+00
12	46	44	2025-12-19 22:02:33.061+00	\N	NORMAL	LLAMADO	weqweqw	2025-12-19 22:02:33.061+00	2025-12-19 22:02:46.843+00
13	46	45	2025-12-19 22:57:10.949+00	\N	NORMAL	LLAMADO	\N	2025-12-19 22:57:10.949+00	2025-12-19 23:00:06.382+00
14	47	46	2025-12-19 23:10:28.617+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:10:28.618+00	2025-12-19 23:10:35.76+00
15	46	47	2025-12-19 23:14:11.087+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:14:11.087+00	2025-12-19 23:14:20.877+00
16	45	48	2025-12-19 23:27:26.432+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:27:26.432+00	2025-12-19 23:28:40.558+00
18	47	50	2025-12-19 23:28:17.462+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:28:17.462+00	2025-12-19 23:38:39.571+00
17	44	49	2025-12-19 23:27:52.458+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:27:52.458+00	2025-12-19 23:41:10.95+00
19	46	51	2025-12-19 23:42:20.818+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:42:20.819+00	2025-12-19 23:42:40.643+00
20	47	52	2025-12-19 23:43:35.959+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:43:35.959+00	2025-12-19 23:43:40.935+00
21	46	53	2025-12-19 23:46:40.995+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:46:40.996+00	2025-12-19 23:46:43.666+00
22	43	40	2025-12-19 23:47:10.024+00	\N	NORMAL	LLAMADO	\N	2025-12-19 23:47:10.024+00	2025-12-19 23:47:50.748+00
23	43	55	2025-12-22 18:31:46.103+00	\N	NORMAL	LLAMADO	\N	2025-12-22 18:31:46.104+00	2025-12-22 18:32:10.047+00
24	45	56	2025-12-22 18:35:42.438+00	\N	NORMAL	LLAMADO	\N	2025-12-22 18:35:42.439+00	2025-12-22 18:35:52.207+00
26	48	57	2025-12-22 18:46:29.955+00	\N	NORMAL	LLAMADO	\N	2025-12-22 18:46:29.955+00	2025-12-22 18:46:49.351+00
25	48	58	2025-12-22 18:46:09.929+00	\N	NORMAL	LLAMADO	\N	2025-12-22 18:46:09.929+00	2025-12-22 18:46:56.521+00
27	43	59	2025-12-22 18:59:34.8+00	\N	NORMAL	LLAMADO	\N	2025-12-22 18:59:34.8+00	2025-12-22 18:59:42.355+00
28	48	61	2025-12-22 21:08:08.347+00	\N	NORMAL	LLAMADO	\N	2025-12-22 21:08:08.348+00	2025-12-22 21:12:00.32+00
30	43	62	2025-12-22 21:23:21.461+00	\N	NORMAL	LLAMADO	\N	2025-12-22 21:23:21.461+00	2025-12-22 21:40:48.822+00
29	49	60	2025-12-22 21:08:40.658+00	\N	NORMAL	LLAMADO	\N	2025-12-22 21:08:40.659+00	2025-12-22 21:41:04.554+00
31	43	63	2025-12-22 21:43:56.685+00	\N	NORMAL	LLAMADO	\N	2025-12-22 21:43:56.685+00	2025-12-22 21:46:06.238+00
32	43	64	2025-12-22 21:58:38.276+00	\N	NORMAL	LLAMADO	\N	2025-12-22 21:58:38.276+00	2025-12-22 21:58:44.939+00
33	43	65	2025-12-22 22:00:21.896+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:00:21.896+00	2025-12-22 22:00:27.768+00
34	48	66	2025-12-22 22:04:51.947+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:04:51.947+00	2025-12-22 22:05:22.754+00
35	50	67	2025-12-22 22:05:08.169+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:05:08.169+00	2025-12-22 22:05:30.036+00
36	43	68	2025-12-22 22:10:29.016+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:10:29.017+00	2025-12-22 22:10:41.603+00
38	45	71	2025-12-22 22:14:16.013+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:14:16.013+00	2025-12-22 22:16:56.023+00
37	48	70	2025-12-22 22:13:59.958+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:13:59.958+00	2025-12-22 22:17:07.104+00
39	43	69	2025-12-22 22:14:33.932+00	\N	NORMAL	LLAMADO	\N	2025-12-22 22:14:33.932+00	2025-12-22 22:17:09.648+00
40	43	72	2025-12-23 11:29:23.886+00	\N	NORMAL	LLAMADO	\N	2025-12-23 11:29:23.887+00	2025-12-23 11:29:29.478+00
41	45	73	2025-12-23 11:42:29.905+00	\N	NORMAL	LLAMADO	\N	2025-12-23 11:42:29.905+00	2025-12-23 11:42:48.71+00
42	48	74	2025-12-23 11:43:52.072+00	\N	NORMAL	LLAMADO	\N	2025-12-23 11:43:52.072+00	2025-12-23 11:44:05.129+00
43	45	77	2025-12-23 11:54:23.594+00	\N	NORMAL	LLAMADO	\N	2025-12-23 11:54:23.594+00	2025-12-23 11:55:35.924+00
44	48	76	2025-12-23 11:55:06.756+00	\N	NORMAL	LLAMADO	\N	2025-12-23 11:55:06.757+00	2025-12-23 11:55:47.081+00
45	43	75	2025-12-23 11:55:26.295+00	\N	NORMAL	LLAMADO	\N	2025-12-23 11:55:26.295+00	2025-12-23 11:56:05.714+00
46	51	79	2025-12-23 12:03:19.993+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:03:19.993+00	2025-12-23 12:04:14.426+00
47	45	78	2025-12-23 12:06:00.931+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:06:00.931+00	2025-12-23 12:06:09.064+00
48	52	80	2025-12-23 12:06:21.558+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:06:21.558+00	2025-12-23 12:07:37.282+00
49	48	78	2025-12-23 12:11:40.605+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:11:40.605+00	2025-12-23 12:12:06.297+00
51	45	83	2025-12-23 12:14:13.172+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:14:13.172+00	2025-12-23 12:14:52.001+00
52	43	82	2025-12-23 12:14:30.33+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:14:30.33+00	2025-12-23 12:18:29.752+00
53	53	84	2025-12-23 12:17:32.63+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:17:32.63+00	2025-12-23 12:19:51.695+00
50	48	81	2025-12-23 12:14:00.299+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:14:00.299+00	2025-12-23 12:24:41.498+00
58	58	89	2025-12-23 12:30:16.655+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.655+00	2025-12-23 12:32:02.775+00
55	55	86	2025-12-23 12:30:16.623+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.623+00	2025-12-23 12:32:10.996+00
54	54	85	2025-12-23 12:30:16.608+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.609+00	2025-12-23 12:32:17.1+00
56	56	87	2025-12-23 12:30:16.634+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.634+00	2025-12-23 12:32:42.397+00
59	59	90	2025-12-23 12:30:16.663+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.663+00	2025-12-23 12:32:51.514+00
60	60	91	2025-12-23 12:30:16.671+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.671+00	2025-12-23 12:32:59.621+00
63	63	94	2025-12-23 12:30:16.697+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.697+00	2025-12-23 12:35:38.634+00
57	57	88	2025-12-23 12:30:16.646+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.646+00	2025-12-23 12:36:00.351+00
61	61	92	2025-12-23 12:30:16.679+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.679+00	2025-12-23 12:36:04.949+00
62	62	93	2025-12-23 12:30:16.688+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:30:16.688+00	2025-12-23 12:36:09.628+00
64	64	95	2025-12-23 12:37:59.288+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.289+00	2025-12-23 12:38:28.228+00
74	74	105	2025-12-23 12:37:59.426+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.426+00	2025-12-23 12:38:40.416+00
65	65	96	2025-12-23 12:37:59.307+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.307+00	2025-12-23 12:39:00.335+00
75	75	106	2025-12-23 12:37:59.436+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.437+00	2025-12-23 12:39:09.074+00
76	76	107	2025-12-23 12:37:59.448+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.448+00	2025-12-23 12:39:41.111+00
66	66	97	2025-12-23 12:37:59.323+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.324+00	2025-12-23 12:39:46.305+00
67	67	98	2025-12-23 12:37:59.337+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.337+00	2025-12-23 12:40:01.739+00
77	77	108	2025-12-23 12:37:59.458+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.458+00	2025-12-23 12:40:05.909+00
68	68	99	2025-12-23 12:37:59.349+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.349+00	2025-12-23 12:40:34.331+00
69	69	100	2025-12-23 12:37:59.361+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.361+00	2025-12-23 12:41:02.127+00
70	70	101	2025-12-23 12:37:59.373+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.373+00	2025-12-23 12:41:45.712+00
71	71	102	2025-12-23 12:37:59.393+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.393+00	2025-12-23 14:14:35.019+00
72	72	103	2025-12-23 12:37:59.402+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.403+00	2025-12-23 14:14:39.075+00
73	73	104	2025-12-23 12:37:59.414+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.414+00	2025-12-23 14:19:18.617+00
84	84	115	2025-12-23 12:37:59.532+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.532+00	2025-12-23 12:38:34.652+00
85	85	116	2025-12-23 12:37:59.545+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.545+00	2025-12-23 12:39:13.739+00
92	92	123	2025-12-23 12:37:59.626+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.626+00	2025-12-23 12:39:25.181+00
86	86	117	2025-12-23 12:37:59.558+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.558+00	2025-12-23 12:39:36.34+00
87	87	118	2025-12-23 12:37:59.57+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.57+00	2025-12-23 12:40:07.776+00
88	88	119	2025-12-23 12:37:59.583+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.583+00	2025-12-23 12:40:26.504+00
78	78	109	2025-12-23 12:37:59.467+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.467+00	2025-12-23 12:40:28.843+00
89	89	120	2025-12-23 12:37:59.593+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.593+00	2025-12-23 12:40:52.956+00
79	79	110	2025-12-23 12:37:59.478+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.478+00	2025-12-23 12:40:57.401+00
90	90	121	2025-12-23 12:37:59.603+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.603+00	2025-12-23 12:41:37.199+00
80	80	111	2025-12-23 12:37:59.487+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.487+00	2025-12-23 12:41:41.595+00
81	81	112	2025-12-23 12:37:59.498+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.498+00	2025-12-23 14:21:23.047+00
82	82	113	2025-12-23 12:37:59.51+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.511+00	2025-12-23 14:21:32.643+00
91	91	122	2025-12-23 12:37:59.614+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.614+00	2025-12-23 14:21:40.308+00
93	93	124	2025-12-23 12:37:59.635+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.635+00	2025-12-23 14:22:13.513+00
83	83	114	2025-12-23 12:37:59.52+00	\N	NORMAL	LLAMADO	\N	2025-12-23 12:37:59.52+00	2025-12-23 14:22:20.15+00
94	94	125	2025-12-23 14:23:33.768+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.769+00	2025-12-23 14:24:57.621+00
104	104	135	2025-12-23 14:23:33.953+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.953+00	2025-12-23 14:25:08.73+00
114	114	145	2025-12-23 14:23:34.099+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.1+00	2025-12-23 14:25:21.837+00
95	95	126	2025-12-23 14:23:33.794+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.794+00	2025-12-23 14:29:03.076+00
115	115	146	2025-12-23 14:23:34.114+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.115+00	2025-12-23 14:29:11.17+00
105	105	136	2025-12-23 14:23:33.967+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.967+00	2025-12-23 14:29:17.216+00
116	116	147	2025-12-23 14:23:34.131+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.132+00	2025-12-23 14:29:49.985+00
117	117	148	2025-12-23 14:23:34.146+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.146+00	2025-12-23 14:32:17.663+00
96	96	127	2025-12-23 14:23:33.812+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.813+00	2025-12-23 14:32:59.114+00
118	118	149	2025-12-23 14:23:34.162+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.163+00	2025-12-23 14:33:24.276+00
106	106	137	2025-12-23 14:23:33.981+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.981+00	2025-12-23 14:33:44.645+00
119	119	150	2025-12-23 14:23:34.175+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.175+00	2025-12-23 14:34:19.093+00
107	107	138	2025-12-23 14:23:33.997+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.997+00	2025-12-23 14:34:45.553+00
97	97	128	2025-12-23 14:23:33.833+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.833+00	2025-12-23 14:34:48.473+00
98	98	129	2025-12-23 14:23:33.847+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.847+00	2025-12-23 14:35:48.822+00
108	108	139	2025-12-23 14:23:34.011+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.011+00	2025-12-23 14:35:53.108+00
120	120	151	2025-12-23 14:23:34.191+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.191+00	2025-12-23 14:35:57.223+00
121	121	152	2025-12-23 14:23:34.204+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.204+00	2025-12-23 14:36:36.325+00
109	109	140	2025-12-23 14:23:34.025+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.025+00	2025-12-23 14:36:42.119+00
99	99	130	2025-12-23 14:23:33.86+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.861+00	2025-12-23 14:36:47.736+00
100	100	131	2025-12-23 14:23:33.876+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.876+00	2025-12-23 14:38:45.175+00
110	110	141	2025-12-23 14:23:34.038+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.038+00	2025-12-23 14:38:46.542+00
122	122	153	2025-12-23 14:23:34.217+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.217+00	2025-12-23 14:38:51.43+00
123	123	154	2025-12-23 14:23:34.231+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.232+00	2025-12-23 14:42:45.4+00
111	111	142	2025-12-23 14:23:34.053+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.053+00	2025-12-23 14:42:53.955+00
101	101	132	2025-12-23 14:23:33.89+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.89+00	2025-12-23 14:43:01.26+00
112	112	143	2025-12-23 14:23:34.067+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.068+00	2025-12-23 14:43:21.986+00
102	102	133	2025-12-23 14:23:33.928+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.928+00	2025-12-23 14:43:26.964+00
113	113	144	2025-12-23 14:23:34.081+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:34.081+00	2025-12-23 14:43:38.978+00
103	103	134	2025-12-23 14:23:33.94+00	\N	NORMAL	LLAMADO	\N	2025-12-23 14:23:33.94+00	2025-12-23 14:43:42.941+00
130	130	161	2025-12-23 15:06:39.629+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.63+00	2025-12-23 20:55:39.635+00
124	124	155	2025-12-23 15:06:39.537+00	\N	NORMAL	ATENDIDO	\N	2025-12-23 15:06:39.538+00	2025-12-23 15:07:11.709+00
133	133	164	2025-12-23 15:06:39.661+00	\N	NORMAL	ATENDIDO	\N	2025-12-23 15:06:39.661+00	2025-12-23 15:13:41.914+00
125	125	156	2025-12-23 15:06:39.557+00	\N	NORMAL	ATENDIDO	\N	2025-12-23 15:06:39.558+00	2025-12-23 15:07:54.773+00
127	127	158	2025-12-23 15:06:39.592+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.592+00	2025-12-23 15:13:46.884+00
126	126	157	2025-12-23 15:06:39.576+00	\N	NORMAL	ATENDIDO	\N	2025-12-23 15:06:39.576+00	2025-12-23 15:13:28.524+00
144	144	175	2025-12-23 15:06:39.793+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.793+00	2025-12-23 20:51:35.397+00
134	134	165	2025-12-23 15:06:39.674+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.674+00	2025-12-23 20:52:18.212+00
128	128	159	2025-12-23 15:06:39.604+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.605+00	2025-12-23 20:52:27.76+00
135	135	166	2025-12-23 15:06:39.686+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.686+00	2025-12-23 20:53:57.766+00
129	129	160	2025-12-23 15:06:39.617+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.617+00	2025-12-23 20:54:51.338+00
145	145	176	2025-12-23 15:06:39.805+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.806+00	2025-12-23 20:54:59.337+00
136	136	167	2025-12-23 15:06:39.696+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.696+00	2025-12-23 20:55:09.109+00
137	137	168	2025-12-23 15:06:39.707+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.707+00	2025-12-23 20:55:50.53+00
146	146	177	2025-12-23 15:06:39.818+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.818+00	2025-12-23 20:55:58.722+00
131	131	162	2025-12-23 15:06:39.64+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.641+00	2025-12-23 20:56:09.583+00
132	132	163	2025-12-23 15:06:39.651+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.652+00	2025-12-23 20:56:18.482+00
141	141	172	2025-12-23 15:06:39.755+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.755+00	2025-12-29 15:50:47.503+00
138	138	169	2025-12-23 15:06:39.718+00	\N	NORMAL	ATENDIDO	\N	2025-12-23 15:06:39.718+00	2025-12-23 20:58:17.251+00
139	139	170	2025-12-23 15:06:39.729+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.729+00	2025-12-23 20:58:27.149+00
140	140	171	2025-12-23 15:06:39.742+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.742+00	2025-12-29 15:50:41.474+00
142	142	173	2025-12-23 15:06:39.769+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.769+00	2025-12-29 15:50:49.654+00
143	143	174	2025-12-23 15:06:39.782+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.782+00	2025-12-29 15:50:51.932+00
147	147	178	2025-12-23 15:06:39.831+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.831+00	2025-12-29 15:51:01.995+00
148	148	179	2025-12-23 15:06:39.847+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.848+00	2025-12-29 15:51:03.792+00
149	149	180	2025-12-23 15:06:39.859+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.859+00	2025-12-29 15:51:05.577+00
150	150	181	2025-12-23 15:06:39.873+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.873+00	2025-12-29 15:51:15.294+00
151	151	182	2025-12-23 15:06:39.886+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.886+00	2025-12-29 15:51:17.798+00
152	152	183	2025-12-23 15:06:39.898+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.898+00	2025-12-29 15:51:19.486+00
153	153	184	2025-12-23 15:06:39.909+00	\N	NORMAL	LLAMADO	\N	2025-12-23 15:06:39.91+00	2025-12-29 15:51:55.697+00
155	43	186	2025-12-29 16:48:52.061+00	\N	NORMAL	ATENDIDO	Imagen de Torax	2025-12-29 16:48:52.061+00	2025-12-29 16:53:23.357+00
154	43	185	2025-12-29 16:40:23.379+00	\N	NORMAL	ATENDIDO	Revision de Examenes	2025-12-29 16:40:23.379+00	2025-12-29 16:41:34.876+00
156	43	187	2025-12-29 16:52:14.817+00	\N	NORMAL	ATENDIDO	23123312	2025-12-29 16:52:14.817+00	2025-12-29 16:53:24.593+00
158	154	189	2025-12-29 12:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.445+00	2025-12-29 21:22:26.448+00
163	159	194	2025-12-29 14:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.598+00	2025-12-29 17:08:42.589+00
166	162	197	2025-12-29 14:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.645+00	2025-12-29 17:10:40.107+00
157	43	188	2025-12-29 16:54:52.522+00	\N	NORMAL	ATENDIDO	\N	2025-12-29 16:54:52.526+00	2025-12-29 22:32:59.938+00
159	155	190	2025-12-29 13:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.521+00	2025-12-29 17:56:18.24+00
162	158	193	2025-12-29 13:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.581+00	2025-12-29 18:00:22.964+00
165	161	196	2025-12-29 14:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.627+00	2025-12-29 18:00:39.031+00
161	157	192	2025-12-29 13:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.562+00	2025-12-29 21:24:03.895+00
164	160	195	2025-12-29 14:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.613+00	2025-12-29 21:24:11.503+00
160	156	191	2025-12-29 13:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.544+00	2025-12-29 17:08:13.348+00
189	43	220	2025-12-29 22:30:27.865+00	\N	NORMAL	LLAMADO	\N	2025-12-29 22:30:27.865+00	2025-12-29 22:31:11.91+00
169	165	200	2025-12-29 15:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.69+00	2025-12-29 17:27:15.977+00
172	168	203	2025-12-29 16:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.735+00	2025-12-29 17:27:27.858+00
190	43	221	2025-12-29 22:32:33.251+00	\N	NORMAL	LLAMADO	3423	2025-12-29 22:32:33.251+00	2025-12-29 22:32:47.319+00
175	171	206	2025-12-29 17:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.783+00	2025-12-29 17:29:25.783+00
178	174	209	2025-12-29 17:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.853+00	2025-12-29 17:32:07.273+00
181	177	212	2025-12-29 18:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.9+00	2025-12-29 17:42:13.375+00
184	180	215	2025-12-29 19:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.944+00	2025-12-29 17:46:02.6+00
187	183	218	2025-12-29 20:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:52.091+00	2025-12-29 17:47:32.609+00
177	173	208	2025-12-29 17:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.825+00	2025-12-29 19:24:13.933+00
188	45	219	2025-12-29 20:48:21.094+00	\N	NORMAL	ATENDIDO	Revision de examenes	2025-12-29 20:48:21.094+00	2025-12-29 20:49:33.799+00
168	164	199	2025-12-29 15:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.676+00	2025-12-29 20:54:02.253+00
171	167	202	2025-12-29 16:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.721+00	2025-12-29 20:59:50.489+00
174	170	205	2025-12-29 16:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.767+00	2025-12-29 21:03:39.213+00
180	176	211	2025-12-29 18:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.884+00	2025-12-29 21:03:49.97+00
183	179	214	2025-12-29 19:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.928+00	2025-12-29 21:05:55.916+00
186	182	217	2025-12-29 19:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:52.078+00	2025-12-29 21:14:38.011+00
167	163	198	2025-12-29 15:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.659+00	2025-12-29 21:24:19.558+00
170	166	201	2025-12-29 15:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.707+00	2025-12-29 21:24:25.946+00
173	169	204	2025-12-29 16:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.753+00	2025-12-29 22:04:28.613+00
176	172	207	2025-12-29 17:20:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.799+00	2025-12-29 22:04:38.124+00
179	175	210	2025-12-29 18:05:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.87+00	2025-12-29 22:04:43.397+00
182	178	213	2025-12-29 18:50:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:51.915+00	2025-12-29 22:04:46.302+00
185	181	216	2025-12-29 19:35:00+00	\N	NORMAL	ATENDIDO	Auto-seeded test data	2025-12-29 17:02:52.047+00	2025-12-29 22:04:48.878+00
\.


--
-- Name: appointment_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_history_id_seq', 1, false);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_id_seq', 221, true);


--
-- Name: chemo_chairs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chemo_chairs_id_seq', 9, true);


--
-- Name: doctor_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_schedules_id_seq', 77, true);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 14, true);


--
-- Name: medical_centers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medical_centers_id_seq', 1, true);


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patients_id_seq', 183, true);


--
-- Name: queues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.queues_id_seq', 204, true);


--
-- Name: recovery_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recovery_rooms_id_seq', 4, true);


--
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resources_id_seq', 22, true);


--
-- Name: service_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_types_id_seq', 18, true);


--
-- Name: specialties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialties_id_seq', 11, true);


--
-- Name: staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_id_seq', 12, true);


--
-- Name: waiting_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.waiting_room_id_seq', 190, true);


--
-- Name: appointment_history appointment_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_history
    ADD CONSTRAINT appointment_history_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key1" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key10" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key2" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key3" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key4" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key5" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key6" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key7" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key8" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_chairLabel_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_chairLabel_key9" UNIQUE ("chairLabel");


--
-- Name: chemo_chairs chemo_chairs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT chemo_chairs_pkey PRIMARY KEY (id);


--
-- Name: doctor_schedules doctor_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_schedules
    ADD CONSTRAINT doctor_schedules_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key UNIQUE (dni);


--
-- Name: doctors doctors_dni_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key1 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key10 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key11 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key12 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key13 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key14 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key2 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key3 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key4 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key5 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key6 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key7 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key8 UNIQUE (dni);


--
-- Name: doctors doctors_dni_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_dni_key9 UNIQUE (dni);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: medical_centers medical_centers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_centers
    ADD CONSTRAINT medical_centers_pkey PRIMARY KEY (id);


--
-- Name: patients patients_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key UNIQUE (dni);


--
-- Name: patients patients_dni_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key1 UNIQUE (dni);


--
-- Name: patients patients_dni_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key10 UNIQUE (dni);


--
-- Name: patients patients_dni_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key11 UNIQUE (dni);


--
-- Name: patients patients_dni_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key12 UNIQUE (dni);


--
-- Name: patients patients_dni_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key13 UNIQUE (dni);


--
-- Name: patients patients_dni_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key14 UNIQUE (dni);


--
-- Name: patients patients_dni_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key2 UNIQUE (dni);


--
-- Name: patients patients_dni_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key3 UNIQUE (dni);


--
-- Name: patients patients_dni_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key4 UNIQUE (dni);


--
-- Name: patients patients_dni_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key5 UNIQUE (dni);


--
-- Name: patients patients_dni_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key6 UNIQUE (dni);


--
-- Name: patients patients_dni_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key7 UNIQUE (dni);


--
-- Name: patients patients_dni_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key8 UNIQUE (dni);


--
-- Name: patients patients_dni_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_dni_key9 UNIQUE (dni);


--
-- Name: patients patients_medical_record_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_medical_record_number_key UNIQUE (medical_record_number);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: queues queues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queues
    ADD CONSTRAINT queues_pkey PRIMARY KEY (id);


--
-- Name: recovery_rooms recovery_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT recovery_rooms_pkey PRIMARY KEY (id);


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key1" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key10" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key2" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key3" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key4" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key5" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key6" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key7" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key8" UNIQUE ("roomLabel");


--
-- Name: recovery_rooms recovery_rooms_roomLabel_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_roomLabel_key9" UNIQUE ("roomLabel");


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: service_types service_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key UNIQUE (name);


--
-- Name: service_types service_types_name_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key1 UNIQUE (name);


--
-- Name: service_types service_types_name_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key10 UNIQUE (name);


--
-- Name: service_types service_types_name_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key11 UNIQUE (name);


--
-- Name: service_types service_types_name_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key12 UNIQUE (name);


--
-- Name: service_types service_types_name_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key2 UNIQUE (name);


--
-- Name: service_types service_types_name_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key3 UNIQUE (name);


--
-- Name: service_types service_types_name_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key4 UNIQUE (name);


--
-- Name: service_types service_types_name_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key5 UNIQUE (name);


--
-- Name: service_types service_types_name_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key6 UNIQUE (name);


--
-- Name: service_types service_types_name_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key7 UNIQUE (name);


--
-- Name: service_types service_types_name_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key8 UNIQUE (name);


--
-- Name: service_types service_types_name_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_name_key9 UNIQUE (name);


--
-- Name: service_types service_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_pkey PRIMARY KEY (id);


--
-- Name: specialties specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialties
    ADD CONSTRAINT specialties_pkey PRIMARY KEY (id);


--
-- Name: staff staff_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key UNIQUE (email);


--
-- Name: staff staff_email_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key1 UNIQUE (email);


--
-- Name: staff staff_email_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key10 UNIQUE (email);


--
-- Name: staff staff_email_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key2 UNIQUE (email);


--
-- Name: staff staff_email_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key3 UNIQUE (email);


--
-- Name: staff staff_email_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key4 UNIQUE (email);


--
-- Name: staff staff_email_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key5 UNIQUE (email);


--
-- Name: staff staff_email_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key6 UNIQUE (email);


--
-- Name: staff staff_email_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key7 UNIQUE (email);


--
-- Name: staff staff_email_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key8 UNIQUE (email);


--
-- Name: staff staff_email_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key9 UNIQUE (email);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (id);


--
-- Name: waiting_room waiting_room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_room
    ADD CONSTRAINT waiting_room_pkey PRIMARY KEY (id);


--
-- Name: idx_patients_medical_record_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_patients_medical_record_number ON public.patients USING btree (medical_record_number);


--
-- Name: appointments appointments_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: appointments appointments_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: appointments appointments_resourceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES public.resources(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: appointments appointments_serviceTypeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_serviceTypeId_fkey" FOREIGN KEY ("serviceTypeId") REFERENCES public.service_types(id) ON UPDATE CASCADE;


--
-- Name: chemo_chairs chemo_chairs_occupiedByPatientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chemo_chairs
    ADD CONSTRAINT "chemo_chairs_occupiedByPatientId_fkey" FOREIGN KEY ("occupiedByPatientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: doctor_schedules doctor_schedules_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_schedules
    ADD CONSTRAINT doctor_schedules_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doctors doctors_medical_center_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_medical_center_id_fkey FOREIGN KEY (medical_center_id) REFERENCES public.medical_centers(id) ON UPDATE CASCADE;


--
-- Name: doctors doctors_specialty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_specialty_id_fkey FOREIGN KEY (specialty_id) REFERENCES public.specialties(id) ON UPDATE CASCADE;


--
-- Name: queues queues_appointmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queues
    ADD CONSTRAINT "queues_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES public.appointments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recovery_rooms recovery_rooms_occupiedByPatientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recovery_rooms
    ADD CONSTRAINT "recovery_rooms_occupiedByPatientId_fkey" FOREIGN KEY ("occupiedByPatientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: resources resources_currentPatientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT "resources_currentPatientId_fkey" FOREIGN KEY ("currentPatientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: resources resources_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT "resources_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: waiting_room waiting_room_appointmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_room
    ADD CONSTRAINT "waiting_room_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES public.appointments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: waiting_room waiting_room_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_room
    ADD CONSTRAINT "waiting_room_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 7zFGx6hPtJ1MjPcfAjUzkOQBFxQxDDfBPi3Qeln9WLluPFcDMI9dfiWht6QOqfM

