import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LLMAnalysisScreen extends StatefulWidget {
  static const String routeName = '/llm-screen';
  @override
  _LLMAnalysisScreenState createState() => _LLMAnalysisScreenState();
}

class _LLMAnalysisScreenState extends State<LLMAnalysisScreen> {
  String responseText = "";
  List<Map<String, dynamic>> devices = [];

  Future<void> fetchDevices() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/devices"));

    if (response.statusCode == 200) {
      setState(() {
        devices = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
      analyzeData();
    } else {
      setState(() {
        responseText = "Error: Unable to fetch device data.";
      });
    }
  }

  Future<void> analyzeData() async {
    String apiKey = "AIzaSyDR8runG2uakoIUMm7c81QcafyXoXs3llw";
    String endpoint = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey";

    Map<String, dynamic> requestBody = {
      "contents": [{
        "parts": [{
          "text": "${jsonEncode(devices)}. Analyze the power consumption patterns and provide insights/tips based on this data."
        }]
      }]
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        responseText = jsonResponse["candidates"]?[0]["content"]["parts"][0]["text"] ?? "No response received.";
      });
    } else {
      setState(() {
        responseText = "Error: Unable to fetch insights.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appliance Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchDevices,
              child: Text("Fetch and Analyze Data"),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(responseText, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
