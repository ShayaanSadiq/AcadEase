import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'announcement_P.dart';
import 'apply_leaveP.dart';
import 'studentdetailpt.dart';
import 'parent_home_page.dart';
import 'parent_login_page.dart';
import 'concerns.dart';


class MarksPage extends StatefulWidget {
  @override
  _MarksPageState createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  late Future<Map<String, dynamic>> marksFuture;

  // Function to fetch the marks from the API
  Future<Map<String, dynamic>> fetchMarks(String username) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/marksheet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN_HERE', // Optional, for secure API calls
        'Username': username, // Custom header to pass the username
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load marks');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the username from UserProvider and trigger the API call
    final username = Provider.of<UserProvider>(context, listen: false).username;
    marksFuture = fetchMarks(username);
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username;

    if (username.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("No Username Found"),
        ),
        body: const Center(child: Text("Please set the username first.")),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Student Marks',
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: marksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Exams are not conducted yet.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            final marksData = snapshot.data!;

            // Check for missing data keys
            List<String> examKeys = ['fa1', 'fa2', 'sa1', 'fa3', 'fa4', 'sa2'];
            Map<String, dynamic> processedData = {};
            for (var key in examKeys) {
              processedData[key] = marksData.containsKey(key) ? marksData[key] : null;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marks for $username',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const Divider(
                          color: Colors.deepPurple,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),
                        // Display FA and SA Marks
                        buildMarkRow('FA1', processedData['fa1']),
                        buildMarkRow('FA2', processedData['fa2']),
                        buildMarkRow('SA1', processedData['sa1']),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        buildMarkRow('FA3', processedData['fa3']),
                        buildMarkRow('FA4', processedData['fa4']),
                        buildMarkRow('SA2', processedData['sa2']),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget to display each exam mark (e.g., FA1, FA2, etc.)
  Widget buildMarkRow(String examName, dynamic mark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            examName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mark != null ? mark.toString() : 'Exams not conducted yet',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
