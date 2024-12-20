import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'parent_login_page.dart';

class StudentDetailsPage extends StatefulWidget {
  final dynamic loggedInRollNo1;

  const StudentDetailsPage({super.key, required this.loggedInRollNo1});

  @override
   _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final String apiUrl = 'http://127.0.0.1:5000/student_details';
  late Future<Map<String, dynamic>> _studentDetails;

  Future<Map<String, dynamic>> fetchStudentDetails() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'rollno': widget.loggedInRollNo1}),
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
      title: const Text('Student Details'),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
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
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Student Details'),
              onTap: () {},
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
      child: FutureBuilder<Map<String, dynamic>>(
        future: _studentDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final student = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                          borderRadius: BorderRadius.circular(1),
                          border: Border.all(color: Colors.deepPurple, width: 2),
                        ),
                        child: Image.memory(
                          base64Decode(student['imagePath']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                _buildTextField('Name : ${student['name']}'),
                const SizedBox(height: 16),
                _buildTextField('Roll No : ${student['rollno']}'),
                const SizedBox(height: 16),
                _buildTextField('Date of Birth : ${student['dob']}'),
                const SizedBox(height: 16),
                _buildTextField('Class/Section : ${student['class_section']}'),
                const SizedBox(height: 16),
                _buildTextField('Student Email : ${student['student_email']}'),
                const SizedBox(height: 16),
                _buildTextField('Student Phone : ${student['student_mobile']}'),
                const SizedBox(height: 16),
                _buildTextField('Father Name : ${student['father_name']}'),
                const SizedBox(height: 16),
                _buildTextField('Father Phone : ${student['father_mobile']}'),
                const SizedBox(height: 16),
                _buildTextField('Father Email : ${student['father_email']}'),
                const SizedBox(height: 16),
                _buildTextField('Mother Name : ${student['mother_name']}'),
                const SizedBox(height: 16),
                _buildTextField('Mother Phone : ${student['mother_mobile']}'),
                const SizedBox(height: 16),
                _buildTextField('Mother Email : ${student['mother_email']}'),
                const SizedBox(height: 16),
                _buildTextField('Address : ${student['address']}'),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    ),
  );
}


  Widget _buildTextField(String labelText) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(149, 117, 205, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
      ),
    );
  }
}