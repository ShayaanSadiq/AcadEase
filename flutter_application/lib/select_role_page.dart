import 'package:flutter/material.dart';
import 'parent_login_page.dart'; // Import the Parent Login Page
import 'teacher_login_page.dart'; // Import the Teacher Login Page

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  _SelectRolePageState createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  String? selectedRole; // To keep track of selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == 'Parent' ? const Color.fromARGB(255, 144, 143, 143) : const Color.fromARGB(255, 211, 210, 210),
              ),
              onPressed: () {
                setState(() {
                  selectedRole = 'Parent'; // Set selected role to Parent
                });
              },
              child: const Text('I am a Parent'),
            ),
            const SizedBox(height: 20), // Space between Parent and Teacher buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == 'Teacher' ? const Color.fromARGB(255, 142, 143, 142) : const Color.fromARGB(255, 208, 206, 206),
              ),
              onPressed: () {
                setState(() {
                  selectedRole = 'Teacher'; // Set selected role to Teacher
                });
              },
              child: const Text('I am a Teacher'),
            ),
            const SizedBox(height: 20), // Space between Teacher button and Next button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 212, 212, 210)),
              onPressed: () {
                if (selectedRole != null) {
                  // Proceed only if a role is selected
                  if (selectedRole=="Parent"){
                  Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ParentLoginPage()),
                  );
                  }
                  else if(selectedRole=="Teacher"){
                   Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => TeacherLoginPage()),
                   );
                  }
                } else {
                  // Show a message if no role is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a role')),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
