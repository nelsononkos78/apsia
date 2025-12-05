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

export const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: databaseUrl.replace('sqlite://', ''),
    models: [Patient, Appointment, Staff, Queue, ChemoChair, RecoveryRoom, Doctor, Resource, WaitingRoom],
    logging: false,
});
