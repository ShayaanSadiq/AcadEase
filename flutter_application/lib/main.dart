import 'package:flutter/material.dart';
import 'select_institution_page.dart';
import 'select_role_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi-Page App',
      initialRoute: '/',
      routes: {
        '/': (context) => SelectInstitutionPage(),
        '/selectRole': (context) => SelectRolePage(),
        
      },
    );
  }
}
