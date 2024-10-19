import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStationScreen extends StatefulWidget {
  const AddStationScreen({super.key});

  @override
  State<AddStationScreen> createState() => _AddStationScreenState();
}

class _AddStationScreenState extends State<AddStationScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _getImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
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
                //Icon(Icons.air, color: Colors.amber[800], size: 30),
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
            // Station Name text field
            TextField(
              decoration: InputDecoration(
                labelText: 'Station Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Location label and button
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
                    onPressed: () {
                      // Implement location selection logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Select',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Launching Pad label and button
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
            if (_pickedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
            ],
            // Add Station button
            ElevatedButton(
              onPressed: () {
                // Implement station addition logic
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
