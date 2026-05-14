import fs from 'fs/promises';
import path from 'path';
import mysql from 'mysql2/promise';
import { fileURLToPath } from 'url';
import { env } from '../config/env.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const sleep = (ms) => new Promise(res => setTimeout(res, ms));

const waitForMySQL = async (retries = 10, delay = 2000) => {
  for (let i = 1; i <= retries; i++) {
    try {
      const conn = await mysql.createConnection({
        host: env.db.host,
        port: env.db.port,
        user: env.db.user,
        password: env.db.password
      });

      await conn.query('SELECT 1');
      await conn.end();
      return;
    } catch {
      await sleep(delay);
    }
  }

  throw new Error('MySQL not reachable after retries');
};

export const initDB = async () => {
  await waitForMySQL();

  const connection = await mysql.createConnection({
    host: env.db.host,
    port: env.db.port,
    user: env.db.user,
    password: env.db.password
  });

  await connection.query(
    `CREATE DATABASE IF NOT EXISTS \`${env.db.database}\``
  );

  await connection.query(`USE \`${env.db.database}\``);

  const schemaPath = path.join(__dirname, 'schema.sql');
  const sql = await fs.readFile(schemaPath, 'utf-8');

  const statements = sql
    .split(';')
    .map(s => s.trim())
    .filter(Boolean);

  for (const stmt of statements) {
    await connection.query(stmt);
  }

  await connection.end();
};