import 'package:flutter/material.dart';
import 'parent_login_page.dart'; // Import the Parent Login Page

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
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
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Student Details'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Student Details page
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Announcement'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Announcement page
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Apply for Leave'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Apply for Leave page
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem),
              title: const Text('Concern'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Concern page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Replace the current page with ParentLoginPage
               Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ParentLoginPage()),
                ); 
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Parent Home Page!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
