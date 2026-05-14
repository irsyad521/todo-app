import express from 'express';
import * as controller from '../controllers/user.controller.js';
import { authenticate } from '../middleware/auth.middleware.js';
import { validate, schemas } from '../middleware/validation.middleware.js';

const router = express.Router();

router.use(authenticate);

router.get(
  '/',
  validate({ query: schemas.user.query }),
  controller.getUsers
);

router.get(
  '/:id',
  validate(schemas.user.idParam),
  controller.getUser
);

router.put(
  '/:id',
  validate(schemas.user.update),
  controller.updateUser
);

router.delete(
  '/:id',
  validate(schemas.user.idParam),
  controller.deleteUser
);

export default router;