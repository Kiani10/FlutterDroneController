import 'dart:convert';
import 'dart:io';
import 'package:dronecontroller/API/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddMissionScreen extends StatefulWidget {
  final String operatorName; // Accept operator name as a parameter
  const AddMissionScreen({super.key, required this.operatorName});

  @override
  _AddMissionScreenState createState() => _AddMissionScreenState();
}

class _AddMissionScreenState extends State<AddMissionScreen> {
  final TextEditingController _locationPadController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<LatLng> _selectedCoordinates = [];
  GoogleMapController? _mapController;
  File? _image;
  int? _selectedDrone; // Change to store drone ID instead of name

  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _drones =
      []; // Store drone objects with both ID and name

  API api = API(); // Instantiate the API class.

  @override
  void initState() {
    super.initState();
    _fetchDrones(); // Fetch drones from API when the screen is initialized.
  }

  Future<void> _fetchDrones() async {
    try {
      var response =
          await api.getDrones(); // Using the API class to fetch drones.
      if (response.statusCode == 200) {
        List<dynamic> droneList = jsonDecode(response.body);
        setState(() {
          _drones.addAll(droneList.map((drone) {
            return {
              'id': drone['id'],
              'name': drone['name']
            }; // Store drone ID and name
          }).toList());
        });
      } else {
        _showErrorDialog('Failed to load drones');
      }
    } catch (e) {
      _showErrorDialog('Error occurred while fetching drones.');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedCoordinates.add(location);
    });
  }

  void _removeCoordinate(LatLng coordinate) {
    setState(() {
      _selectedCoordinates.remove(coordinate);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  Future<void> _submitMission() async {
    if (_selectedDrone == null) {
      _showErrorDialog('Please select a drone.');
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      _showErrorDialog('Please select a date and time.');
      return;
    }
    if (_locationPadController.text.isEmpty) {
      _showErrorDialog('Please enter a location pad.');
      return;
    }
    if (_selectedCoordinates.length < 2) {
      _showErrorDialog('Please select at least two points on the map.');
      return;
    }
    if (_image == null) {
      _showErrorDialog('Please upload an image.');
      return;
    }

    String formattedDateTime =
        "${_selectedDate!.toIso8601String().split('T')[0]}";
    String formattedTime =
        "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00";
    String formattedDateTimeFinal =
        "$formattedDateTime $formattedTime"; // Format the datetime correctly

    Map<String, dynamic> missionData = {
      "coordinates": _selectedCoordinates
          .map((coord) =>
              {"latitude": coord.latitude, "longitude": coord.longitude})
          .toList(),
      "mission_datetime": formattedDateTimeFinal,
      "location_pad": _locationPadController.text,
      "drone_id": _selectedDrone, // This will now be the drone ID
    };

    try {
      var response = await api.createMission(
          missionData, _image); // Using the API class to create a mission.
      if (response.statusCode == 201) {
        Navigator.of(context).pop(); // Navigate back on success.
      } else {
        _showErrorDialog('Failed to create mission.');
      }
    } catch (e) {
      _showErrorDialog('Error occurred while submitting the mission.');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Mission'),
        backgroundColor: Colors.amber[800],
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _submitMission, // Submit the mission
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drone Dropdown
            DropdownButtonFormField<int>(
              value: _selectedDrone,
              hint: Text("Select Drone"),
              onChanged: (value) {
                setState(() {
                  _selectedDrone = value; // Store the drone ID
                });
              },
              items: _drones.map((drone) {
                return DropdownMenuItem<int>(
                  value: drone['id'], // Use the drone ID as the value
                  child: Text(drone['name']), // Display the drone name
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Location Pad Input
            TextField(
              controller: _locationPadController,
              decoration: InputDecoration(
                labelText: "Location Pad",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Map for selecting coordinates
            Container(
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _onTap,
                initialCameraPosition: CameraPosition(
                  target: LatLng(33.6844, 73.0479), // Default to Rawalpindi
                  zoom: 12,
                ),
                markers: _selectedCoordinates.map((coord) {
                  return Marker(
                    markerId: MarkerId(coord.toString()),
                    position: coord,
                    onTap: () {
                      _removeCoordinate(coord);
                    },
                  );
                }).toSet(),
              ),
            ),
            SizedBox(height: 16),

            // Date and Time Picker
            ElevatedButton(
              onPressed: _selectDateTime,
              child: Text(
                _selectedDate == null
                    ? 'Select Date & Time'
                    : "${_selectedDate!.toLocal()} at ${_selectedTime!.format(context)}",
              ),
            ),
            SizedBox(height: 16),

            // Image Picker
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 16),

            // Show uploaded image if available
            if (_image != null)
              Image.file(
                _image!,
                height: 150,
              ),
          ],
        ),
      ),
    );
  }
}
