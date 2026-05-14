import * as service from '../services/auth.service.js';
import * as resp from '../utils/response.js';

export const register = async (req, res, next) => {
  try {
    const data = await service.register(req.body);
    return resp.success(res, data, 201);
  } catch (err) {
    next(err);
  }
};

export const login = async (req, res, next) => {
  try {
    const data = await service.login(req.body);
    return resp.success(res, data);
  } catch (err) {
    next(err);
  }
};

export const me = async (req, res, next) => {
  try {
    const result = await service.me(req.user.id);
    return resp.success(res, result);
  } catch (err) {
    next(err);
  }
};