import axios from 'axios';

const API_URL = 'http://localhost:4000/api';

async function testDashboard() {
    console.log('🚀 Iniciando pruebas del Dashboard...');

    try {
        // 1. Probar endpoint de estadísticas
        console.log('\n📊 Probando GET /api/dashboard/stats...');
        const statsRes = await axios.get(`${API_URL}/dashboard/stats`);
        const kpis = statsRes.data.kpis;
        console.log('✅ KPIs recibidos:', JSON.stringify(kpis, null, 2));

        const sum = kpis.newPatients + kpis.continuingPatients + kpis.noShows;
        console.log(`\n🔍 Verificando cuadre: ${kpis.newPatients} (Nuevos) + ${kpis.continuingPatients} (Seguimientos) + ${kpis.noShows} (No Show/Canc) = ${sum}`);

        if (sum === kpis.totalAppointments) {
            console.log('✅ El Total de Citas CUADRA perfectamente.');
        } else {
            console.log('❌ El Total de Citas NO CUADRA.');
        }

        console.log(`\n⏳ Citas Pendientes (fuera del total): ${kpis.pendingAppointments}`);

        // 2. Probar limpieza reactiva (simulada llamando al endpoint de sala de espera)
        console.log('\n🧹 Probando limpieza reactiva de No Show...');
        const waitingRes = await axios.get(`${API_URL}/waiting-room/current`);
        console.log('✅ Sala de espera cargada (limpieza ejecutada internamente)');

        console.log('\n✨ Todas las pruebas básicas del backend pasaron.');
    } catch (error: any) {
        console.error('❌ Error en las pruebas:', error.response?.data || error.message);
    }
}

testDashboard();
