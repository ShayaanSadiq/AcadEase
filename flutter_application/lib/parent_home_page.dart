import 'dart:convert';
import 'announcement_P.dart';
import 'apply_leaveP.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'parent_login_page.dart';
import 'studentdetailpt.dart';
import 'package:provider/provider.dart';
import 'marksheet_page.dart';
import 'UserProvider.dart'; // Keep this as the main UserProvider import
import 'concerns.dart';

class ParentHomePage extends StatefulWidget {
  final String username;  // Added username parameter

  const ParentHomePage({super.key, required this.username});
  

  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

      class _ParentHomePageState extends State<ParentHomePage> {
        final String apiUrl = 'http://127.0.0.1:5000/student_details';
        late Future<Map<String, dynamic>> _studentDetails = Future.value({});
        // Add this at line 18 (inside _ParentHomePageState class)
        Future<Map<DateTime, double>> _attendanceData = Future.value({});


        Future<Map<String, dynamic>> fetchStudentDetails(String rollNo) async {
            print('Fetching student details for rollNo: $rollNo');
            final response = await http.post(
              Uri.parse(apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'rollno': rollNo}),  // Ensure rollNo is passed correctly
            );

            if (response.statusCode == 200) {
              return json.decode(response.body);
            } else {
              throw Exception('Failed to load student details');
            }
          }

          Future<Map<DateTime, double>> fetchAttendance(String username) async {
                print('Fetching attendance for username: $username');
                final response = await http.post(
                  Uri.parse('http://127.0.0.1:5000/get_attendance'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({'rollno': username.toString()}),  // Ensure username is passed correctly
                );

                if (response.statusCode == 200) {
                  final Map<String, dynamic> data = json.decode(response.body);
                  // Convert the values from int to double
                  return data.map((key, value) => MapEntry(DateTime.parse(key), value.toDouble()));
                } else {
                  throw Exception('Failed to fetch attendance data');
                }
              }


        // Update initState function at line 40
          @override
          void initState() {
            super.initState();
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            String username = userProvider.username;
            
            setState(() {
              _studentDetails = fetchStudentDetails(username);
              _attendanceData = fetchAttendance(username);
            });
          }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
              onTap: () {
                Navigator.pop(context);
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
                    builder: (context) => StudentDetailsPage(
                      loggedInRollNo: userProvider.username,
                    ),
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
                  MaterialPageRoute(builder: (context) => AnnouncementsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: Colors.deepPurple),
              title: const Text('Marksheet'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MarksPage()),
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
                  MaterialPageRoute(builder: (context) => ApplyForLeavePage()),
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
                  MaterialPageRoute(builder: (context) => ConcernsPage()),
                );
              },
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
                Navigator.pop(context);
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
                padding: const EdgeInsets.only(top: 40),
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

                      final imagePath = 'assets/stdimg/${student['rollno']}.png';

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(10),
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
          FutureBuilder<Map<DateTime, double>>(
            future: _attendanceData,
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
                final attendance = snapshot.data!;
                return TableCalendar(
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
                    cellMargin: EdgeInsets.all(5.0),
                    outsideDaysVisible: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      // Normalize the date by removing time components
                      DateTime normalizedDay = DateTime(day.year, day.month, day.day);

                      if (attendance.containsKey(normalizedDay)) {
                        final percentage = attendance[normalizedDay]!;
                        int roundedPercentage = percentage.round();

                        // Determine background color based on attendance percentage
                        Color bgColor;
                        if (roundedPercentage >= 75) {
                          bgColor = Colors.green;
                        } else if (roundedPercentage >= 50) {
                          bgColor = Colors.orange;
                        } else {
                          bgColor = Colors.red;
                        }

                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                );
              } else {
                return const Text('No attendance data available');
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