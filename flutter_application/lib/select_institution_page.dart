import 'package:flutter/material.dart';

class SelectInstitutionPage extends StatefulWidget {
  const SelectInstitutionPage({super.key});

  @override
  _SelectInstitutionPageState createState() => _SelectInstitutionPageState();
}

class _SelectInstitutionPageState extends State<SelectInstitutionPage> {
  String? selectedInstitution;
  final List<String> institutions = [
    'SJTM Junior College',
    'ABC Senior High School',
    'XYZ Institute of Technology',
    'DEF Academy'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Institution')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Your Institution',
                  border: OutlineInputBorder(),
                ),
                value: selectedInstitution,
                items: institutions.map((institution) {
                  return DropdownMenuItem(
                    value: institution,
                    child: Text(institution),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedInstitution = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedInstitution != null
                    ? () {
                        Navigator.pushNamed(context, '/selectRole');
                      }
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}