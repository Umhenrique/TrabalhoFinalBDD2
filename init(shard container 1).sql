-- Criação da tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Inserção de 20 usuários
INSERT INTO users (username, email) VALUES
    ('user1', 'user1@example.com'),
    ('user2', 'user2@example.com'),
    ('user3', 'user3@example.com'),
    ('user4', 'user4@example.com'),
    ('user5', 'user5@example.com'),
    ('user6', 'user6@example.com'),
    ('user7', 'user7@example.com'),
    ('user8', 'user8@example.com'),
    ('user9', 'user9@example.com'),
    ('user10', 'user10@example.com'),
    ('user11', 'user11@example.com'),
    ('user12', 'user12@example.com'),
    ('user13', 'user13@example.com'),
    ('user14', 'user14@example.com'),
    ('user15', 'user15@example.com'),
    ('user16', 'user16@example.com'),
    ('user17', 'user17@example.com'),
    ('user18', 'user18@example.com'),
    ('user19', 'user19@example.com'),
    ('user20', 'user20@example.com');
