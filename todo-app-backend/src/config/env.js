import dotenv from 'dotenv';
import Joi from 'joi';

dotenv.config();

const schema = Joi.object({
  PORT: Joi.number().port().required(),

  DB_HOST: Joi.string().required(),
  DB_PORT: Joi.number().port().required(),
  DB_USER: Joi.string().required(),
  DB_PASSWORD: Joi.string().allow('').required(),
  DB_NAME: Joi.string().required(),

  JWT_SECRET: Joi.string().min(16).required(),
  JWT_EXPIRES_IN: Joi.string().required(),

  ADMIN_TOKEN: Joi.string().min(6).required(),

  APP_MODE: Joi.string().valid('development', 'production').required()
}).unknown(true);

const { error } = schema.validate(process.env, {
  abortEarly: false
});

if (error) {
  throw new Error(
    `Env validation error:\n${error.details.map(d => `- ${d.message}`).join('\n')}`
  );
}

export const env = {
  appMode: process.env.APP_MODE,
  port: Number(process.env.PORT),

  adminToken: process.env.ADMIN_TOKEN,

  jwtSecret: process.env.JWT_SECRET,
  jwtExpiresIn: process.env.JWT_EXPIRES_IN,

  db: {
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  }
};