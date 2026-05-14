import pool from '../config/db.js';

export const createUser = async ({ username, password, role = 'user' }) => {
  const [result] = await pool.query(
    'INSERT INTO users (username, password, role) VALUES (?, ?, ?)',
    [username, password, role]
  );

  return {
    id: result.insertId,
    username,
    role
  };
};

export const findByUsername = async (username) => {
  const [rows] = await pool.query(
    'SELECT * FROM users WHERE username = ? LIMIT 1',
    [username]
  );
  return rows[0] || null;
};


export const findById = async (id) => {
  const [rows] = await pool.query(
    'SELECT id, username, role FROM users WHERE id = ? LIMIT 1',
    [id]
  );
  return rows[0] || null;
};

export const findUsersPaginated = async (offset, limit) => {
  const [rows] = await pool.query(
    'SELECT id, username, role FROM users ORDER BY id DESC LIMIT ? OFFSET ?',
    [limit, offset]
  );
  return rows;
};

export const countUsers = async () => {
  const [rows] = await pool.query(
    'SELECT COUNT(*) as total FROM users'
  );
  return rows[0].total;
};

export const updateUser = async (id, data) => {
  const fields = [];
  const values = [];

  if (data.username !== undefined) {
    fields.push('username = ?');
    values.push(data.username);
  }

  if (data.role !== undefined) {
    fields.push('role = ?');
    values.push(data.role);
  }

  if (fields.length === 0) return null;

  values.push(id);

  await pool.query(
    `UPDATE users SET ${fields.join(', ')} WHERE id = ?`,
    values
  );

  return findById(id);
};

export const deleteUser = async (id) => {
  await pool.query(
    'DELETE FROM users WHERE id = ?',
    [id]
  );
};