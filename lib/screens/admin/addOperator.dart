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
  List<Map<String, dynamic>> _stations = []; // Store stations with id and name
  String? _selectedStation; // Selected station ID
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password
  var _shifts = ['Morning', 'Evening'];
  var _selectedShift = 'Morning'; // Default selected shift
  bool _isLoading = false; // To handle loading state
  API api = API();

  @override
  void initState() {
    super.initState();
    _fetchStations(); // Fetch stations when the screen loads
  }

  // Fetch stations from API
  Future<void> _fetchStations() async {
    try {
      var response = await api.getStations();
      if (response.statusCode == 200) {
        List<dynamic> stationList = jsonDecode(response.body);
        if (stationList.isEmpty) {
          //in that case we have to bounce back to the dashboard because
          //if there are no stations then how a operator is assiged -->mean logoic is there
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('First add station so that you can add operator'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Back to the dashboard
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        setState(() {
          _stations = stationList.map<Map<String, dynamic>>((station) {
            return {
              'id': station['id'].toString(),
              'name': station['name'].toString(),
            };
          }).toList();
        });
      } else {
        print('Failed to load stations');
      }
    } catch (e) {
      print('Error fetching stations: $e');
    }
  }

  // Function to create a new operator using API call
  Future<void> _addOperator() async {
    // Check if any field is empty
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedShift.isEmpty) {
      _showErrorDialog('All fields are required.');
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    // Prepare operator data for the request
    Map<String, dynamic> operatorData = {
      'name': _nameController.text,
      'email': _emailController.text, // Added email field
      'passwrd': _passwordController.text, // Password for the user
      'shift': _selectedShift,
    };

    try {
      var response =
          await api.createOperator(operatorData); // Call API to create operator
      if (response.statusCode == 201) {
        var operator = jsonDecode(response.body); // Get the created drone
        // Create StationDroneRecord to associate drone with station
        Map<String, dynamic> stationOperatorRecord = {
          'operator_id': operator['id'], // Get station id
          'station_id': _selectedStation, // Use selected station id
        };
        debugPrint(stationOperatorRecord.toString());
        var recordResponse =
            await api.createStationOperatorRecord(stationOperatorRecord);

        if (recordResponse.statusCode == 201) {
          // Success: navigate back or show success message
          _showSuccessDialog();
        }
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
              print(widget.adminName);
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
              // Operator Email text field
              TextField(
                controller: _emailController, // Added email field
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.amber[800]),
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
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Assign to Station',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedStation,
                items: _stations.map((station) {
                  return DropdownMenuItem<String>(
                    value: station['id'], // Pass station ID
                    child: Text(station['name']), // Show station name
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStation = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
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
