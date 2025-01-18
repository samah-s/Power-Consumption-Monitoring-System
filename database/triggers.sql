-- Trigger to update total power for the device and room when a new reading is added

DELIMITER $$

-- to update the current_reading in devices
-- step 1: get the new value for current_reading from the device_readings, the value that is being inserted
-- step 2: get the device_id of the new value from the device_readings, the value that is being inserted
-- step 3: get the room_id of the new value from the device_readings, the value that is being inserted
-- step 4: for the device_id and room_id that was old value in the current_readings
-- step 5: take the existing current_reading in devices, and subtract the old value fetched in step 4 from it
-- step 6: add the new value for current_reading obtained from the step 1, to the result in step 5
-- step 7: update the result from step 6 in the device_type in table devices with the result obtained 


-- Trigger to update current_reading in devices when a new reading is inserted in device_readings
CREATE TRIGGER update_device_current_reading
AFTER INSERT ON device_readings
FOR EACH ROW
BEGIN
    DECLARE old_reading FLOAT;
    DECLARE new_reading FLOAT;
    DECLARE roomId INT;
    
    -- Get the current reading of the device before the new reading is inserted
    SET old_reading = (SELECT current_reading FROM devices WHERE device_id = NEW.device_id);

    -- current: old_reading, NEW.current_reading; roomId, 

    -- Update the current reading in devices table with the new value
    UPDATE devices
    SET current_reading = NEW.current_reading
    WHERE device_id = NEW.device_id;

    -- Calculate the difference between the new reading and the old reading
    -- SET new_reading = NEW.current_reading - old_reading;

    -- Get the room ID corresponding to the device
    -- SET roomId = (SELECT room_id FROM devices WHERE device_id = NEW.device_id);

    -- -- Update the total current_reading in rooms table
    -- UPDATE rooms
    -- SET total_units_today = total_units_today + new_reading,
    --     total_units_month = total_units_month + new_reading
    -- WHERE room_id = roomId;

END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER update_units_in_device_readings
BEFORE INSERT ON device_readings
FOR EACH ROW
BEGIN
    -- Calculate units consumed in kWh
    SET @units_consumed = (NEW.current_reading * 220 * 10) / 3600000;

    -- Update total units for today and month in device_readings
    SET NEW.total_units_today = NEW.total_units_today + @units_consumed;
    SET NEW.total_units_month = NEW.total_units_month + @units_consumed;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER update_units_in_devices
AFTER INSERT ON device_readings
FOR EACH ROW
BEGIN
    -- Calculate units consumed in kWh
    SET @units_consumed = (NEW.current_reading * 220 * 10) / 3600000;

    -- Update total units for today and month in devices
    UPDATE devices
    SET total_units_today = total_units_today + @units_consumed,
        total_units_month = total_units_month + @units_consumed
    WHERE device_id = NEW.device_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER update_units_in_rooms
AFTER INSERT ON device_readings
FOR EACH ROW
BEGIN
    -- Calculate units consumed in kWh
    SET @units_consumed = (NEW.current_reading * 220 * 10) / 3600000;

    -- Update total units for today and month in rooms
    UPDATE rooms
    SET total_units_today = total_units_today + @units_consumed,
        total_units_month = total_units_month + @units_consumed
    WHERE room_id = (SELECT room_id FROM devices WHERE device_id = NEW.device_id);
END$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER update_device_count_after_insert
AFTER INSERT ON devices
FOR EACH ROW
BEGIN
    -- Update the total number of devices in the room
    UPDATE rooms
    SET total_devices = total_devices + 1
    WHERE room_id = NEW.room_id;
END$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER update_device_count_after_delete
AFTER DELETE ON devices
FOR EACH ROW
BEGIN
    -- Update the total number of devices in the room
    UPDATE rooms
    SET total_devices = total_devices - 1
    WHERE room_id = OLD.room_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER update_room_current_reading
AFTER INSERT ON device_readings
FOR EACH ROW
BEGIN
    DECLARE roomId INT;
    DECLARE totalCurrentReading FLOAT;

    -- Fetch the room ID of the device linked to the new reading
    SET roomId = (SELECT room_id FROM devices WHERE device_id = NEW.device_id);

    -- Calculate the sum of current readings for all devices in the room
    SET totalCurrentReading = (SELECT SUM(current_reading) FROM devices WHERE room_id = roomId);

    -- Update the current reading for the room
    UPDATE rooms
    SET current_reading = totalCurrentReading
    WHERE room_id = roomId;
END$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER update_device_type_units
AFTER INSERT ON device_readings
FOR EACH ROW
BEGIN
    DECLARE deviceTypeId INT;
    DECLARE unitsConsumed FLOAT;

    -- Fetch the device type ID of the device linked to the new reading
    SET deviceTypeId = (SELECT device_type_id FROM devices WHERE device_id = NEW.device_id);

    -- Calculate units consumed in kWh for the current reading
    SET unitsConsumed = (NEW.current_reading * 220 * 10) / 3600000;

    -- Check if the device type already exists in the device_types table
    IF EXISTS (SELECT 1 FROM device_types WHERE device_type_id = deviceTypeId) THEN
        -- Update the total units and current reading for the device type
        UPDATE device_types
        SET total_units_today = total_units_today + unitsConsumed,
            total_units_month = total_units_month + unitsConsumed,
            current_reading = (SELECT SUM(current_reading) 
                               FROM devices 
                               WHERE device_type_id = deviceTypeId)
        WHERE device_type_id = deviceTypeId;
    ELSE
        -- Insert a new row for the device type
        INSERT INTO device_types (device_type_id, total_units_today, total_units_month, current_reading)
        VALUES (deviceTypeId, unitsConsumed, unitsConsumed, NEW.current_reading);
    END IF;
END$$

DELIMITER ;





