import 'package:AcadEase/select_institution_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // Initialize provider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectInstitutionPage(), // Starting point
    );
  }
}
