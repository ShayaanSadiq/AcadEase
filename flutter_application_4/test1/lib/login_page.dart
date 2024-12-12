import 'package:flutter/material.dart';
import 'parent_home_page.dart'; // Import the Parent Home Page
import 'teacher_home_page.dart'; // Import the Teacher Home Page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for the login process
    await Future.delayed(Duration(seconds: 2));

    String username = _usernameController.text;
    String password = _passwordController.text;

    // Simulate role fetching (Replace this with actual API call)
    String role = _fetchUserRole(username, password);

    setState(() {
      _isLoading = false;
    });

    // Navigate based on role
    if (role == 'parent') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ParentHomePage()),
      );
    } else if (role == 'teacher') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TeacherHomePage()),
      );
    }
  }

  String _fetchUserRole(String username, String password) {
    // Mock logic: Replace with actual API integration
    if (username == 'parent_user') {
      return 'parent';
    } else if (username == 'teacher_user') {
      return 'teacher';
    }
    return 'general';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
    );
  }
}
