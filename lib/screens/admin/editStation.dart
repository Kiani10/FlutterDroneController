import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dronecontroller/API/api_handler.dart'; // Import your API handler
import 'map_screen.dart'; // Import the MapScreen for selecting a location

class EditStationScreen extends StatefulWidget {
  final Map<String, dynamic> station;

  const EditStationScreen({super.key, required this.station});

  @override
  State<EditStationScreen> createState() => _EditStationScreenState();
}

class _EditStationScreenState extends State<EditStationScreen> {
  LatLng? _selectedLocation;
  final ImagePicker _picker = ImagePicker(); // Image picker for gallery
  XFile? _pickedImage; // To store picked image
  late TextEditingController
      _stationNameController; // Controller for station name
  final API api = API(); // API handler instance
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _stationNameController =
        TextEditingController(text: widget.station['name']);
    debugPrint(widget.station['location']);
    _selectedLocation = LatLng(
      double.parse(widget.station['location'].split(",")[0]),
      double.parse(widget.station['location'].split(",")[1]),
    );
  }

  // Function to pick an image from gallery
  Future<void> _getImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  // Function to select location from map
  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(), // Open map to select a location
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  // Function to update the station
  Future<void> _updateStation() async {
    if (_stationNameController.text.isEmpty || _selectedLocation == null) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create station data map
      Map<String, dynamic> stationData = {
        'station_name': _stationNameController.text,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      };

      // Send the data to the server using the API handler
      var response = await api.updateStation(
        int.parse(widget.station['id']), // Pass station id to update
        stationData,
        _pickedImage != null
            ? File(_pickedImage!.path)
            : null, // Pass image file if changed
      );

      if (response.statusCode == 200) {
        // Successfully updated
        _showSuccessDialog('Station updated successfully.');
      } else {
        print('Failed to update station: ${response.body}');
        _showErrorDialog('Failed to update station. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('An error occurred. Please try again.$e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading after request is complete
      });
    }
  }

  // Error dialog display function
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Success dialog display function
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pop(context, true); // Go back to the previous screen
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
        title: Text('Edit Station'),
        backgroundColor: Colors.amber[800],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                // Station Name Text Field
                TextField(
                  controller: _stationNameController,
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
                        onPressed: _selectLocationOnMap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _selectedLocation == null ? 'Select' : 'Selected',
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
                        onPressed: _getImageFromGallery,
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
                // Update Station button
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateStation,
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
                          'Update Station',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
