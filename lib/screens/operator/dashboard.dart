import 'package:dronecontroller/screens/operator/addMission.dart';
import 'package:flutter/material.dart';

class OperatorDashboard extends StatefulWidget {
  final String operatorName; // Pass the operator's name
  const OperatorDashboard({Key? key, required this.operatorName})
      : super(key: key);

  @override
  _OperatorDashboardState createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends State<OperatorDashboard> {
  int _selectedIndex = 0;

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
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    'Operator Dashboard',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Welcome, ${widget.operatorName}', // Display operator's name
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFunctionalityTile(
                      context,
                      'Add Mission',
                      Icons.add_task,
                      Colors.blue,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMissionScreen(
                                      operatorName: widget.operatorName,
                                    )));
                      },
                    ),
                    SizedBox(height: 30),
                    _buildFunctionalityTile(
                      context,
                      'History',
                      Icons.history,
                      Colors.blue,
                      () {
                        // Add navigation to "History" screen
                      },
                    ),
                    SizedBox(height: 30),
                    _buildFunctionalityTile(
                      context,
                      'Active',
                      Icons.check_circle_outline,
                      Colors.blue,
                      () {
                        // Add navigation to "Active" screen
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
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildFunctionalityTile(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 150, // Set width based on your layout requirements
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
