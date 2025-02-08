import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> rooms = [];

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  void fetchRooms() async {
    final response = await http.get(Uri.parse('http://localhost:3000/rooms'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        rooms = data;
      });
    } else {
      throw Exception('Failed to load rooms data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Power Consumption Monitor'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          var room = rooms[index];
          return ExpansionTile(
            title: Text(room['name']),
            children: (room['deviceTypes'] as List).map((deviceType) {
              return ListTile(
                title: Text(deviceType['type']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (deviceType['devices'] as List).map((device) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Text('Device: ${device['name']}'),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
