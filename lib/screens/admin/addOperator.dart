import 'package:flutter/material.dart';

class AddOperatorScreen extends StatefulWidget {
  const AddOperatorScreen({super.key});

  @override
  State<AddOperatorScreen> createState() => _AddOperatorScreenState();
}

class _AddOperatorScreenState extends State<AddOperatorScreen> {
  var _shifts = ['Morning', 'Evening'];
  var _selectedShift = 'Morning'; // Default selected shift

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Operator.png',
                  height: 70,
                  width: 60,
                ),
                SizedBox(width: 10),
                Text(
                  'Add Operator',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Operator Name text field
            TextField(
              decoration: InputDecoration(
                labelText: 'Operator Name',
                prefixIcon: Icon(Icons.person, color: Colors.amber[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber[800]!),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Shift',
                prefixIcon: Icon(Icons.schedule, color: Colors.amber[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber[800]!),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _selectedShift,
              items: _shifts.map((String shift) {
                return DropdownMenuItem<String>(
                  value: shift,
                  child: Text(shift),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedShift = newValue!;
                });
              },
            ),
            SizedBox(height: 30),
            // Add Operator button
            ElevatedButton(
              onPressed: () {
                // Implement operator addition logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Add Operator',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
