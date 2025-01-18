-- To update total_units to 0 before day start and month start

DELIMITER $$

CREATE EVENT reset_total_units_today
ON SCHEDULE EVERY 1 DAY
STARTS '2025-01-19 00:00:00'  -- Starting from midnight on January 19, 2025
DO
BEGIN
    -- Reset total_units_today for all devices, rooms, and device_types
    UPDATE device_readings SET total_units_today = 0;
    UPDATE devices SET total_units_today = 0;
    UPDATE rooms SET total_units_today = 0;
    UPDATE device_types SET total_units_today = 0;
END$$

DELIMITER ;


DELIMITER $$

CREATE EVENT reset_total_units_month
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-02-01 00:00:00'  -- Starting from midnight on February 1, 2025
DO
BEGIN
    -- Reset total_units_month for all devices, rooms, and device_types
    UPDATE device_readings SET total_units_month = 0;
    UPDATE devices SET total_units_month = 0;
    UPDATE rooms SET total_units_month = 0;
    UPDATE device_types SET total_units_month = 0;
END$$

DELIMITER ;
