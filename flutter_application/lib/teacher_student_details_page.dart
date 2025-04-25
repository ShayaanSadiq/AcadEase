import 'dart:convert';
import 'package:AcadEase/UserProvider.dart';
import 'package:AcadEase/teacher_announcements_page.dart';
import 'package:AcadEase/teacher_apply_leave_page.dart';
import 'package:AcadEase/teacher_mark_attendance_page.dart';
import 'package:AcadEase/teacher_concern_page.dart';
import 'package:AcadEase/teacher_home_page.dart';
import 'package:AcadEase/teacher_login_page.dart';
import 'package:AcadEase/teacher_roll_input_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StudentDetailsTeacherPage extends StatefulWidget {
  final String loggedInRollNo;

  const StudentDetailsTeacherPage({
    super.key,
    required this.loggedInRollNo,
  });

  @override
  _StudentDetailsTeacherPageState createState() => _StudentDetailsTeacherPageState();
}

class _StudentDetailsTeacherPageState extends State<StudentDetailsTeacherPage> {
  final String apiUrl = 'http://127.0.0.1:5000/student_details';
  late Future<Map<String, dynamic>> _studentDetails;

  Future<Map<String, dynamic>> fetchStudentDetails() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rollno': widget.loggedInRollNo}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Student Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
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
              onTap: () {
                Navigator.pop(context);
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherHomePage(username1: userProvider.username1),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Student Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeacherRollInputPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign_sharp, color: Colors.deepPurple),
              title: const Text('Announcements'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherAnnouncementsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.deepPurple),
              title: const Text('Apply for Leave'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ApplyForTeacherLeavePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement, color: Colors.deepPurple),
              title: const Text('Concerns'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherConcernPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.deepPurple),
              title: const Text('Upload Student Attendance'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendancePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurple),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherLoginPage()),
                );
              },
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

              final imagePath = 'assets/stdimg/${student['rollno']}.png';

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 63),
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
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 40,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Name', student['name']),
                      _buildDetailRow('Roll No', student['rollno'].toString()),
                      const SizedBox(height: 16), 
                      _buildDetailRow('Date of Birth', student['dob']),
                      _buildDetailRow('Class/Section', student['class_section'].toString()),
                      _buildDetailRow('Student Email', student['student_email'].toString()),
                      _buildDetailRow('Student Phone', student['student_mobile'].toString()),
                      _buildDetailRow('Father Name', student['father_name'].toString()),
                      _buildDetailRow('Father Phone', student['father_mobile'].toString()),
                      _buildDetailRow('Father Email', student['father_email'].toString()),
                      _buildDetailRow('Mother Name', student['mother_name'].toString()),
                      _buildDetailRow('Mother Phone', student['mother_mobile'].toString()),
                      _buildDetailRow('Mother Email', student['mother_email'].toString()),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple, width: 1.5),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}