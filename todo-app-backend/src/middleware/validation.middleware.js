import Joi from 'joi';
import { sanitize, hasXSS } from '../utils/sanitizer.js';
import { ERROR_CODES } from '../utils/errorCodes.js';

const clean = (val) => sanitize(val);

const checkXSS = (value, helpers) => {
  if (typeof value === 'string' && hasXSS(value)) {
    return helpers.error('any.invalid');
  }
  return clean(value);
};

const deepSanitize = (obj) => {
  if (typeof obj === 'string') return sanitize(obj);
  if (Array.isArray(obj)) return obj.map(deepSanitize);
  if (obj && typeof obj === 'object') {
    return Object.fromEntries(
      Object.entries(obj).map(([k, v]) => [k, deepSanitize(v)])
    );
  }
  return obj;
};

export const validate = (schema) => {
  return (req, res, next) => {
    try {
      if (schema.body) {
        const { value, error } = schema.body.validate(req.body, {
          abortEarly: false,
          stripUnknown: true,
          convert: true
        });
        if (error) throw formatJoiError(error);
        req.body = deepSanitize(value);
      }

      if (schema.query) {
        const { value, error } = schema.query.validate(req.query, {
          abortEarly: false,
          stripUnknown: true,
          convert: true
        });
        if (error) throw formatJoiError(error);
        Object.assign(req.query, value);
      }

      if (schema.params) {
        const { value, error } = schema.params.validate(req.params, {
          abortEarly: false,
          stripUnknown: true,
          convert: true
        });
        if (error) throw formatJoiError(error);
        Object.assign(req.params, value);
      }

      next();
    } catch (err) {
      next(err);
    }
  };
};

const formatJoiError = (error) => {
  const err = new Error('Validation error');
  err.status = 400;
  err.code = ERROR_CODES.VALIDATION_ERROR;

  err.errors = {};
  error.details.forEach(d => {
    err.errors[d.path.join('.')] = d.message;
  });

  return err;
};

export const schemas = {
  auth: {
    register: {
      body: Joi.object({
        username: Joi.string().min(4).max(100).required().custom(checkXSS),
        password: Joi.string().min(4).max(255).required()
      }).unknown(false)
    },
    login: {
      body: Joi.object({
        username: Joi.string().required().custom(checkXSS),
        password: Joi.string().required()
      }).unknown(false)
    }
  },

  todo: {
    query: Joi.object({
      completed: Joi.boolean().optional(),
      page: Joi.number().integer().min(1).default(1),
      limit: Joi.number().integer().min(1).max(100).default(10)
    }),

    create: {
      body: Joi.object({
        title: Joi.string().max(255).required().custom(checkXSS),
        description: Joi.string().allow(null, '').optional().custom(checkXSS),
        completed: Joi.boolean().optional()
      }).unknown(false)
    },

    update: {
      params: Joi.object({
        id: Joi.number().integer().positive().required()
      }),
      body: Joi.object({
        title: Joi.string().max(255).optional().custom(checkXSS),
        description: Joi.string().allow(null, '').optional().custom(checkXSS),
        completed: Joi.boolean().optional()
      }).min(1).unknown(false)
    },

    idParam: {
      params: Joi.object({
        id: Joi.number().integer().positive().required()
      })
    }
  },

  user: {
    query: Joi.object({
      page: Joi.number().integer().min(1).default(1),
      limit: Joi.number().integer().min(1).max(100).default(10)
    }),

    idParam: {
      params: Joi.object({
        id: Joi.number().integer().positive().required()
      })
    },

    update: {
      params: Joi.object({
        id: Joi.number().integer().positive().required()
      }),
      body: Joi.object({
        role: Joi.string().valid('user', 'admin').required()
      }).unknown(false)
    }
  },

  system: {
    mode: {
      body: Joi.object({
        mode: Joi.string().valid('production', 'development').required()
      }).unknown(false)
    }
  }
};