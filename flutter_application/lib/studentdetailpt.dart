import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentDetailsPage(),
    );
  }
}

class StudentDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AcadEase'),
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
              onTap: () {},
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
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepPurple, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField('Name :'),
                const SizedBox(height: 16),
                _buildTextField('Roll No :'),
                const SizedBox(height: 16),
                _buildTextField('Date of Birth :'),
                const SizedBox(height: 16),
                _buildTextField('Class/Section :'),
                const SizedBox(height: 32),
                _buildTextField('Student Email :'),
                const SizedBox(height: 16),
                _buildTextField('Student Phone :'),
                const SizedBox(height: 16),
                _buildTextField('Father Name :'),
                const SizedBox(height: 16),
                _buildTextField('Father Phone :'),
                const SizedBox(height: 16),
                _buildTextField('Father Email :'),
                const SizedBox(height: 16),
                _buildTextField('Mother Name :'),
                const SizedBox(height: 16),
                _buildTextField('Mother Phone :'),
                const SizedBox(height: 16),
                _buildTextField('Mother Email :'),
                const SizedBox(height: 16),
                _buildTextField('Address :'),
              ],
            ),
          ),
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
          borderSide: BorderSide(color: const Color.fromRGBO(149, 117, 205, 1)),
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