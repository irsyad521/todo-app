import * as service from '../services/todo.service.js';
import * as resp from '../utils/response.js';

export const createTodo = async (req, res, next) => {
  try {
    const data = await service.createTodo(req.body, req.user);
    return resp.success(res, data, 201);
  } catch (err) {
    next(err);
  }
};

export const getTodos = async (req, res, next) => {
  try {
    const data = await service.getTodos(req.query, req.user);
    return resp.success(res, data);
  } catch (err) {
    next(err);
  }
};

export const getTodoById = async (req, res, next) => {
  try {
    const data = await service.getTodoById(req.params.id, req.user);
    return resp.success(res, data);
  } catch (err) {
    next(err);
  }
};

export const updateTodo = async (req, res, next) => {
  try {
    const data = await service.updateTodo(req.params.id, req.body, req.user);
    return resp.success(res, data);
  } catch (err) {
    next(err);
  }
};

export const deleteTodo = async (req, res, next) => {
  try {
    await service.deleteTodo(req.params.id, req.user);
    return resp.success(res, null, 200, 'Todo deleted');
  } catch (err) {
    next(err);
  }
};