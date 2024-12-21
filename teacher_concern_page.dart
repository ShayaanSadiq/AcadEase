import 'package:flutter/material.dart';

import 'flutter/packages/flutter/lib/cupertino.dart';
import 'flutter/packages/flutter/lib/material.dart';
import 'flutter/packages/flutter/lib/painting.dart';
import 'flutter/packages/flutter/lib/rendering.dart';

void main() {
  runApp(TeacherConcernApp());
}

class TeacherConcernApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Concern Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TeacherConcernPage(),
    );
  }
}

class TeacherConcernPage extends StatefulWidget {
  @override
  _TeacherConcernPageState createState() => _TeacherConcernPageState();
}

class _TeacherConcernPageState extends State<TeacherConcernPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Concern Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: ['Technical', 'Curriculum', 'Other']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _concernController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Concern',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your concern';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle submission logic here
                      String name = _nameController.text;
                      String category = _selectedCategory!;
                      String concern = _concernController.text;

                      // For demonstration, showing a dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Concern Submitted'),
                          content: Text(
                              'Name: $name\nCategory: $category\nConcern: $concern'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );

                      // Clear the form fields
                      _nameController.clear();
                      _concernController.clear();
                      setState(() {
                        _selectedCategory = null;
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
