import 'package:flutter/material.dart';
import 'parent_login_page.dart'; // Import the Parent Login Page
import 'teacher_login_page.dart'; // Import the Teacher Login Page

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectRolePageState createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  String? selectedRole; // To keep track of selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 115, 39, 255), Color.fromARGB(255, 231, 214, 255)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedRole == 'Parent'
                            ? Colors.deepPurple.shade400
                            : Colors.deepPurple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRole = 'Parent'; // Set selected role to Parent
                        });
                      },
                      child: const Text(
                        "I'm a Parent",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Space between Parent and Teacher buttons
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedRole == 'Teacher'
                            ? Colors.deepPurple.shade400
                            : Colors.deepPurple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRole = 'Teacher'; // Set selected role to Teacher
                        });
                      },
                      child: const Text(
                        "I'm a Teacher",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Space between Teacher button and Next button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        if (selectedRole != null) {
                          // Proceed only if a role is selected
                          if (selectedRole == "Parent") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParentLoginPage()),
                            );
                          } else if (selectedRole == "Teacher") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherLoginPage()),
                            );
                          }
                        } else {
                          // Show a message if no role is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a role'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
