import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
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
            // Menu Items
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Student Details'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Student Details")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Attendance'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Attendance")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.request_page),
              title: Text('Apply for Leave'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Apply for Leave")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.announcement),
              title: Text('Announcements'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Announcements")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Raise Concern'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Raise Concern")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Marksheet'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Marksheet")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigate to Contact Us")),
                );
              },
            ),
            Divider(), // Divider between menu items
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
