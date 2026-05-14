import express from 'express';
import authRoutes from './auth.routes.js';
import todoRoutes from './todo.routes.js';
import userRoutes from './user.routes.js';
import systemRoutes from '../modules/system/system.routes.js';

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/todos', todoRoutes);
router.use('/users', userRoutes);
router.use('/system', systemRoutes);

export default router;