import { Sequelize } from 'sequelize-typescript';
import path from 'path';
import dotenv from 'dotenv';

dotenv.config();

const databaseUrl = process.env.DATABASE_URL || 'sqlite://./database.sqlite';

import { Patient } from '../models/patient.model';
import { Appointment } from '../models/appointment.model';
import { Staff } from '../models/staff.model';
import { Queue } from '../models/queue.model';
import { ChemoChair } from '../models/chemoChair.model';
import { RecoveryRoom } from '../models/recoveryRoom.model';
import { Doctor } from '../models/doctor.model';
import { Resource } from '../models/resource.model';
import { WaitingRoom } from '../models/waiting-room.model';

import { Specialty } from '../models/specialty.model';
import { MedicalCenter } from '../models/medical-center.model';
import { ServiceType } from '../models/service-type.model';
import { DoctorSchedule } from '../models/doctor-schedule.model';
import { PhysicalExam } from '../models/physical-exam.model';
import { Allergy } from '../models/allergy.model';
import { Quote } from '../models/quote.model';
import { Recipe } from '../models/recipe.model';
import { ProcedureOrder } from '../models/procedure-order.model';

// Determine database type from URL
const isPostgres = databaseUrl.startsWith('postgres://') || databaseUrl.startsWith('postgresql://');

export const sequelize = isPostgres
    ? new Sequelize(databaseUrl, {
        dialect: 'postgres',
        models: [Patient, Appointment, Staff, Queue, ChemoChair, RecoveryRoom, Doctor, Resource, WaitingRoom, Specialty, MedicalCenter, ServiceType,
            DoctorSchedule, PhysicalExam, Allergy, Quote, Recipe, ProcedureOrder],
        logging: console.log,
        pool: {
            max: 5,
            min: 0,
            acquire: 30000,
            idle: 10000,
        },
    })
    : new Sequelize({
        dialect: 'sqlite',
        storage: databaseUrl.replace('sqlite://', ''),
        models: [Patient, Appointment, Staff, Queue, ChemoChair, RecoveryRoom, Doctor, Resource, WaitingRoom, Specialty, MedicalCenter, ServiceType, DoctorSchedule, PhysicalExam, Allergy, Quote, Recipe, ProcedureOrder],
        logging: false,
    });
