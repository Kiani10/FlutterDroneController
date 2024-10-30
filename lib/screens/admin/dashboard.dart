import 'package:dronecontroller/login.dart';
import 'package:flutter/material.dart';
import 'package:dronecontroller/screens/admin/addOperator.dart';
import 'package:dronecontroller/screens/admin/viewDrone.dart';
import 'package:dronecontroller/screens/admin/viewStation.dart';

class AdminDashboard extends StatefulWidget {
  final String adminName; // Pass the admin's name
  const AdminDashboard({Key? key, required this.adminName}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      // Show confirmation dialog when Logout is tapped
      _confirmLogout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Function to show a confirmation dialog for logout
  void _confirmLogout() async {
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Dismiss dialog
              child: Text('No'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // Confirm logout
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    // If the user confirms, navigate to the login screen and clear the navigation stack
    if (shouldLogout == true) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Dashboard Section with Welcome message (Top Section with Border)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.black26,
                      width: 2), // Border around the section
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Welcome, ${widget.adminName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: _buildWideDashboardButton(
                        icon: Icons.support_agent,
                        label: 'Operator',
                        gradientColors: [
                          Colors.blueAccent,
                          Colors.lightBlueAccent
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOperatorScreen(
                                      adminName: widget.adminName,
                                    )),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: _buildWideDashboardButton(
                        icon: Icons.flight_takeoff,
                        label: 'Drone',
                        gradientColors: [Colors.green, Colors.lightGreenAccent],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewDronesScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildWideDashboardButton(
                          icon: Icons.airplanemode_active,
                          label: 'Station',
                          gradientColors: [
                            Colors.deepOrangeAccent,
                            Colors.orangeAccent
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewStationsScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: 'Logout',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }

  // Function to create wide buttons with gradient background and icons
  Widget _buildWideDashboardButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(width: 30),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
