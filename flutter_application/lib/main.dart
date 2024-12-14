import 'package:flutter/material.dart';
import 'select_institution_page.dart';
import 'select_role_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acadease',
      initialRoute: '/',
      routes: {
        '/': (context) => const SelectInstitutionPage(),
        '/selectRole': (context) => const SelectRolePage(),
        
      },
    );
  }
}
