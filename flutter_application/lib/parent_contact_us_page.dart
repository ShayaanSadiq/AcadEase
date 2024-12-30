import 'package:AcadEase/parent_announcements_page.dart';
import 'package:AcadEase/select_role_page.dart';
import 'package:flutter/material.dart';
import 'UserProvider.dart';
import 'parent_apply_for_leave_page.dart';
import 'parent_concerns_page.dart';
import 'package:provider/provider.dart';
import 'parent_home_page.dart';
import 'parent_marksheet_page.dart';
import 'parent_student_details_page.dart';

class ParentContactUsPage extends StatelessWidget {
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
                    Navigator.pop(context); // Close the drawer
                    final userProvider = Provider.of<UserProvider>(context, listen: false); // Access UserProvider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentHomePage(
                          username: userProvider.username, // Pass the roll number from UserProvider
                        ),
                      ),
                    );
                  },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Student Details'),
             onTap: () {
                    Navigator.pop(context); // Close the drawer
                    final userProvider = Provider.of<UserProvider>(context, listen: false); // Access UserProvider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentDetailsPage(
                          loggedInRollNo: userProvider.username, // Pass the roll number from UserProvider
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ParentContactUsPage()),
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
                  MaterialPageRoute(builder: (context) => const SelectRolePage()),
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
            SizedBox(height: 20),
            const Center(
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
                  _buildContactInfo('College e-mail id:', 'info@testcollege.com'),
                  _buildContactInfo('Contact number:', '1234567890'),
                  SizedBox(height: 20), // Margin after college contact info

                  // Principal Email and Contact
                  _buildContactInfo('Principal e-mail id:', 'principal@testcollege.com'),
                  _buildContactInfo('Principal contact number:', '0123456789'),
                  SizedBox(height: 20), // Margin after principal contact info

                  // Vice-Principal Email and Contact
                  _buildContactInfo('Vice-Principal e-mail id:', 'viceprincipal@testcollege.com'),
                  _buildContactInfo('Vice-Principal contact number:', '0123498765'),
                  SizedBox(height: 20), // Margin after vice-principal contact info

                  // Admission-in-charge Email and Contact
                  _buildContactInfo('Admission-in-charge e-mail id:', 'admissionincharge@testcollege.com'),
                  _buildContactInfo('Admission-in-charge contact number:', '9876501234'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis, // This ensures overflow text moves to the next line
        ),
      ],
    );
  }
}
