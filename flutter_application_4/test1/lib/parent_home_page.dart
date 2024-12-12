import 'package:flutter/material.dart';
import 'parent_login_page.dart'; // Import the Parent Login Page

class ParentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Student Details'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Student Details page
              },
            ),
            ListTile(
              leading: Icon(Icons.announcement),
              title: Text('Announcement'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Announcement page
              },
            ),
            ListTile(
              leading: Icon(Icons.request_page),
              title: Text('Apply for Leave'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Apply for Leave page
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('Concern'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Concern page
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
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
      body: Center(
        child: Text(
          'Welcome to the Parent Home Page!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
