import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'parent_login_page.dart';
import 'studentdetailpt.dart';
import 'announcement_P.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'concerns.dart';
import 'parent_home_page.dart';
import 'marksheet_page.dart';

class ApplyForLeavePage extends StatefulWidget {
  const ApplyForLeavePage({super.key});

  @override
  _ApplyForLeavePageState createState() => _ApplyForLeavePageState();
}

class _ApplyForLeavePageState extends State<ApplyForLeavePage> {
  String? _selectedDuration;
  bool _showCustomDuration = false;
  bool _isLoading = false;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  Future<void> submitLeaveRequest() async {
    String? userRollNumber =
        Provider.of<UserProvider>(context, listen: false).username;

    String duration = _selectedDuration ?? "Not Selected";
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;
    String reason = _reasonController.text;

    if (_selectedDuration == null ||
        reason.isEmpty ||
        (_showCustomDuration && (startDate.isEmpty || endDate.isEmpty))) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all required fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:5000/add_leave');

    final Map<String, dynamic> data = {
      'rollno': userRollNumber,
      'desc': reason,
      'duration': duration,
      if (_showCustomDuration) 'start_date': startDate,
      if (_showCustomDuration) 'end_date': endDate,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Leave request submitted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final responseMessage = json.decode(response.body)['message'] ?? '';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(
                'Failed to submit leave request. $responseMessage Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Apply for Leave',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade300,
                    Colors.deepPurple.shade700
                  ],
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailsPage(
                      loggedInRollNo: UserProvider().username,
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurple),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Duration',
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.deepPurple.shade50,
                        ),
                        value: _selectedDuration,
                        hint: const Text("Select an option"),
                        items: ['Full Day', 'Half Day', 'Custom']
                            .map((duration) => DropdownMenuItem(
                                  value: duration,
                                  child: Text(duration),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDuration = value;
                            _showCustomDuration = value == 'Custom';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_showCustomDuration) ...[
                        TextField(
                          controller: _startDateController,
                          decoration: InputDecoration(
                            labelText: 'Start Date (YYYY-MM-DD)',
                            labelStyle: const TextStyle(color: Colors.deepPurple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.deepPurple.shade50,
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _endDateController,
                          decoration: InputDecoration(
                            labelText: 'End Date (YYYY-MM-DD)',
                            labelStyle: const TextStyle(color: Colors.deepPurple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.deepPurple.shade50,
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: _reasonController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          alignLabelWithHint: true,
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.deepPurple.shade50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : submitLeaveRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Submit',
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
      ),
    );
  }
}
