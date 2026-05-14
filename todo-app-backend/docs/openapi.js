import swaggerUi from 'swagger-ui-express';
import YAML from 'yamljs';
import path from 'path';
import { fileURLToPath } from 'url';
import { runtime } from '../src/config/runtime.js';
import { forbidden } from '../src/utils/httpError.js';
import { ERROR_CODES } from '../src/utils/errorCodes.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const swaggerDocument = YAML.load(path.join(__dirname, 'swagger.yaml'));

export const setupSwagger = (app) => {
  app.use('/docs', (req, res, next) => {
    if (runtime.appMode !== 'development') {
      return next(forbidden('Forbidden', ERROR_CODES.FORBIDDEN));
    }
    next();
  });

  app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
};