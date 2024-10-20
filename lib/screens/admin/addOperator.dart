import 'package:dronecontroller/API/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class AddOperatorScreen extends StatefulWidget {
  final String adminName; // Accept admin name as a parameter
  const AddOperatorScreen({super.key, required this.adminName});

  @override
  State<AddOperatorScreen> createState() => _AddOperatorScreenState();
}

class _AddOperatorScreenState extends State<AddOperatorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password
  var _shifts = ['Morning', 'Evening'];
  var _selectedShift = 'Morning'; // Default selected shift
  bool _isLoading = false; // To handle loading state

  // Function to create a new operator using API call
  Future<void> _addOperator() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    // Prepare operator data for the request
    Map<String, dynamic> operatorData = {
      'name': _nameController.text,
      'passwrd': _passwordController.text, // Password for the user
      'shift': _selectedShift,
    };

    try {
      API api = API();
      var response =
          await api.createOperator(operatorData); // Call API to create operator
      if (response.statusCode == 201) {
        _showSuccessDialog(); // Operator added successfully
      } else {
        _showErrorDialog('Failed to add operator');
      }
    } catch (e) {
      _showErrorDialog('An error occurred while adding the operator.');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  // Success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Operator added successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushReplacementNamed(
                context,
                '/adminDashboard',
                arguments: {'adminName': widget.adminName}, // Pass admin name
              );

              /// Navigate to dashboard
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Operator'),
        backgroundColor: Colors.amber[800],
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView here
        child: Padding(
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
                controller: _nameController,
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
              // Operator Password text field
              TextField(
                controller: _passwordController,
                obscureText: true, // Password field
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.amber[800]),
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
                onPressed: _isLoading
                    ? null
                    : _addOperator, // Call _addOperator on press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add Operator',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
