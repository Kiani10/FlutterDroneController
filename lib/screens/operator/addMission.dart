import 'dart:convert';
import 'dart:io';
import 'package:dronecontroller/API/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddMissionScreen extends StatefulWidget {
  final String operatorName; // Accept operator name as a parameter
  final int operatorId; // Accept operator name as a parameter
  const AddMissionScreen(
      {super.key, required this.operatorName, required this.operatorId});

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
  int? _selectedDrone;
  Set<Polyline> _polylines = {};

  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _drones = [];

  API api = API();

  @override
  void initState() {
    super.initState();
    _fetchDrones();
  }

  Future<void> _fetchDrones() async {
    try {
      var response = await api.getSpecificDrones(widget.operatorId);
      if (response.statusCode == 200) {
        List<dynamic> droneList = jsonDecode(response.body);
        setState(() {
          _drones.addAll(droneList.map((drone) {
            return {'id': drone['id'], 'name': drone['name']};
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
      _updatePolyline();
    });
  }

  // Function to update the polyline for drawing the path
  void _updatePolyline() {
    final polyline = Polyline(
      polylineId: PolylineId("mission_path"),
      points: _selectedCoordinates,
      color: Colors.blue,
      width: 4,
    );

    setState(() {
      _polylines = {polyline};
    });
  }

  void _removeCoordinate(LatLng coordinate) {
    setState(() {
      _selectedCoordinates.remove(coordinate);
      _updatePolyline();
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
    String formattedDateTimeFinal = "$formattedDateTime $formattedTime";

    Map<String, dynamic> missionData = {
      "coordinates": _selectedCoordinates
          .map((coord) =>
              {"latitude": coord.latitude, "longitude": coord.longitude})
          .toList(),
      "mission_datetime": formattedDateTimeFinal,
      "location_pad": _locationPadController.text,
      "status": "1",
      "drone_id": _selectedDrone,
    };

    try {
      var response = await api.createMission(missionData, _image);
      if (response.statusCode == 201) {
        Navigator.of(context).pop();
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
            onPressed: _submitMission,
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
                  _selectedDrone = value;
                });
              },
              items: _drones.map((drone) {
                return DropdownMenuItem<int>(
                  value: drone['id'],
                  child: Text(drone['name']),
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
                  target: LatLng(33.6844, 73.0479),
                  zoom: 12,
                ),
                markers: _buildMarkers(), // Call function to build markers
                polylines: _polylines,
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

  // Method to build markers with customized start and end markers
  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    for (int i = 0; i < _selectedCoordinates.length; i++) {
      final coord = _selectedCoordinates[i];

      // Use different marker colors for the first, last, and intermediate markers
      markers.add(
        Marker(
          markerId: MarkerId(coord.toString()),
          position: coord,
          icon: i == 0
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen) // Start marker
              : i == _selectedCoordinates.length - 1
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed) // End marker
                  : BitmapDescriptor.defaultMarker, // Intermediate markers
          onTap: () {
            _removeCoordinate(coord);
          },
        ),
      );
    }
    return markers;
  }
}
