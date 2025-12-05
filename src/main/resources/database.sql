CREATE DATABASE IF NOT EXISTS univent_db;
USE univent_db;

CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       email VARCHAR(100),
                       role VARCHAR(20) DEFAULT 'STUDENT'
);

CREATE TABLE events (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(100) NOT NULL,
                        description TEXT,
                        event_date DATE,
                        location VARCHAR(100),
                        price DECIMAL(10,2) DEFAULT 0.00,
                        image_url VARCHAR(255),
                        total_seats INT DEFAULT 100,
                        available_seats INT DEFAULT 100
);

CREATE TABLE bookings (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          user_id INT,
                          event_id INT,
                          booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          status VARCHAR(20) DEFAULT 'CONFIRMED',
                          FOREIGN KEY (user_id) REFERENCES users(id),
                          FOREIGN KEY (event_id) REFERENCES events(id)
);

INSERT INTO users (username, password, email, role) VALUES
                                                        ('admin', '123', 'admin@univent.com', 'ADMIN'),
                                                        ('ali', '123', 'ali@student.usm.my', 'STUDENT');

INSERT INTO events (title, description, event_date, location, price, available_seats) VALUES
                                                                                          ('Java Workshop', 'Learn Java Fast', '2026-02-10', 'DK F', 10.00, 50),
                                                                                          ('Campus Run', '5km Run', '2026-03-15', 'Stadium', 25.00, 198);