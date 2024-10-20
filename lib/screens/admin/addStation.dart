import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_screen.dart'; // Import the MapScreen for selecting a location

class AddStationScreen extends StatefulWidget {
  const AddStationScreen({super.key});

  @override
  State<AddStationScreen> createState() => _AddStationScreenState();
}

class _AddStationScreenState extends State<AddStationScreen> {
  LatLng? _selectedLocation; // Variable to store selected location
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  XFile? _pickedImage; // To store picked image

  Future<void> _getImageFromGallery() async {
    // Function to select image from gallery
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _selectLocationOnMap() async {
    // Navigate to MapScreen and get the selected location
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(), // Open map to select a location
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result; // Save the selected location
      });
    }
  }

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
                  'assets/images/Hellipad.png',
                  height: 70,
                  width: 60,
                ),
                SizedBox(width: 10),
                Text(
                  'Add Station',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Station Name Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Station Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Select Location Row
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.amber[800]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _selectLocationOnMap, // Open Google Map to select location
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      _selectedLocation == null
                          ? 'Select'
                          : 'Selected', // Change button text if location is selected
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Display selected latitude and longitude
            if (_selectedLocation != null)
              Text(
                'Location Selected: Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                style: TextStyle(fontSize: 16, color: Colors.amber[800]),
              ),
            SizedBox(height: 20),
            // Launching Pad label and Browse Button
            Row(
              children: [
                Icon(Icons.flight_takeoff, color: Colors.amber[800]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Launching Pad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _getImageFromGallery, // Pick image from gallery
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Browse',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Preview selected image
            if (_pickedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            SizedBox(height: 20),
            // Add Station button
            ElevatedButton(
              onPressed: () {
                // Handle adding the station with the selected location and image
                if (_selectedLocation != null) {
                  print(
                      'Location Selected: Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}');
                  if (_pickedImage != null) {
                    print('Image Selected: ${_pickedImage!.path}');
                  }
                } else {
                  print('No location selected');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Add Station',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
