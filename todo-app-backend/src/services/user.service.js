import {
  findUsersPaginated,
  countUsers,
  findById,
  updateUser,
  deleteUser
} from '../repository/user.repository.js';

import { forbidden, notFound, badRequest } from '../utils/httpError.js';
import { ERROR_CODES } from '../utils/errorCodes.js';
import { runtime } from '../config/runtime.js';

const ensureAdmin = (user) => {
  if (!user || user.role !== 'admin') {
    throw forbidden('Forbidden', ERROR_CODES.FORBIDDEN);
  }
};

const normalizePagination = (query) => {
  const page = Math.max(1, Number(query.page) || 1);
  const limit = Math.min(100, Math.max(1, Number(query.limit) || 10));
  const offset = (page - 1) * limit;

  return { page, limit, offset };
};

export const getUsers = async (query, currentUser) => {
  ensureAdmin(currentUser);

  const { page, limit, offset } = normalizePagination(query);

  const [users, total] = await Promise.all([
    findUsersPaginated(offset, limit),
    countUsers()
  ]);

  return {
    data: users,
    meta: {
      page,
      limit,
      total,
      total_pages: Math.ceil(total / limit)
    }
  };
};

export const getUserById = async (id, currentUser) => {
  ensureAdmin(currentUser);

  const userId = Number(id);
  const user = await findById(userId);

  if (!user) {
    throw notFound('User not found', ERROR_CODES.NOT_FOUND);
  }

  return user;
};

export const updateUserById = async (id, data, currentUser) => {
  const userId = Number(id);

  if (data.username !== undefined) {
      throw badRequest('Username cannot be changed', ERROR_CODES.INVALID_OPERATION);
  }

  if (runtime.appMode !== 'development') {
    ensureAdmin(currentUser);

    if (currentUser.id === userId && data.role !== undefined) {
      throw badRequest('Cannot change own role', ERROR_CODES.INVALID_OPERATION);
    }
  }
  

  const existing = await findById(userId);

  if (!existing) {
    throw notFound('User not found', ERROR_CODES.NOT_FOUND);
  }

  return updateUser(userId, data);
};

export const deleteUserById = async (id, currentUser) => {
  ensureAdmin(currentUser);

  const userId = Number(id);

  if (currentUser.id === userId) {
    throw badRequest('Cannot delete yourself', ERROR_CODES.INVALID_OPERATION);
  }

  const existing = await findById(userId);

  if (!existing) {
    throw notFound('User not found', ERROR_CODES.NOT_FOUND);
  }

  await deleteUser(userId);

  return true;
};