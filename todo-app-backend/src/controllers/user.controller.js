import * as service from '../services/user.service.js';
import * as resp from '../utils/response.js';

export const getUsers = async (req, res, next) => {
  try {
    const result = await service.getUsers(req.query, req.user);
    return resp.success(res, result);
  } catch (err) {
    next(err);
  }
};

export const getUser = async (req, res, next) => {
  try {
    const data = await service.getUserById(Number(req.params.id), req.user);
    return resp.success(res, data);
  } catch (err) {
    next(err);
  }
};

export const updateUser = async (req, res, next) => {
  try {
    const data = await service.updateUserById(
      Number(req.params.id),
      req.body,
      req.user
    );
    return resp.success(res, data);
  } catch (err) {
    next(err);
  }
};

export const deleteUser = async (req, res, next) => {
  try {
    await service.deleteUserById(Number(req.params.id), req.user);
    return resp.success(res, null, 200, 'User deleted');
  } catch (err) {
    next(err);
  }
};