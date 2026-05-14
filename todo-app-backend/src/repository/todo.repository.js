import pool from '../config/db.js';

export const createTodo = async ({ title, description, completed, user_id }) => {
  const [result] = await pool.query(
    'INSERT INTO todos (title, description, completed, user_id) VALUES (?, ?, ?, ?)',
    [title, description ?? null, completed ?? false, user_id]
  );

  const [rows] = await pool.query(`
    SELECT t.id, t.title, t.description, t.completed, t.user_id, u.username
    FROM todos t
    JOIN users u ON t.user_id = u.id
    WHERE t.id = ?
    LIMIT 1
  `, [result.insertId]);

  return rows[0];
};

export const findTodosPaginated = async (offset, limit) => {
  const [rows] = await pool.query(`
    SELECT t.id, t.title, t.description, t.completed, t.user_id, u.username
    FROM todos t
    JOIN users u ON t.user_id = u.id
    ORDER BY t.id DESC
    LIMIT ? OFFSET ?
  `, [limit, offset]);

  return rows;
};

export const findTodosByUserPaginated = async (userId, offset, limit) => {
  const [rows] = await pool.query(`
    SELECT t.id, t.title, t.description, t.completed, t.user_id, u.username
    FROM todos t
    JOIN users u ON t.user_id = u.id
    WHERE t.user_id = ?
    ORDER BY t.id DESC
    LIMIT ? OFFSET ?
  `, [userId, limit, offset]);

  return rows;
};

export const countTodos = async () => {
  const [rows] = await pool.query(
    'SELECT COUNT(*) as total FROM todos'
  );
  return rows[0].total;
};

export const countTodosByUser = async (userId) => {
  const [rows] = await pool.query(
    'SELECT COUNT(*) as total FROM todos WHERE user_id = ?',
    [userId]
  );
  return rows[0].total;
};

export const findByIdWithUser = async (id) => {
  const [rows] = await pool.query(`
    SELECT t.id, t.title, t.description, t.completed, t.user_id, u.username
    FROM todos t
    JOIN users u ON t.user_id = u.id
    WHERE t.id = ?
    LIMIT 1
  `, [id]);

  return rows[0] || null;
};

export const updateById = async (id, data) => {
  const fields = [];
  const values = [];

  if (data.title !== undefined) {
    fields.push('title = ?');
    values.push(data.title);
  }

  if (data.description !== undefined) {
    fields.push('description = ?');
    values.push(data.description);
  }

  if (data.completed !== undefined) {
    fields.push('completed = ?');
    values.push(data.completed);
  }

  if (fields.length === 0) return null;

  values.push(id);

  await pool.query(
    `UPDATE todos SET ${fields.join(', ')} WHERE id = ?`,
    values
  );

  const [rows] = await pool.query(`
    SELECT t.id, t.title, t.description, t.completed, t.user_id, u.username
    FROM todos t
    JOIN users u ON t.user_id = u.id
    WHERE t.id = ?
    LIMIT 1
  `, [id]);

  return rows[0] || null;
};

export const deleteById = async (id) => {
  const [result] = await pool.query(
    'DELETE FROM todos WHERE id = ?',
    [id]
  );
  return result.affectedRows > 0;
};