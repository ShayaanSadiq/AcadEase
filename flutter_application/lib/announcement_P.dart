import 'package:flutter/material.dart';
import 'parent_home_page.dart';
import 'studentdetailpt.dart';
import 'apply_leaveP.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF9C27B0), // Purple color for primary theme
        scaffoldBackgroundColor: const Color(0xFFF3E5F5), // Light purple background
        appBarTheme: const AppBarTheme(
          color: Color(0xFF9C27B0), // Purple color for AppBar
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFFF3E5F5), // Light purple for drawer background
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF9C27B0), // Purple color for buttons
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

class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anouncement'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.purple.shade50],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.purple.shade200],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'Announcements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.class_,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Exam Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'PTM Circular',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
