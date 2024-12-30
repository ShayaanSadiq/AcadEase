import 'dart:convert';
import 'package:AcadEase/UserProvider.dart';
import 'package:AcadEase/teacher_announcements_page.dart';
import 'package:AcadEase/teacher_apply_leave_page.dart';
import 'package:AcadEase/teacher_concern_page.dart';
import 'package:AcadEase/teacher_home_page.dart';
import 'package:AcadEase/teacher_login_page.dart';
import 'package:AcadEase/teacher_roll_input_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? _selectedClass;
  String? _selectedPeriod;
  final List<String> _classes = ['elevena', 'elevenb', 'twelvea', 'twelveb']; // Class options
  final List<String> _periods = ['period_1', 'period_2', 'period_3', 'period_4', 'period_5', 'period_6']; // Period options
  List<String> _students = [];
  final Map<String, bool> _absentStudents = {}; // Tracking absence status


  // Function to fetch logged-in students
  Future<void> _fetchLoggedInStudents(String selectedClass) async {
    if (selectedClass.isEmpty) {
      print("No class selected.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get_logged_in_students?class=$selectedClass'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _students = List<String>.from(data.map((student) => student['rollNumber'].toString()));
          _absentStudents.clear();
          for (var student in _students) {
            _absentStudents[student] = false; // Initially mark all as present
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to load students'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("Error fetching students: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while fetching students'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Function to mark absentees
  Future<void> _markAbsentees() async {
    if (_selectedClass == null || _selectedPeriod == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a class and period'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    List<String> absentList = [];
    _absentStudents.forEach((student, isAbsent) {
      if (isAbsent) {
        absentList.add(student);
      }
    });

    if (absentList.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5000/mark_absent'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'class': _selectedClass,
            'absentees': absentList,
            'period': _selectedPeriod,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Attendance updated successfully'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to update attendance'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred while updating attendance'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No absentees selected'),
        backgroundColor: Colors.orange,
      ));
    }
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
                  MaterialPageRoute(builder: (context) => ApplyForTeacherLeavePage()),
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
              title: const Text('Upload Student Attendance  '),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AttendancePage()),
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
                  MaterialPageRoute(builder: (context) => TeacherLoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Class/Section',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedClass,
              hint: const Text('Select Class/Section'),
              isExpanded: true,
              items: _classes.map((String className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (String? newClass) {
                setState(() {
                  _selectedClass = newClass;
                  _students = []; // Clear previous student list
                });
                if (newClass != null) {
                  _fetchLoggedInStudents(newClass); // Fetch logged-in students
                }
              },
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedPeriod,
              hint: const Text('Select Period'),
              isExpanded: true,
              items: _periods.map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (String? newPeriod) {
                setState(() {
                  _selectedPeriod = newPeriod;
                });
              },
            ),
            const SizedBox(height: 20),
            if (_students.isNotEmpty) ...[
              const Text(
                'Select absentees:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    String student = _students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 3,
                      child: CheckboxListTile(
                        title: Text(student),
                        value: _absentStudents[student],
                        onChanged: (bool? value) {
                          setState(() {
                            _absentStudents[student] = value!;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _markAbsentees,
              child: const Text('Mark Absentees'),
            ),
          ],
        ),
      ),
    );
  }
}
