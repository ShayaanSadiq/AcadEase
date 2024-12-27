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
      setState(() {
          announcements = data.map((announcement) {
            return {
              'subject': announcement['subject'],
              'description': announcement['desc'], // Map 'desc' to 'description'
              'date': announcement['date'],
            };
          }).toList();
        });

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
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Parent Home',
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
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.purple.shade200],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.deepPurple),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParentHomePage(username: userProvider.username),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Student Details'),
              onTap: () {
                Navigator.pop(context);
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailsPage(loggedInRollNo: userProvider.username),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: announcements.isEmpty
            ? const Center(
                child: Text(
                  'No Announcements Available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  announcement['subject'] ?? 'No Subject', // Default fallback
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(
                                  announcement['date'] ?? 'No Date', // Default fallback
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              announcement['description'] ?? 'No Description', // Default fallback
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

      ),
    );
  }
}
