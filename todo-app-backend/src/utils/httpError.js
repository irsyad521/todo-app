export class HttpError extends Error {
  constructor(message, status = 500, code = 'INTERNAL_ERROR', errors = null) {
    super(message);
    this.status = status;
    this.code = code;
    this.errors = errors;
  }
}

export const badRequest = (msg = 'Bad Request', code = 'BAD_REQUEST', errors = null) =>
  new HttpError(msg, 400, code, errors);

export const unauthorized = (msg = 'Unauthorized', code = 'UNAUTHORIZED') =>
  new HttpError(msg, 401, code);

export const forbidden = (msg = 'Forbidden') =>
  new HttpError(msg, 403, 'FORBIDDEN');

export const notFound = (msg = 'Not found') =>
  new HttpError(msg, 404, 'NOT_FOUND');

export const internal = (msg = 'Internal server error') =>
  new HttpError(msg, 500, 'INTERNAL_ERROR');