-- Use the created database

CREATE DATABASE IF NOT EXISTS smart_power_management;
USE smart_power_management;

DROP TABLE IF EXISTS device_readings;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS rooms;


-- Create rooms table
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL,
    current_reading FLOAT DEFAULT 0,
    total_units_today FLOAT DEFAULT 0,
    total_units_month FLOAT DEFAULT 0,

    total_devices INT DEFAULT 0
);

-- Create devices table
CREATE TABLE devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    device_type VARCHAR(100) NOT NULL,
    current_reading FLOAT DEFAULT 0,
    total_units_today FLOAT DEFAULT 0,
    total_units_month FLOAT DEFAULT 0,
    
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
);

-- Create device_readings table
CREATE TABLE device_readings (
    reading_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    current_reading FLOAT,
    total_units_today FLOAT DEFAULT 0,
    total_units_month FLOAT DEFAULT 0,
    FOREIGN KEY (device_id) REFERENCES devices(device_id) ON DELETE CASCADE
);




