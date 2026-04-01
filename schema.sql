-- Database Schema for Campus Lost and Found

CREATE TABLE users (
    uid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    phone VARCHAR(15),
    role VARCHAR(10) DEFAULT 'user',
    roll_no VARCHAR(50)
);

CREATE TABLE items (
    item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(100),
    type VARCHAR(10),
    description TEXT,
    location VARCHAR(100),
    status VARCHAR(20) DEFAULT 'AVAILABLE',
    posted_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (posted_by) REFERENCES users(uid) ON DELETE CASCADE
);

CREATE TABLE claims (
    claim_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    claimant_id INT,
    claim_status VARCHAR(20) DEFAULT 'PENDING',
    claim_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (claimant_id) REFERENCES users(uid) ON DELETE CASCADE
);