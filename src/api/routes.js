import express from 'express';
import authRoutes from './auth.js';
import blogRoutes from './blog.js';
import skillsRoutes from './skills.js';
import jobsRoutes from './jobs.js';
import companiesRoutes from './companies.js';
import usersRoutes from './users.js';
import applicationsRoutes from './applications.js';
import adminRoutes from './admin.js';

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/blog', blogRoutes);
router.use('/skills', skillsRoutes);
router.use('/jobs', jobsRoutes);
router.use('/companies', companiesRoutes);
router.use('/users', usersRoutes);
router.use('/applications', applicationsRoutes);
router.use('/admin', adminRoutes);

export default router;
