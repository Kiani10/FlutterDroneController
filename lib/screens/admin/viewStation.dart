import 'package:flutter/material.dart';

class ViewStationsScreen extends StatelessWidget {
  const ViewStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of drones (replace with actual data)
    List<Map<String, dynamic>> stations = [
      {'id': 1, 'name': 'Saddar'},
      {'id': 2, 'name': '6th Road'},
      {'id': 3, 'name': 'Chandani Chowk'},
      {'id': 4, 'name': 'Rehmanabad'},
    ];

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
            Expanded(
              child: ListView.builder(
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  final drone = stations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber[800],
                          child: //Icon(Icons.air, color: Colors.amber[800], size: 30),
                              Image.asset(
                            'assets/images/Hellipad.png',
                            height: 70,
                            width: 60,
                          ),
                        ),
                        title: Text(
                          drone['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('ID: ${drone['id']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Colors.amber[800]),
                          onPressed: () {},
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
