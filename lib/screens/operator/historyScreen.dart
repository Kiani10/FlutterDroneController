import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dronecontroller/API/api_handler.dart';
import 'package:intl/intl.dart';

class ViewHistoryScreen extends StatefulWidget {
  final int operatorId;
  const ViewHistoryScreen({super.key, required this.operatorId});

  @override
  _ViewHistoryScreenState createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  final API api = API();
  List<Map<String, dynamic>> completedMissions = [];
  List<Map<String, dynamic>> abortedMissions = [];
  bool _isLoading = true;
  bool _showCompleted = true; // Track which list to show

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    try {
      var response = await api.getMissions(widget.operatorId);

      if (response.statusCode == 200) {
        List<dynamic> missionList = jsonDecode(response.body);

        setState(() {
          completedMissions = missionList
              .map<Map<String, dynamic>>((mission) => {
                    'drone_id': mission['drone_id'].toString(),
                    'name': mission['location_pad'].toString(),
                    'mission_datetime': mission['mission_datetime'].toString(),
                    'status': mission['status'],
                  })
              .where(
                  (mission) => mission['status'] == 3) // Status 3 for completed
              .toList();

          abortedMissions = missionList
              .map<Map<String, dynamic>>((mission) => {
                    'drone_id': mission['drone_id'].toString(),
                    'name': mission['location_pad'].toString(),
                    'mission_datetime': mission['mission_datetime'].toString(),
                    'status': mission['status'],
                  })
              .where(
                  (mission) => mission['status'] == 2) // Status 2 for aborted
              .toList();

          _isLoading = false;
        });
      } else {
        print('Failed to load missions');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching missions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Format date and time
  String _formatDateTime(String dateTime) {
    DateTime parsedDateTime =
        DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(dateTime, true).toLocal();
    return DateFormat('dd/MM/yyyy | hh:mm a').format(parsedDateTime);
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
                  'History',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Toggle Buttons for Completed and Aborted
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showCompleted = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _showCompleted ? Colors.green : Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Completed"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showCompleted = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !_showCompleted ? Colors.green : Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Aborted"),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Displaying the List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _showCompleted
                          ? completedMissions.length
                          : abortedMissions.length,
                      itemBuilder: (context, index) {
                        final mission = _showCompleted
                            ? completedMissions[index]
                            : abortedMissions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            color: Colors
                                .blue, // Background color for mission list
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      mission['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      _formatDateTime(
                                          mission['mission_datetime']),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
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
