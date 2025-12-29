import { sequelize } from './config/database';
import { ServiceType } from './models/service-type.model';

async function listServices() {
    try {
        await sequelize.authenticate();
        const services = await ServiceType.findAll();
        console.log('Services:', services.map(s => ({ id: s.id, name: s.name, code: s.code })));
    } catch (error) {
        console.error(error);
    } finally {
        await sequelize.close();
    }
}

listServices();
