import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'parent_login_page.dart';
import 'studentdetailpt.dart';

class ParentHomePage extends StatefulWidget {
  final String loggedInRollNo;

  const ParentHomePage({super.key, required this.loggedInRollNo});

  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  final String apiUrl = 'http://10.0.2.2:5000/student_details';
  late Future<Map<String, dynamic>> _studentDetails;

  Future<Map<String, dynamic>> fetchStudentDetails() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'rollno': widget.loggedInRollNo}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load student details');
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
          'Parent Home',
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Student Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailsPage( // Pass the rollNo parameter
                      loggedInRollNo: widget.loggedInRollNo, // Pass the loggedInRollNo parameter
                    ),
                  ),
                );
              },


            ),
            ListTile(
              leading: const Icon(Icons.campaign_sharp, color: Colors.deepPurple),
              title: const Text('Announcements'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.deepPurple),
              title: const Text('Apply for Leave'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.announcement, color: Colors.deepPurple),
              title: const Text('Concerns'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.deepPurple),
              title: const Text('Contact Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurple),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the login screen when the user logs out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ParentLoginPage()),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 40), // Adjust the top padding value here
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _studentDetails,
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
                      final student = snapshot.data!;
                      if (student.containsKey('error')) {
                        return Center(
                          child: Text(
                            'Error: ${student['error']}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              student['imagePath'] != null
                                  ? Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.memory(
                                        base64Decode(student['imagePath']),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.person, size: 40),
                                    ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${student['name']}',
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text('Roll No: ${student['rollno']}'),
                                    Text('Father Name: ${student['father_name']}'),
                                    Text('Mother Name: ${student['mother_name']}'),
                                    Text('Father Mobile: ${student['father_mobile']}'),
                                    Text('Mother Mobile: ${student['mother_mobile']}'),
                                    Text('Address: ${student['address']}'),
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
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}

extension IntToString on int {
  String toStringExtension() {
    return this.toString();  // Converts int to String
  }
}


