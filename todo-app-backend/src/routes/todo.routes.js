import express from 'express';
import * as controller from '../controllers/todo.controller.js';
import { authenticate } from '../middleware/auth.middleware.js';
import { validate, schemas } from '../middleware/validation.middleware.js';

const router = express.Router();

router.use(authenticate);

router.get(
  '/',
  validate({ query: schemas.todo.query }),
  controller.getTodos
);

router.post(
  '/',
  validate(schemas.todo.create),
  controller.createTodo
);

router.get(
  '/:id',
  validate(schemas.todo.idParam),
  controller.getTodoById
);

router.put(
  '/:id',
  validate(schemas.todo.update),
  controller.updateTodo
);

router.delete(
  '/:id',
  validate(schemas.todo.idParam),
  controller.deleteTodo
);

export default router;