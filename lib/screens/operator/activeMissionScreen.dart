import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dronecontroller/API/api_handler.dart';
import 'package:intl/intl.dart';

class ActiveMissionScreen extends StatefulWidget {
  int operatorId;
  ActiveMissionScreen({super.key, required this.operatorId});

  @override
  _ActiveMissionScreenState createState() => _ActiveMissionScreenState();
}

class _ActiveMissionScreenState extends State<ActiveMissionScreen> {
  final API api = API();
  List<Map<String, dynamic>> missions = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchActiveMissions();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(hours: 1), (timer) {
      _fetchActiveMissions();
    });
  }

  // Fetch active missions and filter out those that are ended
  Future<void> _fetchActiveMissions() async {
    try {
      var response = await api.getMissions(widget.operatorId);

      if (response.statusCode == 200) {
        List<dynamic> missionList = jsonDecode(response.body);

        setState(() {
          missions = missionList
              .map<Map<String, dynamic>>((mission) => {
                    'id': mission['id'].toString(),
                    'name': mission['location_pad'].toString(),
                    'status': mission['status'].toString(),
                    'mission_datetime': mission['mission_datetime'].toString(),
                    'drone_id': mission['drone_id'].toString(),
                  })
              .where((mission) =>
                  mission['status'] == "1" &&
                  _getMissionStatus(mission['mission_datetime']) != "Ended")
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

  // Function to get mission status
  String _getMissionStatus(String missionDateTime) {
    DateTime? missionTime;
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');

    try {
      missionTime = dateFormat.parse(missionDateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid Date";
    }

    DateTime now = DateTime.now();

    // Determine the mission status
    if (now.isAfter(missionTime) && now.difference(missionTime).inDays >= 1) {
      return "Ended";
    } else if (now.isAfter(missionTime) || now.isAtSameMomentAs(missionTime)) {
      return "Started";
    } else {
      return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          // Replacing Column with ListView
          children: [
            SizedBox(height: 20),
            // Icon and Title
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
                  'Active Missions',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final mission = missions[index];
                      final missionStatus =
                          _getMissionStatus(mission['mission_datetime']);
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
                              mission['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${mission['id']}'),
                                Text('Mission: ${mission['name']}'),
                                Text('Status: $missionStatus'),
                                Text(
                                    'Last Updated: ${mission['mission_datetime']}'),
                              ],
                            ),
                            trailing: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      bool? confirm = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmation'),
                                            content: Text(
                                                'Are you sure you want to abort this mission?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirm == true) {
                                        await api.updateMission(
                                            int.parse(mission['id']), 2);
                                        _fetchActiveMissions();
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.amber[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  missionStatus == "Pending"
                                      ? SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: () async {
                                            bool? confirm = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirmation'),
                                                  content: Text(
                                                      'Are you sure this mission is completed?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirm == true) {
                                              await api.updateMission(
                                                  int.parse(mission['id']), 3);
                                              _fetchActiveMissions();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
