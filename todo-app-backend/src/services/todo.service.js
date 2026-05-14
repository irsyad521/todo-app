import * as repo from '../repository/todo.repository.js';
import { unauthorized, notFound, forbidden, badRequest } from '../utils/httpError.js';
import { ERROR_CODES } from '../utils/errorCodes.js';
import { runtime } from '../config/runtime.js';

const mapTodo = (t, user) => {
  const base = {
    id: t.id,
    title: t.title,
    description: t.description ?? null,
    completed: Boolean(t.completed)
  };

  if (user.role === 'admin') {
    return {
      ...base,
      user: {
        id: t.user_id,
        username: t.username
      }
    };
  }

  return {
    ...base,
    is_owner: t.user_id === user.id
  };
};

export const getTodos = async (query = {}, user) => {
  if (!user) {
    throw unauthorized('Unauthorized', ERROR_CODES.UNAUTHORIZED);
  }

  const page = Math.max(1, Number(query.page) || 1);
  const limit = Math.min(100, Math.max(1, Number(query.limit) || 10));
  const offset = (page - 1) * limit;

  let todos;
  let total;

  if (user.role === 'admin') {
    [todos, total] = await Promise.all([
      repo.findTodosPaginated(offset, limit),
      repo.countTodos()
    ]);
  } else {
    [todos, total] = await Promise.all([
      repo.findTodosByUserPaginated(user.id, offset, limit),
      repo.countTodosByUser(user.id)
    ]);
  }

  return {
    data: todos.map(t => mapTodo(t, user)),
    meta: {
      page,
      limit,
      total,
      total_pages: Math.ceil(total / limit)
    }
  };
};

export const getTodoById = async (id, user) => {
  const todo = await repo.findByIdWithUser(id);

  if (!todo) {
    throw notFound('Not found', ERROR_CODES.NOT_FOUND);
  }

  if (runtime.appMode !== 'development') {
    if (user.role !== 'admin' && todo.user_id !== user.id) {
      throw forbidden('Forbidden', ERROR_CODES.FORBIDDEN);
    }
  }

  return mapTodo(todo, user);
};

export const createTodo = async (data, user) => {
  const todo = await repo.createTodo({
    ...data,
    user_id: user.id
  });

  return mapTodo(todo, user);
};

export const updateTodo = async (id, data, user) => {
  const existing = await repo.findByIdWithUser(id);

  if (!existing) {
    throw notFound('Not found', ERROR_CODES.NOT_FOUND);
  }

  if (user.role !== 'admin' && existing.user_id !== user.id) {
    throw forbidden('Forbidden', ERROR_CODES.FORBIDDEN);
  }

  const updated = await repo.updateById(id, data);

  if (!updated) {
    throw badRequest('No fields to update', ERROR_CODES.INVALID_INPUT);
  }

  return mapTodo(updated, user);
};

export const deleteTodo = async (id, user) => {
  const existing = await repo.findByIdWithUser(id);

  if (!existing) {
    throw notFound('Not found', ERROR_CODES.NOT_FOUND);
  }

  if (user.role !== 'admin' && existing.user_id !== user.id) {
    throw forbidden('Forbidden', ERROR_CODES.FORBIDDEN);
  }

  await repo.deleteById(id);

  return true;
};