import { ERROR_CODES } from '../utils/errorCodes.js';
import * as resp from '../utils/response.js';

export const errorHandler = (err, req, res, next) => {
  const status = err.status || 500;

  const payload = {
    message: status >= 500 ? 'Internal server error' : err.message,
    error_code: err.code || ERROR_CODES.INTERNAL_ERROR,
    errors: err.errors
  };

  return resp.error(res, payload, status);
};