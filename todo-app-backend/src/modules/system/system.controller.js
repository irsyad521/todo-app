// src/modules/system/system.controller.js
import * as systemService from './system.service.js';
import * as resp from '../../utils/response.js';
import { env } from '../../config/env.js';

export const updateMode = async (req, res, next) => {
  try {
    const token = req.headers['x-admin-token'];

    if (token !== env.adminToken) {
      return resp.fail(res, 'Forbidden', 403);
    }

    const { mode } = req.body;

    const updated = systemService.setMode(mode);

    return resp.success(res, { mode: updated });
  } catch (err) {
    next(err);
  }
};

export const getMode = async (req, res, next) => {
  try {
    const mode = systemService.getMode();
    return resp.success(res, { mode });
  } catch (err) {
    next(err);
  }
};