-- Insert sample data into rooms
INSERT INTO rooms (room_name, current_reading, total_units_today, total_units_month, total_devices)
VALUES
('Living Room', 0, 0, 0, 0),
('Bedroom', 0, 0, 0, 0),
('Kitchen', 0, 0, 0, 0);


-- Insert sample data into devices (assume room IDs as 1, 2, and 3 corresponding to Living Room, Bedroom, and Kitchen)
INSERT INTO devices (room_id, device_type, current_reading, total_units_today, total_units_month)
VALUES
(1, 'Fan', 0, 0, 0),
(1, 'Light', 0, 0, 0),
(2, 'AC', 0, 0, 0),
(3, 'Refrigerator', 0, 0, 0),
(3, 'Oven', 0, 0, 0);


-- Insert sample readings for the devices (assume device IDs as 1, 2, 3, 4, and 5)
INSERT INTO device_readings (device_id, current_reading, total_units_today, total_units_month)
VALUES
(1, 0.5, 0, 0),  -- Fan in Living Room
(2, 0.2, 0, 0),  -- Light in Living Room
(3, 1.5, 0, 0),  -- AC in Bedroom
(4, 0.8, 0, 0),  -- Refrigerator in Kitchen
(4, 0.8, 0, 0),
(5, 2.0, 0, 0);  -- Oven in Kitchen
