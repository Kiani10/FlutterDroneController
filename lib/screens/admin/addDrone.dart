import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dronecontroller/API/api_handler.dart'; // Import your API handler

class AddDroneScreen extends StatefulWidget {
  const AddDroneScreen({super.key});

  @override
  _AddDroneScreenState createState() => _AddDroneScreenState();
}

class _AddDroneScreenState extends State<AddDroneScreen> {
  final API api = API();
  List<Map<String, dynamic>> _stations = []; // Store stations with id and name
  String? _selectedStation; // Selected station ID
  final TextEditingController _droneNameController = TextEditingController();
  final TextEditingController _ceilingController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  final TextEditingController _batteryLifeController = TextEditingController();
  final TextEditingController _payloadController = TextEditingController();
  bool _isLoading = false; // Loading state

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

  // Validate form inputs
  bool _validateForm() {
    if (_droneNameController.text.isEmpty ||
        _ceilingController.text.isEmpty ||
        _speedController.text.isEmpty ||
        _batteryLifeController.text.isEmpty ||
        _payloadController.text.isEmpty ||
        _selectedStation == null) {
      return false;
    }
    return true;
  }

  // Function to add a drone and link it to a station
  Future<void> _addDrone() async {
    if (!_validateForm()) {
      // Show error if fields are not valid
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Create drone data
      Map<String, dynamic> droneData = {
        'name': _droneNameController.text,
        'ceiling': double.parse(_ceilingController.text),
        'speed': double.parse(_speedController.text),
        'battery': double.parse(_batteryLifeController.text),
        'payload': double.parse(_payloadController.text),
      };

      // Save the drone
      var droneResponse = await api.createDrone(droneData);
      if (droneResponse.statusCode == 201) {
        var drone = jsonDecode(droneResponse.body); // Get the created drone

        // Create StationDroneRecord to associate drone with station
        Map<String, dynamic> stationDroneRecord = {
          'drone_id': drone['id'], // Get drone id
          'station_id': _selectedStation, // Use selected station id
        };

        var recordResponse =
            await api.createStationDroneRecord(stationDroneRecord);

        if (recordResponse.statusCode == 201) {
          // Success: navigate back or show success message
          _showSuccessDialog('Drone added successfully.');
        } else {
          _showErrorDialog('Failed to link drone to station.');
        }
      } else {
        _showErrorDialog('Failed to add drone.');
      }
    } catch (e) {
      print('Error adding drone: $e');
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.pop(context); // Go back to previous screen
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
      body: SingleChildScrollView(
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
                    'assets/images/AddDrone.png',
                    height: 70,
                    width: 60,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add Drone',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Drone Name',
                icon: Icons.flight,
                controller: _droneNameController,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Ceiling (meters)',
                icon: Icons.height,
                keyboardType: TextInputType.number,
                controller: _ceilingController,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Speed (km/h)',
                icon: Icons.speed,
                keyboardType: TextInputType.number,
                controller: _speedController,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Battery Life (hours)',
                icon: Icons.battery_full,
                keyboardType: TextInputType.number,
                controller: _batteryLifeController,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Payload Capacity (kg)',
                icon: Icons.line_weight,
                keyboardType: TextInputType.number,
                controller: _payloadController,
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
              ElevatedButton(
                onPressed:
                    _isLoading ? null : _addDrone, // Disable when loading
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
                        'Add Drone',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with icons
  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.amber[800]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber[800]!),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
