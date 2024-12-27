import 'package:flutter/material.dart';
import 'studentdetailpt.dart'; // Ensure the import path is correct.

class TeacherRollInputPage extends StatefulWidget {
  const TeacherRollInputPage({super.key});

  @override
  _TeacherRollInputPageState createState() => _TeacherRollInputPageState();
}

class _TeacherRollInputPageState extends State<TeacherRollInputPage> {
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController rollNumberController = TextEditingController();

    // Function to validate the roll number
    bool isValidRollNumber(String rollNumber) {
      final int rollNo = int.tryParse(rollNumber) ?? -1;

      // Check if the roll number is within the valid ranges
      if (rollNo >= 111001 && rollNo <= 111030) {
        return true;
      } else if (rollNo >= 112001 && rollNo <= 112030) {
        return true;
      } else if (rollNo >= 121001 && rollNo <= 121030) {
        return true;
      } else if (rollNo >= 122001 && rollNo <= 122030) {
        return true;
      }
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Student Roll Input',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Student Roll Number',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: rollNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Roll Number',
                      prefixIcon: Icon(Icons.school, color: Colors.deepPurple),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      final rollNumber = rollNumberController.text.trim();

                      if (rollNumber.isNotEmpty && isValidRollNumber(rollNumber)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailsPage(loggedInRollNo: rollNumber),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Invalid roll number. Please enter a valid number.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
