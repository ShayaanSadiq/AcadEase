import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentDetailsPage extends StatefulWidget {
  final String loggedInRollNo;

  const StudentDetailsPage({
    Key? key,
    required this.loggedInRollNo,
  }) : super(key: key);

  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final String apiUrl = 'http://127.0.0.1:5000/student_details'; // Replace with your host machine's IP
  late Future<Map<String, dynamic>> _studentDetails;

  Future<Map<String, dynamic>> fetchStudentDetails() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rollno': widget.loggedInRollNo}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to fetch details: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Network error: $e'};
    }
  }

  @override
  void initState() {
    super.initState();
    _studentDetails = fetchStudentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AcadEase'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.deepPurple),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Student Details'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _studentDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final student = snapshot.data!;
              if (student.containsKey('error')) {
                return Center(
                  child: Text(
                    'Error: ${student['error']}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.deepPurple, width: 2),
                          ),
                          child: (student['imagePath'] != null && student['imagePath'] is String)
                              ? Image.memory(
                                  base64Decode(student['imagePath']),
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.deepPurple,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Name', student['name']),
                      const SizedBox(height: 16),
                      _buildDetailRow('Roll No', student['rollno'].toString()),
                      const SizedBox(height: 16), // Ensure it's converted to a String
                      _buildDetailRow('Date of Birth', student['dob']),
                      const SizedBox(height: 16),
                      _buildDetailRow('Class/Section', student['class_section'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Student Email', student['student_email'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Student Phone', student['student_mobile'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Father Name', student['father_name'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Father Phone', student['father_mobile'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Father Email', student['father_email'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Mother Name', student['mother_name'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Mother Phone', student['mother_mobile'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Mother Email', student['mother_email'].toString()),
                      const SizedBox(height: 16),
                      _buildDetailRow('Address', student['address'].toString()),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
