CREATE DATABASE IF NOT EXISTS univent_db;
USE univent_db;

-- 1. DROP TABLES (Order matters: Drop tables with Foreign Keys first)
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

-- 2. CREATE TABLES

-- Users Table
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       email VARCHAR(100),
                       role VARCHAR(20) DEFAULT 'STUDENT'
);

-- Events Table (Now includes organizer_id directly)
CREATE TABLE events (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(100) NOT NULL,
                        description TEXT,
                        event_date DATE,
                        location VARCHAR(100),
                        price DECIMAL(10,2) DEFAULT 0.00,
                        image_url VARCHAR(255),
                        total_seats INT DEFAULT 100,
                        available_seats INT DEFAULT 100,
                        organizer_id INT,
                        FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Bookings Table
CREATE TABLE bookings (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          user_id INT,
                          event_id INT,
                          booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          status VARCHAR(20) DEFAULT 'CONFIRMED',
                          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                          FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- NEW: Cart Table
CREATE TABLE cart (
                      id INT AUTO_INCREMENT PRIMARY KEY,
                      user_id INT NOT NULL,
                      event_id INT NOT NULL,
                      added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                      FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS payment_methods (
                                               id INT AUTO_INCREMENT PRIMARY KEY,
                                               user_id INT NOT NULL,
                                               card_alias VARCHAR(100),   -- e.g. "Visa ending in 1234"
                                               card_number VARCHAR(20),   -- Storing dummy number for display
                                               expiry VARCHAR(10),
                                               FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. SEED DATA (Insert Default Data)

-- Insert Users
INSERT INTO users (username, password, email, role) VALUES
                                                        ('admin', '123', 'admin@univent.com', 'ADMIN'),
                                                        ('ali', '123', 'ali@student.usm.my', 'STUDENT');

-- Insert Events
INSERT INTO events (title, description, event_date, location, price, image_url, total_seats, available_seats, organizer_id) VALUES
                                                                                                                                ('Java Workshop', 'Learn Java Fast', '2026-02-10', 'DK F', 10.00, 'event1.jpg', 50, 40, 1),
                                                                                                                                ('Campus Run', '5km Run', '2026-03-15', 'Stadium', 25.00, 'event2.jpg', 500, 450, 1),
                                                                                                                                ('USM Grand Concert', 'A night of music featuring local bands and special guests.', '2026-04-10', 'Dewan Tunku Syed Putra', 35.00, 'event3.jpg', 500, 450, 1),
                                                                                                                                ('Inter-Varsity Football Final', 'Cheer for USM as they face off against UM in the finals.', '2026-05-02', 'USM Stadium', 5.00, 'event4.jpg', 1000, 800, 1),
                                                                                                                                ('Career Fair 2026', 'Meet employers from top tech companies like Intel, Grab, and Google.', '2026-03-20', 'Exam Hall', 0.00, 'event5.jpg', 600, 550, 1),
                                                                                                                                ('Digital Art Exhibition', 'Showcasing amazing digital artwork by the School of Arts.', '2026-02-15', 'Muzium & Galeri Tuanku Fauziah', 12.00, 'event6.jpg', 100, 95, 1),
                                                                                                                                ('Python for Data Science', 'Intermediate workshop on using Pandas and NumPy.', '2026-06-12', 'Computer Lab 3', 15.00, 'event7.jpg', 40, 40, 1),
                                                                                                                                ('Badminton Tournament', 'Open to all students. Register your team now!', '2026-07-01', 'Sports Complex', 10.00, 'event8.jpg', 32, 30, 1);