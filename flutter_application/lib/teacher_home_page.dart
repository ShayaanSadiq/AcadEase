import 'package:flutter/material.dart';
import 'teacher_login_page.dart';
import 'markatt.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Teacher Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Student Details'),
              onTap: () {
                // Navigate to Student Details screen
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Announcements'),
              onTap: () {
                // Navigate to Announcements screen
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Concerns'),
              onTap: () {
                // Navigate to Concerns screen
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Upload Student Attendance'),
              onTap: () {
                // Navigate to Upload Student Attendance screen
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AttendancePage()),
                ); // Close the drawer
              },
            ),
            const Divider(), // Divider between options and logout
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the login screen when the user logs out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherLoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Teacher Home Page!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
