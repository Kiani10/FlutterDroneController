import 'dart:convert';
import 'package:dronecontroller/screens/admin/editDrone';
import 'package:flutter/material.dart';
import 'package:dronecontroller/API/api_handler.dart';

class ViewDronesScreen extends StatefulWidget {
  const ViewDronesScreen({super.key});

  @override
  _ViewDronesScreenState createState() => _ViewDronesScreenState();
}

class _ViewDronesScreenState extends State<ViewDronesScreen> {
  final API api = API(); // Use the provided API class
  List<Map<String, dynamic>> drones = []; // Initialize drone list as empty
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDrones(); // Fetch drones when the screen loads
  }

  // Function to fetch drones from the API
  Future<void> _fetchDrones() async {
    try {
      var response = await api.getDrones(); // Fetch drones using API

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> droneList = jsonDecode(response.body);

        setState(() {
          drones = droneList
              .map<Map<String, dynamic>>((drone) => {
                    'id': drone['id'].toString(),
                    'name': drone['name'].toString(),
                    'ceiling': drone['ceiling'].toString(),
                    'speed': drone['speed'].toString(),
                    'battery': drone['battery'].toString(),
                    'payload': drone['payload'].toString(),
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        print('Failed to load drones');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching drones: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list_alt,
                  size: 60,
                  color: Colors.amber[800],
                ),
                SizedBox(width: 10),
                Text(
                  'Drones',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: drones.length,
                      itemBuilder: (context, index) {
                        final drone = drones[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber[800],
                                child: Icon(Icons.airplanemode_active,
                                    color: Colors.white),
                              ),
                              title: Text(
                                drone['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('ID: ${drone['id']}'),
                              trailing: IconButton(
                                icon:
                                    Icon(Icons.edit, color: Colors.amber[800]),
                                onPressed: () async {
                                  // Navigate to edit screen with drone data
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditDroneScreen(
                                        drone: drone, // Pass drone data
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _fetchDrones();
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
