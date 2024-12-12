import 'package:flutter/material.dart';
import 'select_institution_page.dart';
import 'select_role_page.dart';
import 'login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Page App',
      initialRoute: '/',
      routes: {
        '/': (context) => SelectInstitutionPage(),
        '/selectRole': (context) => SelectRolePage(),
        '/login': (context) => LoginPage(),
        
      },
    );
  }
}
