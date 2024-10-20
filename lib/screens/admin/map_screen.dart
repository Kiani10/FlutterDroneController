import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  // Set default position to Rawalpindi
  static const LatLng _rawalpindiPosition =
      LatLng(33.6844, 73.0479); // Rawalpindi's lat/lng

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _submitLocation() {
    if (_selectedLocation != null) {
      Navigator.of(context)
          .pop(_selectedLocation); // Return the selected location
    } else {
      Navigator.of(context).pop(
          _rawalpindiPosition); // Return default Rawalpindi location if no pin is placed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Colors.amber[800],
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _submitLocation, // Press 'Done' to submit location
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onTap, // Tap on the map to select location
        initialCameraPosition: CameraPosition(
          target:
              _rawalpindiPosition, // Set the default camera position to Rawalpindi
          zoom: 12, // Adjust zoom level as needed
        ),
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _selectedLocation!,
                ),
              }
            : {}, // Show marker only when location is selected
      ),
    );
  }
}
