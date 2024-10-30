import 'dart:convert';
import 'package:dronecontroller/screens/admin/addStation.dart';
import 'package:dronecontroller/screens/admin/editStation.dart';
import 'package:flutter/material.dart';
import 'package:dronecontroller/API/api_handler.dart';

class ViewStationsScreen extends StatefulWidget {
  const ViewStationsScreen({super.key});

  @override
  _ViewStationsScreenState createState() => _ViewStationsScreenState();
}

class _ViewStationsScreenState extends State<ViewStationsScreen> {
  final API api = API(); // Use the provided API class
  List<Map<String, dynamic>> stations = []; // Initialize station list as empty
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStations(); // Fetch stations when the screen loads
  }

  // Function to fetch stations from the API
  Future<void> _fetchStations() async {
    try {
      var response = await api.getStations(); // Fetch stations using API

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> stationList = jsonDecode(response.body);
        setState(() {
          stations = stationList
              .map<Map<String, dynamic>>((station) => {
                    'id': station['id'].toString(),
                    'name': station['name'].toString(),
                    'location': station['location'].toString(),
                  })
              .toList();

          _isLoading = false;
        });
      } else {
        print('Failed to load stations');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching stations: $e');
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
                  'Stations',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Add Drone screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStationScreen(
                        adminName: '',
                      ), // AddDrone screen
                    ),
                  ).then((value) {
                    // Refresh the drone list after returning
                    _fetchStations();
                  });
                },
                icon: Icon(Icons.add),
                label: Text("Add Station"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800], // Button color
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        final station = stations[index];
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
                                child: Image.asset(
                                  'assets/images/Hellipad.png',
                                  height: 70,
                                  width: 60,
                                ),
                              ),
                              title: Text(
                                station['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('ID: ${station['id']}'),
                              trailing: IconButton(
                                icon:
                                    Icon(Icons.edit, color: Colors.amber[800]),
                                onPressed: () async {
                                  debugPrint(station['location']);
                                  // Navigate to edit screen with station data
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditStationScreen(
                                        station: station, // Pass station data
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _fetchStations();
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
