CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin','user') NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS todos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  completed BOOLEAN DEFAULT FALSE,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_title (user_id, title)
);

INSERT INTO users (username, password, role)
VALUES 
  ('admin', '$2b$10$fRdFrohXQhQQMv5Ou8GcsOsOt8jJ3CW5u2zqxF0O4n7DMsn3v6OgK', 'admin')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, password, role)
VALUES 
  ('user', '$2b$10$mhfyCPVji1SKkbX03cGjYuM3TGeMrhTAcWSuVT5B6SUUYD2YrmmKC', 'user')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO todos (title, description, completed, user_id)
VALUES 
  (
    'Setup project',
    'Initialize Node.js project',
    false,
    (SELECT id FROM users WHERE username = 'admin' LIMIT 1)
  )
ON DUPLICATE KEY UPDATE title = title;

INSERT INTO todos (title, description, completed, user_id)
VALUES 
  (
    'Build auth',
    'Implement login & register',
    false,
    (SELECT id FROM users WHERE username = 'admin' LIMIT 1)
  )
ON DUPLICATE KEY UPDATE title = title;

INSERT INTO todos (title, description, completed, user_id)
VALUES 
  (
    'Create first todo',
    'Test todo creation flow',
    true,
    (SELECT id FROM users WHERE username = 'user' LIMIT 1)
  )
ON DUPLICATE KEY UPDATE title = title;