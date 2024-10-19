import 'package:flutter/material.dart';

class ViewDronesScreen extends StatelessWidget {
  const ViewDronesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of drones (replace with actual data)
    List<Map<String, dynamic>> drones = [
      {'id': 1, 'name': 'Drone 1'},
      {'id': 2, 'name': 'Drone 2'},
      {'id': 3, 'name': 'Drone 3'},
      {'id': 4, 'name': 'Drone 4'},
      {'id': 1, 'name': 'Drone 1'},
      {'id': 2, 'name': 'Drone 2'},
      {'id': 3, 'name': 'Drone 3'},
      {'id': 4, 'name': 'Drone 4'},
      {'id': 1, 'name': 'Drone 1'},
      {'id': 2, 'name': 'Drone 2'},
      {'id': 3, 'name': 'Drone 3'},
      {'id': 4, 'name': 'Drone 4'},
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
              child: ListView.builder(
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
