const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Use CORS to allow client-side requests
app.use(cors());

// MySQL connection setup
const db = mysql.createConnection({
  host: '34.47.238.116', // Replace with your Google Cloud DB host
  user: 'samah',         // Replace with your MySQL username
  password: 'Cloud#1234',// Replace with your MySQL password
  database: 'smart_power_management', // Replace with your database name
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    process.exit(1);
  }
  console.log('Connected to the MySQL database!');
});

// API endpoint to fetch rooms and device details
app.get('/api/devices', (req, res) => {
  const query = `
    SELECT
      r.room_name,
      d.device_id,
      d.current_reading,
      d.total_units_today,
      d.total_units_month,
      dt.device_type
    FROM
      rooms r
    JOIN
      devices d ON r.room_id = d.room_id
    JOIN
      device_types dt ON d.device_type_id = dt.device_type_id;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(200).json(results); // Send results as JSON
  });
});

// API endpoint to fetch rooms and device details
app.get('/api/device_types', (req, res) => {
  const query = `
    SELECT * FROM device_types;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(200).json(results); // Send results as JSON
  });
});

// API endpoint to fetch room details
app.get('/api/rooms', (req, res) => {
  const query = `
    SELECT
      room_id,
      room_name,
      current_reading,
      total_units_today,
      total_units_month,
      total_devices
    FROM
      rooms;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(200).json(results); // Send room details as JSON
  });
});

// API endpoint to add a new device
app.post('/api/devices', (req, res) => {
  const { room_id, device_type_id, current_reading } = req.body;
  const query = `
    INSERT INTO devices (room_id, device_type_id, current_reading)
    VALUES (?, ?, ?);
  `;

  db.query(query, [room_id, device_type_id, current_reading], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(201).json({ message: 'Device added successfully' });
  });
});

// API endpoint to remove a device
app.delete('/api/devices/:device_id', (req, res) => {
  const { device_id } = req.params;
  const query = 'DELETE FROM devices WHERE device_id = ?';

  db.query(query, [device_id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: 'Device not found' });
    }
    res.status(200).json({ message: 'Device removed successfully' });
  });
});

// API endpoint to add a new device type
app.post('/api/device_types', (req, res) => {
  const { device_type } = req.body;
  const query = `
    INSERT INTO device_types (device_type)
    VALUES (?);
  `;

  db.query(query, [device_type], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(201).json({ message: 'Device type added successfully' });
  });
});

// API endpoint to remove a device type
app.delete('/api/device_types/:device_type_id', (req, res) => {
  const { device_type_id } = req.params;
  const query = 'DELETE FROM device_types WHERE device_type_id = ?';

  db.query(query, [device_type_id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: 'Device type not found' });
    }
    res.status(200).json({ message: 'Device type removed successfully' });
  });
});

// API endpoint to add a new room
app.post('/api/rooms', (req, res) => {
  const { room_name, current_reading, total_units_today, total_units_month, total_devices } = req.body;
  const query = `
    INSERT INTO rooms (room_name, current_reading, total_units_today, total_units_month, total_devices)
    VALUES (?, ?, ?, ?, ?);
  `;

  db.query(query, [room_name, current_reading, total_units_today, total_units_month, total_devices], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.status(201).json({ message: 'Room added successfully' });
  });
});

// API endpoint to remove a room
app.delete('/api/rooms/:room_id', (req, res) => {
  const { room_id } = req.params;
  const query = 'DELETE FROM rooms WHERE room_id = ?';

  db.query(query, [room_id], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: 'Room not found' });
    }
    res.status(200).json({ message: 'Room removed successfully' });
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});




//const express = require('express');
//const mysql = require('mysql2');
//const cors = require('cors');
//const app = express();
//const port = 3000;
//
//// Use CORS to allow client-side requests
//app.use(cors());
//
//// MySQL connection setup
//const db = mysql.createConnection({
//  host: '34.47.238.116', // Replace with your Google Cloud DB host
//  user: 'samah',         // Replace with your MySQL username
//  password: 'Cloud#1234',// Replace with your MySQL password
//  database: 'smart_power_management', // Replace with your database name
//});
//
//// Connect to MySQL
//db.connect((err) => {
//  if (err) {
//    console.error('Error connecting to the database:', err);
//    process.exit(1);
//  }
//  console.log('Connected to the MySQL database!');
//});
//
//// API endpoint to fetch rooms and device details
//app.get('/api/devices', (req, res) => {
//  const query = `
//    SELECT
//      r.room_name,
//      d.device_id,
//      d.current_reading,
//      d.total_units_today,
//      d.total_units_month,
//      dt.device_type
//    FROM
//      rooms r
//    JOIN
//      devices d ON r.room_id = d.room_id
//    JOIN
//      device_types dt ON d.device_type_id = dt.device_type_id;
//  `;
//
//  db.query(query, (err, results) => {
//    if (err) {
//      console.error('Error executing query:', err);
//      return res.status(500).json({ error: 'Database query error' });
//    }
//    res.status(200).json(results); // Send results as JSON
//  });
//});
//
//// API endpoint to fetch room details
//app.get('/api/rooms', (req, res) => {
//  const query = `
//    SELECT
//      room_id,
//      room_name,
//      current_reading,
//      total_units_today,
//      total_units_month,
//      total_devices
//    FROM
//      rooms;
//  `;
//
//  db.query(query, (err, results) => {
//    if (err) {
//      console.error('Error executing query:', err);
//      return res.status(500).json({ error: 'Database query error' });
//    }
//    res.status(200).json(results); // Send room details as JSON
//  });
//});
//
//// Start the server
//app.listen(port, () => {
//  console.log(`Server is running on http://localhost:${port}`);
//});
