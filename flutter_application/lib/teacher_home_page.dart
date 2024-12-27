import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherHomePage extends StatefulWidget {
  final String username1;

  const TeacherHomePage({super.key, required this.username1});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final String teacherDetailsApiUrl = 'http://127.0.0.1:5000/teacher_details';
  final String timetableApiUrl = 'http://127.0.0.1:5000/teacher_timetable';

  late Future<Map<String, dynamic>> _teacherDetails;
  late Future<List<Map<String, dynamic>>> _timetable;

  // Fetch teacher details
  Future<Map<String, dynamic>> fetchTeacherDetails() async {
    final response = await http.post(
      Uri.parse(teacherDetailsApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': widget.username1}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Teacher details');
    }
  }

  // Fetch timetable
  Future<List<Map<String, dynamic>>> fetchTimetable() async {
    final response = await http.post(
      Uri.parse(timetableApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': widget.username1}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('timetable')) {
        return List<Map<String, dynamic>>.from(data['timetable']);
      } else {
        throw Exception(data['error'] ?? 'Failed to load timetable');
      }
    } else {
      throw Exception('Failed to fetch timetable');
    }
  }

  @override
  void initState() {
    super.initState();
    _teacherDetails = fetchTeacherDetails();
    _timetable = fetchTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Teacher Home',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Teacher Details Section
              FutureBuilder<Map<String, dynamic>>(
                future: _teacherDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final teacher = snapshot.data!;
                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/tchimg/${teacher['id']}.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red, size: 40);
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${teacher['name']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Teacher ID: ${teacher['id']}'),
                                  Text('Date of Birth: ${teacher['dob']}'),
                                  Text('Email Address: ${teacher['email']}'),
                                  Text('Phone Number: ${teacher['mobile']}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
              const SizedBox(height: 20),
              // Timetable Section
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _timetable,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final timetable = snapshot.data!;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      elevation: 3,
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          // Table Header
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Period/Day',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Monday',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Tuesday',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Wednesday',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Thursday',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Friday',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...timetable.map((row) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row['period']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row['monday']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row['tuesday']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row['wednesday']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row['thursday']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row['friday']),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  } else {
                    return const Text('No timetable available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
