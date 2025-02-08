import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceManagementScreen extends StatefulWidget {
  static const String routeName = '/device-management';

  @override
  _DeviceManagementScreenState createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  String responseText = "";
  List<Map<String, dynamic>> rooms = [];
  List<Map<String, dynamic>> deviceTypes = [];
  List<Map<String, dynamic>> devices = [];

  TextEditingController roomController = TextEditingController();
  TextEditingController deviceTypeController = TextEditingController();

  int? selectedRoomId;
  int? selectedDeviceTypeId;

  // Fetch rooms, device types, and devices
  Future<void> fetchData() async {
    await fetchRooms();
    await fetchDeviceTypes();
    await fetchDevices();
  }

  Future<void> fetchRooms() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/rooms"));
    if (response.statusCode == 200) {
      setState(() {
        rooms = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      setState(() {
        responseText = "Error: Unable to fetch rooms.";
      });
    }
  }

  Future<void> fetchDeviceTypes() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/device_types"));
    if (response.statusCode == 200) {
      setState(() {
        deviceTypes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      setState(() {
        responseText = "Error: Unable to fetch device types.";
      });
    }
  }

  Future<void> fetchDevices() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/devices"));
    if (response.statusCode == 200) {
      setState(() {
        devices = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      setState(() {
        responseText = "Error: Unable to fetch device data.";
      });
    }
  }

  // Add a device
  Future<void> addDevice() async {
    if (selectedRoomId == null || selectedDeviceTypeId == null) {
      setState(() {
        responseText = "Error: Please select a room and a device type.";
      });
      return;
    }

    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/api/devices"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "room_id": selectedRoomId,
        "device_type_id": selectedDeviceTypeId,
        "current_reading": 0,
        "total_units_today": 0,
        "total_units_month": 0,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        responseText = "Device added successfully!";
      });
      fetchDevices();
    } else {
      setState(() {
        responseText = "Error: Unable to add device.";
      });
    }
  }

  // Remove a device
  Future<void> removeDevice(int deviceId) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/api/devices/$deviceId"),
    );

    if (response.statusCode == 200) {
      setState(() {
        responseText = "Device removed successfully!";
      });
      fetchDevices();
    } else {
      setState(() {
        responseText = "Error: Unable to remove device.";
      });
    }
  }

  // Add a device type
  Future<void> addDeviceType(String deviceType) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/api/device_types"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "device_type": deviceType,
        "current_reading": 0,
        "total_units_today": 0,
        "total_units_month": 0,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        responseText = "Device type added successfully!";
      });
      fetchDeviceTypes();
    } else {
      setState(() {
        responseText = "Error: Unable to add device type.";
      });
    }
  }

  // Remove a device type
  Future<void> removeDeviceType(int deviceTypeId) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/api/device_types/$deviceTypeId"),
    );

    if (response.statusCode == 200) {
      setState(() {
        responseText = "Device type removed successfully!";
      });
      fetchDeviceTypes();
    } else {
      setState(() {
        responseText = "Error: Unable to remove device type.";
      });
    }
  }

  // Add a room
  Future<void> addRoom(String roomName) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/api/rooms"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "room_name": roomName,
        "current_reading": 0,
        "total_units_today": 0,
        "total_units_month": 0,
        "total_devices": 0,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        responseText = "Room added successfully!";
      });
      fetchRooms();
    } else {
      setState(() {
        responseText = "Error: Unable to add room.";
      });
    }
  }

  // Remove a room
  Future<void> removeRoom(int roomId) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/api/rooms/$roomId"),
    );

    if (response.statusCode == 200) {
      setState(() {
        responseText = "Room removed successfully!";
      });
      fetchRooms();
    } else {
      setState(() {
        responseText = "Error: Unable to remove room.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: Text("Refresh Data"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: roomController,
              decoration: InputDecoration(labelText: "Room Name"),
            ),
            ElevatedButton(
              onPressed: () => addRoom(roomController.text),
              child: Text("Add Room"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: deviceTypeController,
              decoration: InputDecoration(labelText: "Device Type"),
            ),
            ElevatedButton(
              onPressed: () => addDeviceType(deviceTypeController.text),
              child: Text("Add Device Type"),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              hint: Text("Select Room"),
              value: selectedRoomId,
              items: rooms
                  .map((room) => DropdownMenuItem<int>(
                value: room["room_id"],
                child: Text(room["room_name"]),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoomId = value;
                });
              },
            ),
            DropdownButton<int>(
              hint: Text("Select Device Type"),
              value: selectedDeviceTypeId,
              items: deviceTypes
                  .map((deviceType) => DropdownMenuItem<int>(
                value: deviceType["device_type_id"],
                child: Text(deviceType["device_type"]),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDeviceTypeId = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: addDevice,
              child: Text("Add Device"),
            ),
            SizedBox(height: 20),
            Text(responseText, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Rooms:"),
                    ...rooms.map((room) {
                      return ListTile(
                        title: Text(room["room_name"]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeRoom(room["room_id"]),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 10),
                    Text("Device Types:"),
                    ...deviceTypes.map((type) {
                      return ListTile(
                        title: Text(type["device_type"]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeDeviceType(type["device_type_id"]),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 10),
                    Text("Devices:"),
                    ...devices.map((device) {
                      return ListTile(
                        title: Text(device["device_id"].toString()),
                        subtitle: Text(device["room_name"]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeDevice(device["device_id"]),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class DeviceManagementScreen extends StatefulWidget {
//   static const String routeName = '/device-management';
//
//   @override
//   _DeviceManagementScreenState createState() => _DeviceManagementScreenState();
// }
//
// class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
//   String responseText = "";
//   List<Map<String, dynamic>> rooms = [];
//   List<Map<String, dynamic>> deviceTypes = [];
//   List<Map<String, dynamic>> devices = [];
//
//   TextEditingController roomController = TextEditingController();
//   TextEditingController deviceTypeController = TextEditingController();
//
//   // Fetch rooms, device types, and devices
//   Future<void> fetchData() async {
//     await fetchRooms();
//     await fetchDeviceTypes();
//     await fetchDevices();
//   }
//
//   Future<void> fetchRooms() async {
//     final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/rooms"));
//     if (response.statusCode == 200) {
//       setState(() {
//         rooms = List<Map<String, dynamic>>.from(jsonDecode(response.body));
//       });
//     } else {
//       setState(() {
//         responseText = "Error: Unable to fetch rooms.";
//       });
//     }
//   }
//
//   Future<void> fetchDeviceTypes() async {
//     final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/device_types"));
//     if (response.statusCode == 200) {
//       setState(() {
//         deviceTypes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
//       });
//     } else {
//       setState(() {
//         responseText = "Error: Unable to fetch device types.";
//       });
//     }
//   }
//
//   Future<void> fetchDevices() async {
//     final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/devices"));
//     if (response.statusCode == 200) {
//       setState(() {
//         devices = List<Map<String, dynamic>>.from(jsonDecode(response.body));
//       });
//     } else {
//       setState(() {
//         responseText = "Error: Unable to fetch device data.";
//       });
//     }
//   }
//
//   // Add a device
//   Future<void> addDevice(int roomId, int deviceTypeId) async {
//     final response = await http.post(
//       Uri.parse("http://10.0.2.2:3000/api/devices"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "room_id": roomId,
//         "device_type_id": deviceTypeId,
//         "current_reading": 0,
//         "total_units_today": 0,
//         "total_units_month": 0,
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       setState(() {
//         responseText = "Device added successfully!";
//       });
//       fetchDevices();
//     } else {
//       setState(() {
//         responseText = "Error: Unable to add device.";
//       });
//     }
//   }
//
//   // Remove a device
//   Future<void> removeDevice(int deviceId) async {
//     final response = await http.delete(
//       Uri.parse("http://10.0.2.2:3000/api/devices/$deviceId"),
//     );
//
//     if (response.statusCode == 200) {
//       setState(() {
//         responseText = "Device removed successfully!";
//       });
//       fetchDevices();
//     } else {
//       setState(() {
//         responseText = "Error: Unable to remove device.";
//       });
//     }
//   }
//
//   // Add a device type
//   Future<void> addDeviceType(String deviceType) async {
//     final response = await http.post(
//       Uri.parse("http://10.0.2.2:3000/api/device_types"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "device_type": deviceType,
//         "current_reading": 0,
//         "total_units_today": 0,
//         "total_units_month": 0,
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       setState(() {
//         responseText = "Device type added successfully!";
//       });
//       fetchDeviceTypes();
//     } else {
//       setState(() {
//         responseText = "Error: Unable to add device type.";
//       });
//     }
//   }
//
//   // Remove a device type
//   Future<void> removeDeviceType(int deviceTypeId) async {
//     final response = await http.delete(
//       Uri.parse("http://10.0.2.2:3000/api/device_types/$deviceTypeId"),
//     );
//
//     if (response.statusCode == 200) {
//       setState(() {
//         responseText = "Device type removed successfully!";
//       });
//       fetchDeviceTypes();
//     } else {
//       setState(() {
//         responseText = "Error: Unable to remove device type.";
//       });
//     }
//   }
//
//   // Add a room
//   Future<void> addRoom(String roomName) async {
//     final response = await http.post(
//       Uri.parse("http://10.0.2.2:3000/api/rooms"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "room_name": roomName,
//         "current_reading": 0,
//         "total_units_today": 0,
//         "total_units_month": 0,
//         "total_devices": 0,
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       setState(() {
//         responseText = "Room added successfully!";
//       });
//       fetchRooms();
//     } else {
//       setState(() {
//         responseText = "Error: Unable to add room.";
//       });
//     }
//   }
//
//   // Remove a room
//   Future<void> removeRoom(int roomId) async {
//     final response = await http.delete(
//       Uri.parse("http://10.0.2.2:3000/api/rooms/$roomId"),
//     );
//
//     if (response.statusCode == 200) {
//       setState(() {
//         responseText = "Room removed successfully!";
//       });
//       fetchRooms();
//     } else {
//       setState(() {
//         responseText = "Error: Unable to remove room.";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Device Management")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: fetchData,
//               child: Text("Refresh Data"),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: roomController,
//               decoration: InputDecoration(labelText: "Room Name"),
//             ),
//             ElevatedButton(
//               onPressed: () => addRoom(roomController.text),
//               child: Text("Add Room"),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: deviceTypeController,
//               decoration: InputDecoration(labelText: "Device Type"),
//             ),
//             ElevatedButton(
//               onPressed: () => addDeviceType(deviceTypeController.text),
//               child: Text("Add Device Type"),
//             ),
//             SizedBox(height: 10),
//             DropdownButton<int>(
//               hint: Text("Select Room"),
//               items: rooms
//                   .map((room) => DropdownMenuItem<int>(
//                 value: room["room_id"],
//                 child: Text(room["room_name"]),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//             DropdownButton<int>(
//               hint: Text("Select Device Type"),
//               items: deviceTypes
//                   .map((deviceType) => DropdownMenuItem<int>(
//                 value: deviceType["device_type_id"],
//                 child: Text(deviceType["device_type"]),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//             ElevatedButton(
//               onPressed: () => addDevice(1, 1), // Example room and device type IDs
//               child: Text("Add Device"),
//             ),
//             SizedBox(height: 20),
//             Text(responseText, style: TextStyle(fontSize: 16)),
//             SizedBox(height: 10),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Text("Rooms:"),
//                     ...rooms.map((room) {
//                       return ListTile(
//                         title: Text(room["room_name"]),
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => removeRoom(room["room_id"]),
//                         ),
//                       );
//                     }).toList(),
//                     SizedBox(height: 10),
//                     Text("Device Types:"),
//                     ...deviceTypes.map((type) {
//                       return ListTile(
//                         title: Text(type["device_type"]),
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => removeDeviceType(type["device_type_id"]),
//                         ),
//                       );
//                     }).toList(),
//                     SizedBox(height: 10),
//                     Text("Devices:"),
//                     ...devices.map((device) {
//                       return ListTile(
//                         title: Text(device["device_id"].toString()),
//                         subtitle: Text(device["room_name"]),
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => removeDevice(device["device_id"]),
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(title: Text("Device Management")),
//   //     body: Padding(
//   //       padding: const EdgeInsets.all(16.0),
//   //       child: Column(
//   //         children: [
//   //           ElevatedButton(
//   //             onPressed: fetchData,
//   //             child: Text("Refresh Data"),
//   //           ),
//   //           SizedBox(height: 10),
//   //           TextField(
//   //             controller: roomController,
//   //             decoration: InputDecoration(labelText: "Room Name"),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () => addRoom(roomController.text),
//   //             child: Text("Add Room"),
//   //           ),
//   //           SizedBox(height: 10),
//   //           TextField(
//   //             controller: deviceTypeController,
//   //             decoration: InputDecoration(labelText: "Device Type"),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () => addDeviceType(deviceTypeController.text),
//   //             child: Text("Add Device Type"),
//   //           ),
//   //           SizedBox(height: 10),
//   //           DropdownButton<int>(
//   //             hint: Text("Select Room"),
//   //             items: rooms
//   //                 .map((room) => DropdownMenuItem<int>(
//   //               value: room["room_id"],
//   //               child: Text(room["room_name"]),
//   //             ))
//   //                 .toList(),
//   //             onChanged: (value) {
//   //               setState(() {});
//   //             },
//   //           ),
//   //           DropdownButton<int>(
//   //             hint: Text("Select Device Type"),
//   //             items: deviceTypes
//   //                 .map((deviceType) => DropdownMenuItem<int>(
//   //               value: deviceType["device_type_id"],
//   //               child: Text(deviceType["device_type"]),
//   //             ))
//   //                 .toList(),
//   //             onChanged: (value) {
//   //               setState(() {});
//   //             },
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () => addDevice(1, 1), // Example room and device type IDs
//   //             child: Text("Add Device"),
//   //           ),
//   //           SizedBox(height: 20),
//   //           Text(responseText, style: TextStyle(fontSize: 16)),
//   //           SizedBox(height: 10),
//   //           Expanded(
//   //             child: SingleChildScrollView(
//   //               child: Column(
//   //                 children: [
//   //                   Text("Rooms:"),
//   //                   ...rooms.map((room) => Text(room["room_name"])).toList(),
//   //                   SizedBox(height: 10),
//   //                   Text("Device Types:"),
//   //                   ...deviceTypes.map((type) => Text(type["device_type"])).toList(),
//   //                   SizedBox(height: 10),
//   //                   Text("Devices:"),
//   //                   ...devices.map((device) {
//   //                     return ListTile(
//   //                       title: Text(device["device_id"].toString()),
//   //                       subtitle: Text(device["room_name"]),
//   //                     );
//   //                   }).toList(),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
