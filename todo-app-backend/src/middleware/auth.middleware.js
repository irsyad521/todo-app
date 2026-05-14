import { verifyToken } from '../utils/jwt.js';
import { unauthorized } from '../utils/httpError.js';
import { ERROR_CODES } from '../utils/errorCodes.js';

export const authenticate = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(
      unauthorized('Unauthorized', ERROR_CODES.UNAUTHORIZED)
    );
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = verifyToken(token);
    req.user = decoded;
    next();
  } catch (err) {
    return next(
      unauthorized('Invalid token', ERROR_CODES.UNAUTHORIZED)
    );
  }
};