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
      appBar: AppBar(
        title: const Text('Select Institution'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Your Institution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Institution',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
