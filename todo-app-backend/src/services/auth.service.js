import {
  createUser,
  findByUsername,
  findById
} from '../repository/user.repository.js';

import { hashPassword, comparePassword } from '../utils/hash.js';
import { signToken } from '../utils/jwt.js';
import { badRequest, unauthorized } from '../utils/httpError.js';
import { ERROR_CODES } from '../utils/errorCodes.js';

export const register = async ({ username, password }) => {
  const existing = await findByUsername(username);

  if (existing) {
    throw badRequest('Username already exists', ERROR_CODES.USER_EXISTS);
  }

  const hashed = await hashPassword(password);

  const user = await createUser({
    username,
    password: hashed
  });

  return {
    id: user.id,
    username: user.username
  };
};

export const login = async ({ username, password }) => {
  const user = await findByUsername(username);

  if (!user) {
    throw unauthorized('Invalid credentials', ERROR_CODES.INVALID_CREDENTIALS);
  }

  const valid = await comparePassword(password, user.password);

  if (!valid) {
    throw unauthorized('Invalid credentials', ERROR_CODES.INVALID_CREDENTIALS);
  }

  const token = signToken({
    id: user.id,
    username: user.username,
    role: user.role
  });

  return {
    access_token: token
  };
};

export const me = async (userId) => {
  const user = await findById(userId);

  if (!user) {
    throw unauthorized('User not found', ERROR_CODES.INVALID_CREDENTIALS);
  }

  return user;
};