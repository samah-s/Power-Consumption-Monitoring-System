const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Sample data structure
const rooms = [
  {
    id: 1,
    name: 'Living Room',
    deviceTypes: [
      {
        type: 'Light',
        devices: [
          { id: 1, name: 'Ceiling Light' },
          { id: 2, name: 'Wall Lamp' },
          { id: 3, name: 'Table Lamp' }
        ]
      },
      {
        type: 'Fan',
        devices: [
          { id: 4, name: 'Ceiling Fan' },
          { id: 5, name: 'Standing Fan' }
        ]
      },
      {
        type: 'AC',
        devices: [
          { id: 6, name: 'Main Air Conditioner' }
        ]
      }
    ]
  },
  {
    id: 2,
    name: 'Bedroom',
    deviceTypes: [
      {
        type: 'Light',
        devices: [
          { id: 7, name: 'Ceiling Light' },
          { id: 8, name: 'Bedside Lamp' }
        ]
      },
      {
        type: 'Fan',
        devices: [
          { id: 9, name: 'Ceiling Fan' }
        ]
      },
      {
        type: 'Heater',
        devices: [
          { id: 10, name: 'Room Heater' }
        ]
      }
    ]
  },
  {
    id: 3,
    name: 'Kitchen',
    deviceTypes: [
      {
        type: 'Light',
        devices: [
          { id: 11, name: 'Ceiling Light' }
        ]
      },
      {
        type: 'Appliance',
        devices: [
          { id: 12, name: 'Refrigerator' },
          { id: 13, name: 'Microwave Oven' },
          { id: 14, name: 'Dishwasher' }
        ]
      },
      {
        type: 'Fan',
        devices: [
          { id: 15, name: 'Exhaust Fan' }
        ]
      }
    ]
  }
];

// Endpoint to get the list of rooms with device types and devices
app.get('/rooms', (req, res) => {
  res.json(rooms);
});

app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});

// theodinproject
