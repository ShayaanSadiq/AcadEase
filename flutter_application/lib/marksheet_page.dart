import 'package:flutter/material.dart';

void main() {
  runApp(MarksheetApp());
}

class MarksheetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.deepPurple.shade100,
        ),
      ),
      home: MarksheetScreen(),
    );
  }
}

class MarksheetScreen extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {"subject": "Math", "marks": 95},
    {"subject": "Science", "marks": 88},
    {"subject": "English", "marks": 92},
    {"subject": "History", "marks": 85},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marksheet"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      // Add Drawer (Menu bar)
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
                // Navigate to Home when pressed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MarksheetScreen()),
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
            const Text(
              "Student Name: John Doe",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.deepPurple.shade300,
                  width: 2,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Subject",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Marks",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  for (var subject in subjects)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(subject['subject']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(subject['marks'].toString()),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
