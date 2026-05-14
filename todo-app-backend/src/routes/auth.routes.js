import express from 'express';
import * as controller from '../controllers/auth.controller.js';
import { validate, schemas } from '../middleware/validation.middleware.js';
import { authenticate } from '../middleware/auth.middleware.js';

const router = express.Router();

router.post(
  '/register',
  validate(schemas.auth.register),
  controller.register
);

router.post(
  '/login',
  validate(schemas.auth.login),
  controller.login
);

router.get(
  '/me',
  authenticate,
  controller.me
);

export default router;