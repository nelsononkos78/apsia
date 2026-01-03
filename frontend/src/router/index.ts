import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: () => import('../views/PatientPortal.vue')
        },
        {
            path: '/book',
            name: 'book',
            component: () => import('../views/BookAppointment.vue')
        },
        {
            path: '/checkin',
            name: 'checkin',
            component: () => import('../views/Checkin.vue')
        },
        {
            path: '/tv',
            name: 'tv',
            component: () => import('../views/TVDisplay.vue')
        },
        {
            path: '/staff/login',
            name: 'staff-login',
            component: () => import('../views/CounterLogin.vue')
        },
        {
            path: '/admin',
            name: 'admin',
            component: () => import('../views/AdminDashboard.vue')
        },
        {
            path: '/monitoring',
            name: 'monitoring',
            component: () => import('../views/MonitoringDashboard.vue')
        },
        {
            path: '/internal-flow',
            name: 'internal-flow',
            component: () => import('../views/InternalFlowDashboard.vue')
        },
        {
            path: '/doctor/dashboard',
            name: 'doctor-dashboard',
            component: () => import('../views/DoctorDashboard.vue')
        },
        {
            path: '/triage',
            name: 'triage',
            component: () => import('../views/TriageDashboard.vue')
        }
    ]
})

export default router
