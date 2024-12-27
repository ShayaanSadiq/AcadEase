import 'package:flutter/material.dart';

void main() {
  runApp(ContactUsApp());
}

class ContactUsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactUsPage(),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AcadEase'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
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
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle "Home" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Student Details'),
              onTap: () {
                // Handle "Student Details" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.campaign_sharp),
              title: Text('Announcements'),
              onTap: () {
                // Handle "Announcements" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.download_rounded),
              title: Text('Upload Attendance'),
              onTap: () {
                // Handle "Marksheet" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Upload Marksheet'),
              onTap: () {
                // Handle "Marksheet" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Apply for Leave'),
              onTap: () {
                // Handle "Apply for Leave" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.announcement),
              title: Text('Concerns'),
              onTap: () {
                // Handle "Concerns" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                // Handle "Contact Us" navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle "Logout" navigation
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
            SizedBox(height: 20),
            Center(
              child: Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // College Email and Contact
                  Row(
                    children: [
                      Text(
                        'College e-mail id: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'info@testcollege.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Contact number: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '1234567890',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Margin after college contact info

                  // Principal Email and Contact
                  Row(
                    children: [
                      Text(
                        'Principal e-mail id: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'principal@testcollege.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Principal contact number: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '0123456789',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Margin after principal contact info

                  // Vice-Principal Email and Contact
                  Row(
                    children: [
                      Text(
                        'Vice-Principal e-mail id: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'viceprincipal@testcollege.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Vice-Principal contact number: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '0123498765',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Margin after vice-principal contact info

                  // Admission-in-charge Email and Contact without space
                  Row(
                    children: [
                      Text(
                        'Admission-in-charge e-mail id: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10), // Space between label and email
                      Text(
                        'admissionincharge@testcollege.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Admission-in-charge contact number: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10), // Space between label and number
                      Text(
                        '9876501234',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
