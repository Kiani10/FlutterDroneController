import 'package:flutter/material.dart';

class AssignOperatorScreen extends StatelessWidget {
  const AssignOperatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of stations and operators (replace with actual data)
    List<Map<String, dynamic>> stations = [
      {
        'id': 1,
        'name': 'Station 1',
        'operators': ['Operator A', 'Operator B']
      },
      {
        'id': 2,
        'name': 'Station 2',
        'operators': ['Operator C', 'Operator D']
      },
      {
        'id': 3,
        'name': 'Station 3',
        'operators': ['Operator E', 'Operator F']
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, color: Colors.amber[800], size: 30),
                SizedBox(width: 10),
                Text(
                  'Assign Operator',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_city,
                                    color: Colors.amber[800]),
                                SizedBox(width: 10),
                                Text(
                                  station['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Station ID: ${station['id']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Operator',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.amber[800]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: station['operators']
                                  .map<DropdownMenuItem<String>>(
                                      (String operator) {
                                return DropdownMenuItem<String>(
                                  value: operator,
                                  child: Text(operator),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Implement operator assignment logic
                              },
                            ),
                          ],
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
