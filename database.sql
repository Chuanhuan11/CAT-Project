-- Database for Univent
CREATE DATABASE IF NOT EXISTS univent;
USE univent;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'student'
);

-- Insert a test user (Optional)
INSERT INTO users (fullname, email, password) VALUES ('Test Student', 'test@student.usm.my', 'password123');
