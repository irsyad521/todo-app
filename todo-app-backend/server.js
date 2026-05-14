import app from './app.js';
import { initDB } from './src/db/init.js';
import pool from './src/config/db.js';
import { env } from './src/config/env.js';

const start = async () => {
  try {
    await initDB();

    await pool.query('SELECT 1');

    app.listen(env.port, () => {
      console.log(`Server running on port ${env.port}`);
    });
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

start();