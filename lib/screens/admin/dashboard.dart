import 'package:dronecontroller/screens/admin/addDrone.dart';
import 'package:dronecontroller/screens/admin/addOperator.dart';
import 'package:dronecontroller/screens/admin/addStation.dart';
import 'package:dronecontroller/screens/admin/assignOperator.dart';
import 'package:dronecontroller/screens/admin/viewDrone.dart';
import 'package:dronecontroller/screens/admin/viewStation.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  String Admin = 'Waleed';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 105.0),
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.amber[800],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Welcome $Admin',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                  children: [
                    _buildFunctionalityTile(
                      context,
                      'Add Station',
                      Icons.add_location,
                      Colors.green,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddStationScreen()));
                      },
                    ),
                    _buildFunctionalityTile(
                      context,
                      'Add Drone',
                      Icons.airplanemode_active,
                      Colors.blue,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDroneScreen()));
                      },
                    ),
                    _buildFunctionalityTile(
                      context,
                      'View Drones',
                      Icons.dns,
                      Colors.purple,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewDronesScreen()));
                      },
                    ),
                    _buildFunctionalityTile(
                      context,
                      'Add Operator',
                      Icons.person_add,
                      Colors.orange,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOperatorScreen()));
                      },
                    ),
                    _buildFunctionalityTile(
                      context,
                      'Assign Operator',
                      Icons.assignment_ind,
                      Colors.red,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssignOperatorScreen()));
                      },
                    ),
                    _buildFunctionalityTile(
                      context,
                      'View Stations',
                      Icons.location_city,
                      Colors.teal,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewStationsScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildFunctionalityTile(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.3),
              radius: 30,
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
