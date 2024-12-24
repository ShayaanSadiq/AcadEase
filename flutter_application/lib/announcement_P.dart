import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserProvider.dart';
import 'apply_leaveP.dart';
import 'concerns.dart';
import 'package:provider/provider.dart';
import 'parent_home_page.dart';
import 'marksheet_page.dart';
import 'studentdetailpt.dart';
import 'parent_login_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF9C27B0),
        scaffoldBackgroundColor: const Color(0xFFF3E5F5),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF9C27B0),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFFF3E5F5),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF9C27B0),
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.deepPurple),
          bodyMedium: TextStyle(color: Colors.deepPurple),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: AnnouncementsPage(),
    );
  }
}

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  List announcements = [];

  // Fetch announcements from Flask API
  Future<void> fetchAnnouncements() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/announcements'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isEmpty) {
        setState(() {
          announcements = [];
        });
      } else if (data is Map && data.containsKey('message')) {
        setState(() {
          announcements = [];
        });
      } else {
        setState(() {
          announcements = data;
        });
      }
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.purple.shade200],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
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
      body: announcements.isEmpty
          ? const Center(child: Text('No Announcements Available'))
          : ListView.builder(
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              announcement['subject'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              announcement['date'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          announcement['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
