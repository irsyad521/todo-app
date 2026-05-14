import express from 'express';
import routes from './src/routes/index.js';
import pool from './src/config/db.js';
import { errorHandler } from './src/middleware/error.middleware.js';
import { setupSwagger } from './docs/openapi.js';
import { runtime } from './src/config/runtime.js';

const app = express();

app.use(express.json());

console.log(`Running in ${runtime.appMode} mode`);

setupSwagger(app);
app.use('/api/v1', routes);

app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');

    res.json({
      status: 'ok',
      db: 'connected',
      mode: runtime.appMode
    });
  } catch {
    res.status(500).json({
      status: 'error',
      db: 'disconnected'
    });
  }
});

app.use(errorHandler);

export default app;