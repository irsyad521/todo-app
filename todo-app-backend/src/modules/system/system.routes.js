import express from 'express';
import { updateMode, getMode } from './system.controller.js';
import { validate, schemas } from '../../middleware/validation.middleware.js';

const router = express.Router();

router.get('/mode', getMode);
router.post('/mode', validate(schemas.system.mode), updateMode);

export default router;