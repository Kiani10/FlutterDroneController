import 'package:flutter/material.dart';

class AddDroneScreen extends StatefulWidget {
  const AddDroneScreen({super.key});

  @override
  _AddDroneScreenState createState() => _AddDroneScreenState();
}

class _AddDroneScreenState extends State<AddDroneScreen> {
  final List<String> _stations = [
    'Station 1',
    'Station 2',
    'Station 3',
    'Station 4',
  ];
  String? _selectedStation;

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
              // Add drone form fields with icons
              _buildTextField(
                labelText: 'Drone Name',
                icon: Icons.flight,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Ceiling (meters)',
                icon: Icons.height,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Speed (km/h)',
                icon: Icons.speed,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Battery Life (hours)',
                icon: Icons.battery_full,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                labelText: 'Payload Capacity (kg)',
                icon: Icons.line_weight,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              // Dropdown for selecting station
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Assign to Station',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedStation,
                items: _stations.map((String station) {
                  return DropdownMenuItem<String>(
                    value: station,
                    child: Text(station),
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
                onPressed: () {
                  // Implement drone addition logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
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
  }) {
    return TextField(
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
